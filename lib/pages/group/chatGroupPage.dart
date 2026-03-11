import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fe/pages/group/models/group_model.dart';
import 'package:fe/pages/group/models/chat_message_model.dart';
import 'package:fe/pages/group/repository/participant_repository.dart';
import 'package:fe/services/chat_service.dart';
import 'package:fe/services/auth_service.dart';
import 'package:fe/api/api_client.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class ChatGroupPage extends StatefulWidget {
  final Group group;

  const ChatGroupPage({super.key, required this.group});

  @override
  State<ChatGroupPage> createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  final ChatService _chatService = ChatService();
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final Map<String, String> _participantNamesById = {};

  StreamSubscription? _messageSubscription;
  StreamSubscription? _historySubscription;
  StreamSubscription? _joinedSubscription;
  StreamSubscription? _errorSubscription;
  String? _currentUserId;
  bool _isLoading = true;
  bool _isSending = false;
  bool _hasReceivedHistory = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      _currentUserId = await getUserId();
      await _loadParticipantNames();

      // 1. เชื่อมต่อ Socket.io
      await _chatService.connect();

      // 2. ฟัง Stream แยกตาม event
      _messageSubscription = _chatService.messageStream.listen((data) {
        _handleNewMessage(data);
      });

      _historySubscription = _chatService.chatHistoryStream.listen((messages) {
        _hasReceivedHistory = true;
        _handleChatHistory(messages);
      });

      _joinedSubscription = _chatService.joinedGroupStream.listen((groupId) {
        print('✅ Successfully joined group: $groupId');
        // โหลดประวัติข้อความทันทีเมื่อ join สำเร็จ
        _chatService.loadMessages(widget.group.id, limit: 50);
      });

      _errorSubscription = _chatService.errorStream.listen((error) {
        _showError(error);
      });

      // 3. ส่งคำสั่ง Join Group
      _chatService.joinGroup(widget.group.id);

      // เรียกโหลด history ทันทีอีกรอบเพื่อกันกรณี event room_joined มาช้า/ตกหล่น
      _chatService.loadMessages(widget.group.id, limit: 50);

      // fallback: ถ้าไม่ได้ history ทาง WebSocket ภายใน 2 วิ ให้ดึงผ่าน REST
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && !_hasReceivedHistory) {
          _loadHistoryFromRest();
        }
      });

      // Timeout: ปิด loading หลัง 3 วินาทีถ้ายังไม่ได้รับ room_joined
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isLoading) {
          setState(() => _isLoading = false);
          print('⏱️ Loading timeout - showing chat interface');
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Connection failed: $e');
    }
  }

  Future<void> _loadParticipantNames() async {
    try {
      final participants = await _participantRepository.getParticipantsByGroup(
        widget.group.id,
      );

      if (!mounted) return;
      setState(() {
        for (final participant in participants) {
          _participantNamesById[participant.userId] = participant.name;
        }
      });
    } catch (_) {
      // Ignore fallback name loading errors. Chat still works with payload usernames.
    }
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    print('🔥 NEW MESSAGE RECEIVED: $data');
    try {
      final newMessage = ChatMessage.fromJson(data);
      setState(() {
        _messages.add(newMessage);
      });
      _scrollToBottom();
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void _handleChatHistory(List<dynamic> messagesData) {
    print('📜 Chat history received: ${messagesData.length} messages');
    try {
      final history = messagesData
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();

      setState(() {
        _mergeMessages(history);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error parsing chat history: $e');
    }
  }

  Future<void> _loadHistoryFromRest() async {
    try {
      final response = await ApiClient().dio.get(
        '/groups/${widget.group.id}/messages',
        queryParameters: {'limit': 50, 'offset': 0},
      );

      final dynamic data = response.data;
      final List<dynamic> rows = data is List
          ? data
          : (data is Map<String, dynamic> && data['data'] is List)
              ? data['data'] as List<dynamic>
              : <dynamic>[];

      final history = rows
          .whereType<Map>()
          .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
          .toList();

      if (!mounted) return;
      setState(() {
        _mergeMessages(history);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print('REST history fallback failed: $e');
    }
  }

  void _mergeMessages(List<ChatMessage> incoming) {
    final merged = <String, ChatMessage>{for (final m in _messages) m.id: m};

    for (final message in incoming) {
      final fallbackKey = message.id.isNotEmpty
          ? message.id
          : '${message.userId}_${message.createdAt.toIso8601String()}';
      merged[fallbackKey] = message;
    }

    _messages
      ..clear()
      ..addAll(
        merged.values.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      _chatService.sendMessage(widget.group.id, message);
      _messageController.clear();
    } catch (e) {
      _showError('Failed to send: $e');
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _historySubscription?.cancel();
    _joinedSubscription?.cancel();
    _errorSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Color(0xFF4A3A4A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.title,
              style: const TextStyle(
                color: Color(0xFF4A3A4A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${widget.group.joinedMemberCount} participants',
              style: const TextStyle(
                color: Color(0xFF8B7A99),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD8A7D9)),
                  )
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedMessageMultiple02,
                              color: Color(0xFFD8A7D9).withOpacity(0.3),
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No messages yet',
                              style: TextStyle(
                                color: Color(0xFF8B7A99),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start the conversation!',
                              style: TextStyle(
                                color: Color(0xFF8B7A99),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isMe = message.userId == _currentUserId;
                          final showDate = index == 0 ||
                              !_isSameDay(
                                _messages[index - 1].createdAt,
                                message.createdAt,
                              );

                          return Column(
                            children: [
                              if (showDate)
                                _buildDateDivider(message.createdAt),
                              _buildMessageBubble(message, isMe),
                            ],
                          );
                        },
                      ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    String dateText;
    // Convert to Thai timezone (UTC+7)
    final thaiDate = date.add(const Duration(hours: 7));
    final thaiNow = DateTime.now().add(const Duration(hours: 7));
    final today = DateTime(thaiNow.year, thaiNow.month, thaiNow.day);
    final messageDate = DateTime(thaiDate.year, thaiDate.month, thaiDate.day);

    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(thaiDate);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0xFFD8A7D9).withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateText,
              style: const TextStyle(
                color: Color(0xFF8B7A99),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Color(0xFFD8A7D9).withOpacity(0.3))),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    final senderName = isMe
        ? 'You'
        : (message.userName.isNotEmpty && message.userName != 'Unknown'
            ? message.userName
            : (_participantNamesById[message.userId] ?? 'Member'));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFD8A7D9) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF8B7A99),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isMe ? Colors.white : const Color(0xFF4A3A4A),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatThaiTime(message.createdAt),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF8B7A99),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _buildAvatar(),
        ],
      ),
    );
  }

  /// Format time in Thai timezone (UTC+7)
  String _formatThaiTime(DateTime utcTime) {
    // Bangkok timezone is UTC+7
    final thaiTime = utcTime.add(const Duration(hours: 7));
    return DateFormat('h:mm a').format(thaiTime);
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF6DDE4),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedUser,
          color: Color(0xFFD8A7D9),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Color(0xFF8B7A99),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8A7D9),
                  disabledBackgroundColor: const Color(
                    0xFFD8A7D9,
                  ).withOpacity(0.5),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const HugeIcon(
                        icon: HugeIcons.strokeRoundedSent,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    // Convert to Thai timezone (UTC+7) for comparison
    final thai1 = date1.add(const Duration(hours: 7));
    final thai2 = date2.add(const Duration(hours: 7));
    return thai1.year == thai2.year &&
        thai1.month == thai2.month &&
        thai1.day == thai2.day;
  }

  void _scrollToBottom() {
    // ใช้ WidgetsBinding เพื่อรอให้ Flutter วาด UI (Frame) เสร็จก่อน
    // จึงจะสามารถสั่ง Scroll ไปยังจุดสุดท้ายที่มีข้อความใหม่ได้แม่นยำ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

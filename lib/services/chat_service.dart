import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatService {
  WebSocketChannel? _channel;
  final _storage = const FlutterSecureStorage();
  Timer? _pingTimer;
  StreamSubscription? _messageSubscription;

  // Stream Controllers
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatHistoryController = StreamController<List<dynamic>>.broadcast();
  final _joinedGroupController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();

  // Public Streams
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<List<dynamic>> get chatHistoryStream => _chatHistoryController.stream;
  Stream<String> get joinedGroupStream => _joinedGroupController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String _resolveSocketBaseUrl(String rawUrl) {
    final uri = Uri.parse(rawUrl);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final host = uri.host.toLowerCase();
      if (host == 'localhost' || host == '127.0.0.1') {
        return uri.replace(host: '10.0.2.2').toString();
      }
    }

    return rawUrl;
  }

  Future<void> connect() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final socketUrl = _resolveSocketBaseUrl(
        dotenv.env['WEBSOCKET_URL'] ?? 'http://127.0.0.1:8081',
      );
      final wsUrl = socketUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');
      final connectionUrl = Uri.parse('$wsUrl/ws')
          .replace(queryParameters: {'token': token}).toString();

      print('🔌 Connecting to WebSocket: $connectionUrl');

      _channel = WebSocketChannel.connect(Uri.parse(connectionUrl));

      _messageSubscription = _channel!.stream.listen(
        (dynamic data) {
          _handleIncomingMessage(data);
        },
        onError: (error) {
          print('🔴 WebSocket Error: $error');
          _isConnected = false;
          _errorController.add('Connection error: $error');
        },
        onDone: () {
          print('❌ WebSocket Disconnected');
          _isConnected = false;
          _stopPingTimer();
        },
      );

      _isConnected = true;
      print('✅ WebSocket Connected successfully');

      _startPingTimer();
    } catch (e) {
      print('🔴 Connection setup failed: $e');
      _errorController.add('Connection failed: $e');
      _isConnected = false;
      rethrow;
    }
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final raw = data is String ? data : data.toString();
      final chunks =
          raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty);

      for (final chunk in chunks) {
        final Map<String, dynamic> message =
            jsonDecode(chunk) as Map<String, dynamic>;
        final String type = (message['type'] ?? '').toString();
        final Map<String, dynamic> payload =
            (message['payload'] as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{};

        print('📨 Received message type: $type');

        switch (type) {
          case 'message':
          case 'chat_message':
            print('💬 New message: ${payload['message']}');
            _messageController.add(payload);
            break;

          case 'chat_history':
            final List<dynamic> history = payload['messages'] as List? ?? [];
            _chatHistoryController.add(history);
            break;

          case 'room_joined':
            final String roomId = (payload['room_id'] ?? '').toString();
            print('✅ Successfully joined room: $roomId');
            _joinedGroupController.add(roomId);
            break;

          case 'user_typing':
          case 'typing':
            _typingController.add(payload);
            break;

          case 'pong':
            print('💓 Heartbeat OK');
            break;

          case 'error':
            final String errorMsg =
                (payload['message'] ?? 'Unknown error').toString();
            _errorController.add(errorMsg);
            break;

          default:
            print('⚠️ Unknown message type: $type');
            print('   Payload: $payload');
        }
      }
    } catch (e) {
      print('🔴 Error parsing message: $e');
    }
  }

  void _sendMessage(String type, Map<String, dynamic> payload) {
    if (!_isConnected || _channel == null) {
      print('⚠️ Cannot send message: not connected');
      _errorController.add('Not connected to server');
      return;
    }

    try {
      final message = jsonEncode({'type': type, 'payload': payload});

      _channel!.sink.add(message);
      print('📤 Sent message type: $type');
    } catch (e) {
      print('🔴 Error sending message: $e');
      _errorController.add('Failed to send message: $e');
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) {
        _sendMessage('ping', {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void joinGroup(String groupId) {
    print('🔄 Joining group: $groupId');
    _sendMessage('join_room', {'room_id': groupId});
  }

  void leaveGroup(String groupId) {
    print('🔄 Leaving group: $groupId');
    _sendMessage('leave_room', {'room_id': groupId});
  }

  void sendMessage(String groupId, String message) {
    if (message.trim().isEmpty) return;

    print('📤 Sending message to group $groupId: $message');
    _sendMessage('chat_message', {
      'room_id': groupId,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void loadMessages(String groupId, {int limit = 50, int offset = 0}) {
    print('📥 Loading messages for group $groupId');
    _sendMessage('load_history', {
      'room_id': groupId,
      'limit': limit,
      'offset': offset,
    });
  }

  void sendTypingStatus(String groupId, bool isTyping) {
    _sendMessage('typing', {'room_id': groupId, 'is_typing': isTyping});
  }

  void disconnect() {
    print('🔌 Disconnecting from WebSocket');
    _stopPingTimer();
    _messageSubscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _chatHistoryController.close();
    _joinedGroupController.close();
    _errorController.close();
    _typingController.close();
  }
}

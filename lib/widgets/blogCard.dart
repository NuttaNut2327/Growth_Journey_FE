import 'package:fe/pages/blog/editBlogPage.dart';
import 'package:fe/pages/blog/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:fe/services/auth_service.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fe/pages/blog/enum/report_type.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/widgets/secondButton.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  final Future<void> Function()? onChanged;

  const BlogCard({super.key, required this.blog, this.onChanged});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late bool isLiked;
  late int totalLikes;
  bool isSubmitting = false;
  String? _currentUserId;
  final _blogRepository = BlogRepository();

  bool get _isOwner =>
      _currentUserId != null && _currentUserId == widget.blog.userId;

  DateTime? get _createdAt => DateTime.tryParse(widget.blog.creatTime);
  DateTime? get _updatedAt => DateTime.tryParse(widget.blog.updatedAt);

  bool get _isEdited {
    if (_createdAt == null || _updatedAt == null) return false;
    return _updatedAt!.difference(_createdAt!).inSeconds.abs() > 1;
  }

  String get _displayTime {
    if (_createdAt == null) return widget.blog.creatTime;
    
    final createdTimeFormatted = timeago.format(_createdAt!);
    
    if (_isEdited && _updatedAt != null) {
      final updatedTimeFormatted = timeago.format(_updatedAt!);
      return '$createdTimeFormatted • Edited $updatedTimeFormatted';
    }
    
    return createdTimeFormatted;
  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.blog.isLikedByCurrentUser;
    totalLikes = widget.blog.totalLikes;
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await getUserId();
    if (!mounted) return;
    setState(() {
      _currentUserId = userId;
    });
  }

  Future<void> _toggleLike() async {
    if (isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      if (isLiked) {
        await _blogRepository.unlikeBlog(widget.blog.blogId);
      } else {
        await _blogRepository.likeBlog(widget.blog.blogId);
      }

      if (!mounted) return;

      setState(() {
        isLiked = !isLiked;
        totalLikes =
            isLiked ? totalLikes + 1 : (totalLikes - 1).clamp(0, 1 << 31);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update like: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> _reportBlog(ReportType type) async {
    final report = Report(blogId: widget.blog.blogId, reason: type);
    try {
      await _blogRepository.reportBlog(report);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF2E7D32),
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text('Reported successfully')),
              ],
            ),
          ),
        );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to report blog: $e')),
      );
    }
  }

Future<void> _navigateToEditPage() async {
    final isUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditBlogPage(
          blogId: widget.blog.blogId,
          initialContent: widget.blog.content,
        ),
      ),
    );

    if (isUpdated == true && widget.onChanged != null) {
      await widget.onChanged!.call();
    }
  }

  Future<void> _deleteBlog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete blog',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to delete this blog? \nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondButton(
                    text: "Cancel",
                    onPressed: () {
                      Navigator.pop(ctx, false);
                    },
                  ),
                  const SizedBox(width: 32),
                  MainButton(
                    text: "Delete",
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await _blogRepository.deleteBlog(widget.blog.blogId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog deleted successfully')),
      );
      if (widget.onChanged != null) {
        await widget.onChanged!.call();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete blog: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = (widget.blog.imagePath == null ||
            widget.blog.imagePath!.isEmpty)
        ? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'
        : widget.blog.imagePath!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF7EDF7), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _displayTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (_isOwner)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF8B7A99)),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEditPage();
                    } else if (value == 'delete') {
                      _deleteBlog();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              if (!_isOwner)
              PopupMenuButton<ReportType>(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedFlag02,
                  size: 16,
                  strokeWidth: 2,
                  color: Color(0xFF8B7A99),
                ),
                onSelected: (ReportType type) {
                  _reportBlog(type);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ReportType.SEXUAL_CONTENT,
                    child: Text(ReportType.SEXUAL_CONTENT.label),
                  ),
                  PopupMenuItem(
                    value: ReportType.VIOLENT_CONTENT,
                    child: Text(ReportType.VIOLENT_CONTENT.label),
                  ),
                  PopupMenuItem(
                    value: ReportType.HARASSMENT,
                    child: Text(ReportType.HARASSMENT.label),
                  ),
                  PopupMenuItem(
                    value: ReportType.SPAM,
                    child: Text(ReportType.SPAM.label),
                  ),
                  PopupMenuItem(
                    value: ReportType.MISINFORMATION,
                    child: Text(ReportType.MISINFORMATION.label),
                  ),
                  PopupMenuItem(
                    value: ReportType.SELF_HARM,
                    child: Text(ReportType.SELF_HARM.label),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Text(widget.blog.content),
          const SizedBox(height: 14),
          Row(
            children: [
              IconButton(
                onPressed: _toggleLike,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFD8A7D9),
                  size: 16,
                ),
              ),
              Text(
                totalLikes.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditBlogDialog extends StatefulWidget {
  final String initialContent;

  const _EditBlogDialog({required this.initialContent});

  @override
  State<_EditBlogDialog> createState() => _EditBlogDialogState();
}

class _EditBlogDialogState extends State<_EditBlogDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit blog'),
      content: TextField(
        controller: _controller,
        maxLines: 5,
        minLines: 3,
        decoration: const InputDecoration(
          hintText: 'Write your story...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
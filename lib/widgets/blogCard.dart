import 'package:fe/pages/blog/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fe/pages/blog/enum/report_type.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;

  const BlogCard({super.key, required this.blog});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late bool isLiked;
  late int totalLikes;
  bool isSubmitting = false;
  final _blogRepository = BlogRepository();

  @override
  void initState() {
    super.initState();
    isLiked = widget.blog.isLikedByCurrentUser;
    totalLikes = widget.blog.totalLikes;
  }

  Future<void> _toggleLike() async {
    if (isSubmitting) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      if (isLiked) {
        await _blogRepository.unlikeBlog(widget.blog.blogId);
      } else {
        await _blogRepository.likeBlog(widget.blog.blogId);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLiked = !isLiked;
        totalLikes =
            isLiked ? totalLikes + 1 : (totalLikes - 1).clamp(0, 1 << 31);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update like: $e')));
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
      if (!mounted) {
        return;
      }
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
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to report blog: $e')),
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
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(DateTime.parse(widget.blog.creatTime)),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Spacer(),
              PopupMenuButton<ReportType>(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedFlag02,
                  size: 16,
                  strokeWidth: 2,
                  color: const Color(0xFF8B7A99),
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

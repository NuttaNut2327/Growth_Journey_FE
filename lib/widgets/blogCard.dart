import 'package:flutter/material.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogCard extends StatefulWidget {
  final Blog blog;

  const BlogCard({super.key, required this.blog});

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
        totalLikes = isLiked
            ? totalLikes + 1
            : (totalLikes - 1).clamp(0, 1 << 31);
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

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(
                  widget.blog.imagePath ??
                      'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg',
                ),
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

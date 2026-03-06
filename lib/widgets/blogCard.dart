import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/heal/models/quest_model.dart';
import 'package:fe/widgets/uploadImageButton.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogCard extends StatefulWidget {
  final Blog blog;

  const BlogCard({
    super.key,
    required this.blog
  });

  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isLiked = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF7EDF7),
          width: 2,
        ),
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
                backgroundImage: NetworkImage(widget.blog.imagePath ?? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     widget.blog.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                     timeago.format(DateTime.parse(widget.blog.creatTime)),
                      style: TextStyle(
                        color: Colors.grey, 
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            widget.blog.content,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFD8A7D9),
                  size: 16,
                ),
              ),
              Text(
                (widget.blog.totalLikes + (isLiked ? 1 : 0)).toString(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/heal/models/quest_model.dart';
import 'package:fe/widgets/uploadImageButton.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogCard extends StatelessWidget {
  final Blog blog;

  const BlogCard({
    super.key,
    required this.blog
    });

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
                backgroundImage: NetworkImage(blog.imagePath ?? 'https://i.pinimg.com/736x/dd/8b/a9/dd8ba98ba0b06489ac96f76b74fe7fc6.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     blog.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                     timeago.format(DateTime.parse(blog.creatTime)),
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
            blog.content,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,          // 👈 เอา padding ออก
                constraints: const BoxConstraints(), // 👈 เอา min size default ออก
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFFD8A7D9),
                  size: 16,
                ),
              ),
              Text(
                blog.totalLikes.toString(),
                style: TextStyle(
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
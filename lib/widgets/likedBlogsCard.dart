import 'package:fe/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:fe/widgets/blogCard.dart';

class LikedBlogsCard extends StatelessWidget {
  final Blog? recentBlog;
  final bool isLoading;
  final String? errorMessage;

  const LikedBlogsCard({
    super.key,
    required this.recentBlog,
    required this.isLoading,
    this.errorMessage,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Liked blogs",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4C4456),
            ),
          ),
          Row(
            children: [
              const Text(
                "Your recent liked blogs history",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8F839C),
                ),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.likedBlogs);
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD8A7D9),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          else if (recentBlog != null)
            BlogCard(blog: recentBlog!)
          else
            const Text(
              "No blogs that you have liked yet.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
        ]));
  }
}

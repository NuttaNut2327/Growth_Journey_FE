import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/blogCard.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:hugeicons/hugeicons.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = BlogRepository();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MainUpperNavBar(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Growth Journey Stories', 
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('A safe space to share stories.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B7A99),
                              ),
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.createBlog);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Color(0xFFD8A7D9),
                            foregroundColor: Color(0xFFFFFFFF),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedAdd01, 
                            size: 24,
                            strokeWidth: 2,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x4DC8E5D8),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedFlower, 
                              size: 20, 
                              strokeWidth: 2, 
                              color: Color(0xFF60BA92)
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This is a safe, judgment-free space. \nBe kind, be respectful, and remember that \neveryone is on their own healing journey.',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )                      
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Blog>>(
                      future: repo.getBlogs(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final blogs = snapshot.data!;

                        return Column(
                          children: blogs.map((blog) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: BlogCard(blog: blog),
                            );
                          }).toList(),
                        );
                      },
                    )
                  ],
                )
              )
            ]
          )
        )
      ),
    );
  }
}
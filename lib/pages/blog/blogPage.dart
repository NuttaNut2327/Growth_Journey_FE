import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:hugeicons/hugeicons.dart';
import '/routes/app_routes.dart';
import 'package:fe/widgets/blogCard.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:fe/pages/blog/models/blog_model.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final repo = BlogRepository();
  late Future<List<Blog>> _blogsFuture;

  @override
  void initState() {
    super.initState();
    _blogsFuture = repo.getBlogs();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _blogsFuture = repo.getBlogs();
    });
    await _blogsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFFD8A7D9),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                              const Text(
                                'Growth Journey Stories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'A safe space to share stories.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8B7A99),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.createBlog,
                              );
                              if (result == true) {
                                await _handleRefresh();
                              }
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
                            ),
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
                                color: Color(0xFF5FA17B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'This is a safe, judgment-free space. \nBe kind, be respectful, and remember that \neveryone is on their own healing journey.',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<Blog>>(
                        future: _blogsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error loading blogs: ${snapshot.error}',
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Center(child: Text('No blogs yet')),
                            );
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

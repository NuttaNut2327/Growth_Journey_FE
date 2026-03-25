import 'package:fe/pages/blog/models/blog_model.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';
import 'package:fe/widgets/blogCard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class LikedBlogPage extends StatefulWidget {
  const LikedBlogPage({super.key});

  @override
  State<LikedBlogPage> createState() => _LikedBlogPageState();
}

class _LikedBlogPageState extends State<LikedBlogPage> {
  final repo = BlogRepository();
  late Future<List<Blog>> _likedBlogsFuture;

  @override
  void initState() {
    super.initState();
    _likedBlogsFuture = repo.getLikedBlogs();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _likedBlogsFuture = repo.getLikedBlogs();
    });
    await _likedBlogsFuture;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked blogs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFFD8A7D9),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Blog>>(
                future: _likedBlogsFuture,
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
                      child: Center(
                        child: 
                        Text(
                          'No blogs that you have liked yet',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ),
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
            )
          )
        )
      ),
    );
  }
}
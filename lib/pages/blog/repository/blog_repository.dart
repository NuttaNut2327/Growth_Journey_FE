import 'package:fe/api/blog/getBlogs.dart' as blog_api;
import 'package:fe/api/blog/createBlog.dart' as blog_api;
import 'package:fe/api/blog/likeBlog.dart' as blog_api;
import 'package:fe/api/blog/unlikeBlog.dart' as blog_api;
import 'package:fe/pages/blog/models/blog_model.dart';

class BlogRepository {
  Future<List<Blog>> getBlogs() async {
    final blogs = await blog_api.getBlogs();
    return blogs;
  }

  Future<void> createBlog(String content) async {
    await blog_api.createBlogApi(content);
  }

  Future<void> likeBlog(String blogId) async {
    await blog_api.likeBlogApi(blogId);
  }

  Future<void> unlikeBlog(String blogId) async {
    await blog_api.unlikeBlogApi(blogId);
  }
}

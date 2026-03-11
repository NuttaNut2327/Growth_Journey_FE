import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();
  final _blogRepository = BlogRepository();

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your blog'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/happy_level_3.png',
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppTextField(
                        label: '',
                        hintText:
                            'Share your story with us all!',
                        controller: contentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some content';
                          }
                          return null;
                        },
                        maxLines: 15,
                      ),
                    ),   
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Post",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              await _blogRepository.createBlog(contentController.text);
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blog posted successfully'), 
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              Navigator.pop(context, true);
            } catch (e) {
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to post blog: $e')),
              );
            }
          }
        },
      ),
    );
  }
}

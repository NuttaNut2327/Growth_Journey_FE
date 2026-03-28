import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:fe/widgets/bottomActionButton.dart';
import 'package:fe/pages/blog/repository/blog_repository.dart';

class EditBlogPage extends StatefulWidget {
  final String blogId;
  final String initialContent;

  const EditBlogPage({
    super.key,
    required this.blogId,
    required this.initialContent,
  });

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController contentController;
  final _blogRepository = BlogRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit your blog',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 24,
              strokeWidth: 2,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
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
                          hintText: 'Share your story with us all!',
                          controller: contentController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
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
          text: _isLoading ? "Saving..." : "Save",
          onPressed: _isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  
                  if (_formKey.currentState!.validate()) {
                    final newContent = contentController.text.trim();

                    if (newContent == widget.initialContent.trim()) {
                      Navigator.pop(context, false);
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await _blogRepository.editBlog(widget.blogId, newContent);
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Blog updated successfully'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );

                      Navigator.pop(context, true);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update blog: $e')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  }
                },
        ),
      ),
    );
  }
}
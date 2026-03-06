import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/customTextField.dart';
import 'package:fe/widgets/bottomActionButton.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {

  final _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

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
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/happy_level_3.png',
                      height: 175,
                      fit: BoxFit.cover,
                    ),
                    AppTextField(
                      label: '',
                      hintText: 'Stories you want to share with your friends...',
                      controller: contentController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some content';
                        }
                        return null;
                      },
                      maxLines: 15,
                    ),
                  ]
                )
              )
            )
          )
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        text: "Post",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Content: ${contentController.text}");
          }
        },
      ),
    );
  }
}
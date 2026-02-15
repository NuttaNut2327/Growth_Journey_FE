import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hugeicons/hugeicons.dart';

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({
    super.key,
    this.onImageSelected,
  });

  final Function(String?)? onImageSelected;

  @override
  State<UploadImageButton> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImageButton> {
  File? image;
  XFile? pickedFile;
  double? imageSizeMB;


  Future<void> pickImage() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (result == null) return;

    final file = File(result.path);
    final bytes = await file.length();
    final sizeMB = bytes / (1024 * 1024);

    setState(() {
      pickedFile = result;
      image = file;
      imageSizeMB = sizeMB; 
    });

    widget.onImageSelected?.call(result.path);
  }

  Widget fileBar() {
    if (pickedFile == null) return SizedBox();

    final name = pickedFile!.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8A7D9)),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedImage03, 
            color: Color(0xFFD8A7D9)
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Text(
            imageSizeMB != null
                ? "${imageSizeMB!.toStringAsFixed(1)} MB"
                : "",
          ),


          const SizedBox(width: 8),

          GestureDetector(
            onTap: () {
              setState(() {
                image = null;
                pickedFile = null;
              });

              widget.onImageSelected?.call(null);
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              color: Color(0x804A4458)
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fileBar(),

        GestureDetector(
          onTap: () async {
            await pickImage();
          },
          child: DottedBorder(
            color: const Color(0x80D8A7D9),
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedImageUpload,
                            size: 24,
                            color: Color(0xFFD09BD6),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "Click here to upload a photo.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

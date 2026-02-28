import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hugeicons/hugeicons.dart';

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({super.key, this.onImageSelected});
  final Function(Uint8List?)? onImageSelected;

  @override
  State<UploadImageButton> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImageButton> {
  XFile? pickedFile;
  Uint8List? imageBytes;
  double? imageSizeMB;

  Future<void> pickImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result == null) return;

    final bytes = await result.readAsBytes();
    final sizeMB = bytes.length / (1024 * 1024);

    if (sizeMB > 5) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image must be less than 5MB")),
      );
      return;
    }

    setState(() {
      pickedFile = result;
      imageBytes = bytes;
      imageSizeMB = sizeMB;
    });

    widget.onImageSelected?.call(bytes);
  }

  void removeImage() {
    setState(() {
      pickedFile = null;
      imageBytes = null;
      imageSizeMB = null;
    });

    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pickedFile != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD8A7D9)),
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedImage03,
                  color: Color(0xFFD8A7D9),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pickedFile!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("${imageSizeMB!.toStringAsFixed(1)} MB"),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: removeImage,
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Color(0x804A4458),
                  ),
                ),
              ],
            ),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: pickImage,
          child: DottedBorder(
            color: const Color(0x80D8A7D9),
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: imageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                        const Text("Click here to upload a photo."),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

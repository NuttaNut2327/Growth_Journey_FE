import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hugeicons/hugeicons.dart';

enum UploadImageMode { gallery, camera }

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({
    super.key,
    this.onImageSelected,
    this.mode = UploadImageMode.gallery,
    this.initialImageUrl,
  });

  final Function(Uint8List?)? onImageSelected;
  final UploadImageMode mode;
  final String? initialImageUrl;

  @override
  State<UploadImageButton> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImageButton> {
  XFile? pickedFile;
  Uint8List? imageBytes;
  double? imageSizeMB;
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    final initialUrl = widget.initialImageUrl;
    existingImageUrl =
        (initialUrl != null && initialUrl.isNotEmpty) ? initialUrl : null;
  }

  @override
  void didUpdateWidget(covariant UploadImageButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImageUrl != widget.initialImageUrl &&
        pickedFile == null &&
        imageBytes == null) {
      final initialUrl = widget.initialImageUrl;
      existingImageUrl =
          (initialUrl != null && initialUrl.isNotEmpty) ? initialUrl : null;
    }
  }

  Future<void> pickImage() async {
    final source = widget.mode == UploadImageMode.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    final result = await ImagePicker().pickImage(source: source);

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
                Tooltip(
                  message: 'Remove selected image',
                  child: GestureDetector(
                    onTap: removeImage,
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: Color(0x804A4458),
                    ),
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
                  : existingImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            existingImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) {
                              return const Center(
                                child: Text('Unable to load image'),
                              );
                            },
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
                        if (widget.mode == UploadImageMode.camera)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              "Take a photo",
                              style: TextStyle(
                                color: Color(0xFF8F839C),
                                fontSize: 12,
                              ),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              "Choose from gallery",
                              style: TextStyle(
                                color: Color(0xFF8F839C),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
        if (pickedFile != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Tip: Tap X to remove selected image.',
              style: TextStyle(
                color: Color(0xFF8F839C),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

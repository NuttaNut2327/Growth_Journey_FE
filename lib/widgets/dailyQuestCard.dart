import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/heal/models/quest_model.dart';
import 'package:fe/widgets/uploadImageButton.dart';

class DailyQuestCard extends StatelessWidget {
  final Quest quest;
  final bool isCompleted;
  final Future<void> Function(Uint8List imageBytes)? onDoQuest;

  const DailyQuestCard({
    super.key,
    required this.quest,
    this.isCompleted = false,
    this.onDoQuest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF7EDF7), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 180),
                              child: Text(
                                quest.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 3),
                                Text(
                                  '${quest.period} min',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B7A99),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x80F6DDE4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedFavourite,
                                size: 10,
                                strokeWidth: 3.5,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${quest.point} pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quest.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: MainButton(
              text: isCompleted ? 'Completed' : 'Do Quest',
              onPressed: isCompleted
                  ? null
                  : () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) {
                          Uint8List? selectedImageBytes;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return DraggableScrollableSheet(
                                initialChildSize: 0.6,
                                minChildSize: 0.6,
                                maxChildSize: 0.9,
                                expand: false,
                                builder: (_, controller) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    child: ListView(
                                      controller: controller,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 36,
                                      ),
                                      children: [
                                        Text(
                                          quest.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Send pictures of doing quests',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF8B7A99),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        UploadImageButton(
                                          mode: UploadImageMode.camera,
                                          onImageSelected: (bytes) {
                                            setState(() {
                                              selectedImageBytes = bytes;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        MainButton(
                                          text: 'Send',
                                          onPressed: selectedImageBytes == null
                                              ? null
                                              : () {
                                                  () async {
                                                    try {
                                                      if (onDoQuest != null) {
                                                        await onDoQuest!(
                                                          selectedImageBytes!,
                                                        );
                                                      }

                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Quest completed successfully'),
                                                            backgroundColor: Colors.green,
                                                            duration: Duration(seconds: 3),
                                                          ),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Error: $e',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }();
                                                },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}

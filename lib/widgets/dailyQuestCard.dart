import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/heal/models/quest_model.dart';
import 'package:fe/widgets/uploadImageButton.dart';

class DailyQuestCard extends StatelessWidget {
  final Quest quest;

  const DailyQuestCard({
    super.key,
    required this.quest
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF7EDF7),
          width: 2,
        ),
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
                              constraints: const BoxConstraints(
                                maxWidth: 180,
                              ),
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
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          )
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
              text: "Do Quest", 
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) {

                    String? imagePath;

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
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
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
                                    onImageSelected: (Uint8List? bytes) {
                                      setState(() {
                                        imagePath = bytes != null ? base64Encode(bytes) : null;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  MainButton(
                                    text: 'Send',
                                    onPressed: () {
                                      print('Quest ID: ${quest.questId}');
                                      print('Image Path: $imagePath');

                                      Navigator.pop(context);
                                    },
                                  )
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
            )
          ),
        ],
      ),
    );
  }
} 
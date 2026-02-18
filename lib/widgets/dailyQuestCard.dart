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
          color: const Color(0xFFEEDFF1),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HugeIcon(
              //   icon: HugeIcons.strokeRoundedMonocle01, 
              //   size: 24,
              //   color: Color(0xFFD6A6D8),
              //   strokeWidth: 2,
              // ), 
              // SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quest.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0x808B7A99),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedFavourite,
                                size: 10,
                                strokeWidth: 3,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${quest.point} pts', 
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ),
                        const SizedBox(width: 16),
                        Text('${quest.period} min', 
                          style: TextStyle(
                            fontSize: 12, 
                            color: Color(0xFF8B7A99),
                          )
                        ),
                      ],
                    )
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
                  isScrollControlled: true,
                  builder: (_) {

                    String? imagePath;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
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
                                padding: EdgeInsets.all(24),
                                children: [
                                  Center(
                                    child: Container(
                                      width: 70,
                                      height: 7,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
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
                                    onImageSelected: (path) {
                                      setState(() {
                                        imagePath = path;
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
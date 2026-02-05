import 'package:flutter/material.dart';

class AssessmentCard extends StatelessWidget {
  final int questionNumber;
  final String question;
  final int? selectedValue;
  final Function(int) onSelected;

  const AssessmentCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Question $questionNumber of 5',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0x8009101D)

            ),
          ),
          const SizedBox(height: 16),
          Text(
            question,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          
        ],
      )
    );
  }
}

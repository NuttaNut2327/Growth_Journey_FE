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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFEEDFF1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEEDFF1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// เลขข้อ (เล็กลง)
          Text(
            'Question $questionNumber',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Not stressful',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Extremely stressful',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = selectedValue == value;

              return GestureDetector(
                onTap: () => onSelected(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Color(0xFFD6A6D8)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFFD6A6D8)
                          : Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          Text(
            'You can skip this question if it doesn’t apply to you.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

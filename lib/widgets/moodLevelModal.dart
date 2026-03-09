import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:fe/pages/home/enum/emotions.dart';

class MoodLevelModal extends StatefulWidget {
  final Emotions emotion;
  const MoodLevelModal({super.key, required this.emotion});

  @override
  State<MoodLevelModal> createState() => _MoodLevelModalState();
}

class _MoodLevelModalState extends State<MoodLevelModal> {
  double level = 2;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "How ${widget.emotion.label} do you feel right now?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Low"),
                Text("Medium"),
                Text("High"),
              ],
            ),
            Slider(
              value: level,
              min: 1,
              max: 3,
              divisions: 2,
              thumbColor: Color(0xFFD8A7D9),
              activeColor: Color(0xFFD8A7D9),
              onChanged: (value) {
                setState(() {
                  level = value;
                });
              },
            ),
            const SizedBox(height: 16),
            MainButton(
              text: "Confirm",
              onPressed: () {
                Navigator.pop(context, level.toInt());
              },
            )
          ],
        ),
      ),
    );
  }
}
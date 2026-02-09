import 'package:flutter/material.dart';
import 'package:fe/widgets/mainButton.dart';

class AssessmentCard extends StatelessWidget {
  final int questionNumber;
  final String question;
  final String imagePath;
  final Function(int) onAnswerSelected;

  const AssessmentCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.imagePath,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
         'Question $questionNumber of 5',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: Center(
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            SizedBox(height: 32),
            Image.asset(
              imagePath,
              height: 250,
            ),
            SizedBox(height: 32),
            Text('Choose the option that best matches how you have been feeling over the past 2 – 4 weeks.', 
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            _answerButton('Rarely', 0),
            _answerButton('Sometimes', 1),
            _answerButton('Often', 2),
            _answerButton('Always', 3),
          ],
        ),
    );
  }

  Widget _answerButton(String text, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: MainButton(
          text: text,
          onPressed: () {
            onAnswerSelected(value);
          }
        )
      ),
    );
  }
}

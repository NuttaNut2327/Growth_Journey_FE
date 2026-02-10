import 'package:flutter/material.dart';
import 'package:fe/widgets/assessmentCard.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/pages/assessment/resultPage.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final List<String> questions = [
    'Having sleep problems, such as\ninsomnia or excessive sleeping.',
    'Having reduced concentration.',
    'Irritable / restless / agitated.',
    'Feeling bored or fed up.',
    'Not wanting to socialize with others.',
  ];

  final List<String> images = [
    'assets/images/anxios_level_1.png',
    'assets/images/anxios_level_2.png',
    'assets/images/anxios_level_3.png',
    'assets/images/tired_level_3.png',
    'assets/images/tired_level_1.png',
  ];

  int currentIndex = 0;
  late List<int?> answers;

  @override
  void initState() {
    super.initState();
    answers = List.filled(questions.length, null);
  }

  void onAnswerSelected(int value) {
    answers[currentIndex] = value;

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      showResult();
    }
  }

  void showResult() {
    final totalScore =
        answers.fold<int>(0, (sum, value) => sum + (value ?? 0));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          totalScore: totalScore,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Test Questionnaire'),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AssessmentCard(
          questionNumber: currentIndex + 1,
          question: questions[currentIndex],
          imagePath: images[currentIndex],
          onAnswerSelected: onAnswerSelected,
        ),
      ),
    );
  }
}

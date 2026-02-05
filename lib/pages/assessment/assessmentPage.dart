import 'package:flutter/material.dart';
import 'package:fe/widgets/assessmentCard.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final List<String> questions = [
    'Afraid of making mistakes at work.',
    'Not achieving the goals you set.',
    'Conflicts within the family over money or household responsibilities.',
    'Concerned about toxins or pollution in the air, water, noise, and soil.',
    'Feeling the need to compete or compare yourself with others.',
    'Not having enough money to cover expenses.',
    'Muscle tension or pain.',
    'Tension headaches.',
    'Back pain.',
    'Changes in appetite.',
    'One-sided headache.',
    'Feeling anxious.',
    'Feeling frustrated.',
    'Feeling angry or irritable.',
    'Feeling sad.',
    'Poor memory.',
    'Feeling confused.',
    'Difficulty concentrating.',
    'Feeling easily fatigued.',
    'Getting colds frequently.'
  ];

  int currentIndex = 0;
  late List<int?> answers;

  @override
  void initState() {
    super.initState();
    answers = List.filled(questions.length, null);
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      showResult();
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  void showResult() {
    final totalScore =
        answers.fold<int>(0, (sum, value) => sum + (value ?? 0));

    String resultMessage;

    if (totalScore <= 23) {
      resultMessage =
          'You have a low level of stress, which tends to be short-term.\n'
          'This type of stress commonly occurs in daily life and you are able to adapt to various situations appropriately.'
          'Stress at this level is considered beneficial for everyday living, as it can serve as motivation and lead to success in life.';
    } else if (totalScore <= 41) {
      resultMessage =
          'You have a moderate level of stress, which can occur in daily life due to stressors or stressful events. You may feel anxious or fearful, but this is considered within the normal range. This level of stress does not cause harm or negatively affect daily functioning. You can relieve stress by engaging in energizing activities such as exercising or playing sports, and by doing enjoyable activities like listening to music, reading, pursuing hobbies, or talking and sharing your concerns with someone you trust.';
    } else if (totalScore <= 61) {
      resultMessage =
          'You have a high level of stress. This level of stress means that you are experiencing significant distress from various situations or events around you, leading to feelings of anxiety, fear, conflict, or being in situations that you are unable to manage or resolve. Adjusting your emotions becomes difficult, which can affect your daily life and may lead to health problems such as high blood pressure or stomach ulcers. When experiencing stress at this level, it is important to take immediate action. Effective and simple ways to relieve stress include practicing relaxation breathing techniques, talking and expressing your stress to someone you trust, identifying the causes of your stress and finding ways to resolve them. If you are unable to manage or relieve stress on your own, you should seek guidance from a counselor or professional services in relevant organizations.';
    } else {
      resultMessage =
          'You have a severe level of stress. This is a very high level of stress that occurs continuously, or you may be facing a life crisis such as a serious or chronic illness, disability, or the loss of a loved one, property, or something important to you. This level of stress can lead to physical and mental health problems, unhappiness in life, racing thoughts, poor decision-making, and difficulty controlling emotions. If left unaddressed, this level of stress can have negative effects on both yourself and those close to you. It is important to seek help from a counselor or professional services as soon as possible, such as through telephone support or counseling services at relevant organizations.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Assessment results'),
        content: Text(
          'Your total score is $totalScore\n\n$resultMessage',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.bottomnavbar),
            child: const Text('Back Home'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress Test Questionnaire'),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(icon:  HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.bottomnavbar);
            },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            AssessmentCard(
              questionNumber: currentIndex + 1,
              question: questions[currentIndex],
              selectedValue: answers[currentIndex],
              onSelected: (value) {
                setState(() {
                  answers[currentIndex] = value;
                });
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex == 0 ? null : prevQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21911200),
                    ),
                    backgroundColor: Color(0xFFD8A7D9),
                  ),
                  child: const Text('Back', 
                    style: TextStyle(
                      color: Colors.white)
                    ),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21911200),
                    ),
                    backgroundColor: Color(0xFFD8A7D9),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1
                        ? 'Submit'
                        : 'Next',
                    style: TextStyle(
                      color: Colors.white)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

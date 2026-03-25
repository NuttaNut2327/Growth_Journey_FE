import 'package:flutter/material.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/widgets/mainButton.dart';
import 'package:hugeicons/hugeicons.dart';

class ResultPage extends StatelessWidget {
  final int totalScore;

  const ResultPage({
    super.key,
    required this.totalScore,
  });

  String get resultMessage {
    if (totalScore <= 4) {
      return 'Your stress level is low.';
    } else if (totalScore <= 7) {
      return 'Your stress level is moderate.';
    } else if (totalScore <= 9) {
      return 'Your stress level is high.';
    } else {
      return 'Your stress level is severe.';
    }
  }

  String get detailResult {
    if (totalScore <= 4) {
      return
          'Congratulations!\n\n'
          'Your stress level is within a normal range.\n'
          'This is everyday stress that you can manage\n'
          'on your own and it does not affect your health.\n\n'
          'You have enough energy to take care of yourself\n'
          'and support people around you.\n'
          'Keep maintaining this healthy balance.';
    } 
    else if (totalScore <= 7) {
      return
          'Your stress level is moderate.\n\n'
          'This usually comes from daily responsibilities\n'
          'and life challenges.\n'
          'It is considered normal and not harmful.\n\n'
          'This level of stress can even help motivate you\n'
          'to stay alert and handle situations effectively.';
    } 
    else if (totalScore <= 9) {
      return
          'Your stress level is high.\n\n'
          'You may experience strong emotional reactions\n'
          'during this period, but they often improve\n'
          'once the situation gets better.\n\n'
          'Try simple self-care such as:\n'
          '• Deep breathing\n'
          '• Getting enough rest\n'
          '• Talking with someone you trust\n'
          '• Doing relaxing or spiritual activities\n\n'
          'If you do not feel better after 2 weeks,\n'
          'it is recommended to consult a doctor\n'
          'or a mental health professional.';
    } 
    else {
      return
        'Your stress level is severe and may affect both\n'
        'your physical and mental health.\n\n'
        'There is a risk of anxiety, depression,\n'
        'or thoughts of self-harm.\n\n'
        'It is strongly recommended that you see a doctor\n'
        'or mental health professional as soon as possible\n'
        'for close and continuous care over the next\n'
        '3–6 months.\n\n'
        'You do not have to face this alone.\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
            strokeWidth: 2,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.bottomnavbar);
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your total score',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$totalScore',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      resultMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      detailResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0x4DC8E5D8),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [ 
                            Text(
                              'Mental Health Helpline',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),                                                 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedCalling02,
                                  size: 20,
                                  strokeWidth: 2,
                                  color: Color(0xFF5FA17B),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '1323',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                            'We\’re always here for you. \nGently listening, support your well-being, \nand helping you feel a little lighter every day.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),                                                        
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        text: 'Back Home',
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.bottomnavbar,
                            (route) => false,
                          );
                        },
                      ),
                    ), 
                  ],
                ),
              ),
            );
          },
        ),
      ), 
    );
  }
}

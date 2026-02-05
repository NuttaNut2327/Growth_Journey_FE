import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:fe/widgets/mainButton.dart';

class ResultPage extends StatelessWidget {
  final int totalScore;

  const ResultPage({
    super.key,
    required this.totalScore,
  });

  String get resultMessage {
    if (totalScore <= 4) {
      return 'Having a low level of stress.';
    } else if (totalScore <= 7) {
      return 'Having a moderate level of stress.';
    } else if (totalScore <= 9) {
      return 'Having a high level of stress.';
    } else {
      return 'Having a severe level of stress.';
    }
  }

  String get detailResult {
    if (totalScore <= 4) {
      return 'You have a low level of stress, which tends to be short-term.';
    } else if (totalScore <= 7) {
      return 'You have a moderate level of stress.';
    } else if (totalScore <= 9) {
      return 'You have a high level of stress.';
    } else {
      return 'You have a severe level of stress.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your total score',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '$totalScore',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
            Text(
              resultMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 24),
            Text(
              detailResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.bottomnavbar,
                  (route) => false,
                );
              },
              child: const Text('Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank Page'),
      ),
      body: const Center(
        child: Text('This is the Rank Page'),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fe/widgets/mainUpperNavBar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MainUpperNavBar(),
            ]
          )
        )
      ),
    );
  }
}
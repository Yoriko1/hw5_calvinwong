import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final List questions;

  SummaryScreen({required this.score, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: Center(
        child: Column(
          children: [
            Text('Your Score: $score'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

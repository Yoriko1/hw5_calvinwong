import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'summary_screen.dart';

class QuizScreen extends StatelessWidget {
  final int numberOfQuestions;
  final int categoryId;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.numberOfQuestions,
    required this.categoryId,
    required this.difficulty,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider()..loadQuestions(
          amount: numberOfQuestions,
          categoryId: categoryId,
          difficulty: difficulty,
          type: type,
        ),
      child: Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Consumer<QuizProvider>(
          builder: (context, quiz, child) {
            if (quiz.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (quiz.hasError || quiz.questions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No questions found. Please try a different configuration.'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the setup screen
                      },
                      child: Text('Back to Setup'),
                    ),
                  ],
                ),
              );
            }

            if (quiz.isQuizCompleted()) {
              return SummaryScreen(score: quiz.score, questions: quiz.questions);
            }

            final question = quiz.questions[quiz.currentQuestionIndex];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    question.question,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        bool correct = option == question.correctAnswer;
                        quiz.nextQuestion(correct);
                      },
                      child: Text(option),
                    ),
                  );
                }).toList(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Question ${quiz.currentQuestionIndex + 1} of ${quiz.questions.length}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

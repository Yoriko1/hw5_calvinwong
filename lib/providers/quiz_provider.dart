import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/question.dart';

class QuizProvider with ChangeNotifier {
  List<Question> questions = []; // List of fetched questions
  int currentQuestionIndex = 0;  // Tracks the current question index
  int score = 0;                // Tracks the user's score
  bool isLoading = false;       // Tracks loading state
  bool hasError = false;        // Tracks error state

  // Reset the provider's state
  void reset() {
    questions = [];
    currentQuestionIndex = 0;
    score = 0;
    isLoading = false;
    hasError = false;
    notifyListeners();
  }

  // Load questions from the API
  Future<void> loadQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    reset(); // Clear previous data
    isLoading = true;
    notifyListeners();

    try {
      final fetchedQuestions = await ApiService.fetchQuestions(
        amount: amount,
        categoryId: categoryId,
        difficulty: difficulty,
        type: type,
      );

      // Parse the questions into Question objects
      questions = fetchedQuestions.map((q) => Question.fromJson(q)).toList();

      if (questions.isEmpty) {
        hasError = true; // No questions were returned
        print('No questions returned for this configuration.');
      }
    } catch (error) {
      hasError = true; // Handle any errors during API fetching
      print('Error loading questions: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Move to the next question and update the score
  void nextQuestion(bool correct) {
    if (correct) {
      score++;
    }

    currentQuestionIndex++;

    // Notify listeners to update the UI
    notifyListeners();
  }

  // Check if the quiz is completed
  bool isQuizCompleted() {
    return currentQuestionIndex >= questions.length;
  }
}

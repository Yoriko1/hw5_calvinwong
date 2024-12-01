class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // For boolean questions, options are always "True" and "False"
    List<String> options;
    if (json['type'] == 'boolean') {
      options = ['True', 'False'];
    } else {
      // For multiple-choice questions, combine correct and incorrect answers
      options = List<String>.from(json['incorrect_answers']);
      options.add(json['correct_answer']);
      options.shuffle(); // Shuffle for randomness
    }

    return Question(
      question: json['question'],       // The question text
      options: options,                // List of options
      correctAnswer: json['correct_answer'], // The correct answer
    );
  }
}

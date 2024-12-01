import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  List categories = [];
  int? selectedCategory;
  String difficulty = 'easy';
  String type = 'multiple';
  int numberOfQuestions = 10;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await ApiService.fetchCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<int>(
                  value: selectedCategory,
                  items: categories.map<DropdownMenuItem<int>>((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  hint: Text('Select Category'),
                  onChanged: (value) => setState(() => selectedCategory = value),
                ),
                DropdownButton<String>(
                  value: difficulty,
                  items: ['Easy', 'Medium', 'Hard']
                      .map((level) => DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => difficulty = value!),
                ),
                DropdownButton<String>(
                  value: type,
                  items: ['multiple', 'boolean']
                      .map((t) => DropdownMenuItem<String>(
                            value: t,
                            child: Text(t == 'multiple' ? 'Multiple Choice' : 'True/False'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => type = value!),
                ),
                Slider(
                  value: numberOfQuestions.toDouble(),
                  min: 5,
                  max: 20,
                  divisions: 3,
                  label: '$numberOfQuestions',
                  onChanged: (value) => setState(() => numberOfQuestions = value.toInt()),
                ),
                ElevatedButton(
                  onPressed: selectedCategory == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                numberOfQuestions: numberOfQuestions,
                                categoryId: selectedCategory!,
                                difficulty: difficulty,
                                type: type,
                              ),
                            ),
                          );
                        },
                  child: Text('Start Quiz'),
                ),
              ],
            ),
    );
  }
}

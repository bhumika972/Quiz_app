import 'package:flutter/material.dart';
import 'database_service.dart';

class AddQuestionsScreen extends StatefulWidget {
  final String title;
  final String description;

  AddQuestionsScreen({required this.title, required this.description});

  @override
  _AddQuestionsScreenState createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final DatabaseService dbService = DatabaseService();
  List<Map<String, dynamic>> questions = [];
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionsControllers =
      List.generate(4, (index) => TextEditingController());
  int? _correctAnswerIndex;
  int _questionLimit = 5;
  TextEditingController _questionLimitController = TextEditingController();

  void _addQuestion() {
    if (_questionController.text.isNotEmpty &&
        _optionsControllers.every((controller) => controller.text.isNotEmpty) &&
        _correctAnswerIndex != null) {
      setState(() {
        questions.add({
          "question": _questionController.text,
          "options": _optionsControllers.map((c) => c.text).toList(),
          "correctAnswer": _correctAnswerIndex!,
        });
        _questionController.clear();
        _optionsControllers.forEach((c) => c.clear());
        _correctAnswerIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Fill all fields and select a correct answer!')),
      );
    }
  }

  void _submitQuiz() async {
    if (questions.length < _questionLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least $_questionLimit questions!')),
      );
      return;
    }
    await dbService.addQuizWithQuestions(
        widget.title, widget.description, questions);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Questions")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB6C1),
              Color(0xFFFFB6C1)
            ], // Corrected color format
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _questionLimitController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Set Question Limit",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.format_list_numbered),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _questionLimit = int.tryParse(value) ?? 5;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: "Enter Question",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.question_answer),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(4, (index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: RadioListTile<int>(
                      title: TextField(
                        controller: _optionsControllers[index],
                        decoration: InputDecoration(
                          labelText: "Option ${index + 1}",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      value: index,
                      groupValue: _correctAnswerIndex,
                      onChanged: (value) {
                        setState(() {
                          _correctAnswerIndex = value;
                        });
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text('Add Question'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text('Submit Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

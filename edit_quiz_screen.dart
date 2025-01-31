import 'package:flutter/material.dart';
import 'database_service.dart';

class EditQuizScreen extends StatefulWidget {
  final String quizId;
  final String currentTitle;
  final String currentDescription;

  EditQuizScreen({
    required this.quizId,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTitle;
    _descriptionController.text = widget.currentDescription;
  }

  void _updateQuiz() async {
    String newTitle = _titleController.text.trim();
    String newDescription = _descriptionController.text.trim();

    if (newTitle.isNotEmpty && newDescription.isNotEmpty) {
      await dbService.updateQuiz(
        widget.quizId,
        newTitle,
        newDescription,
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quiz'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 202, 120, 189),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(
              255, 214, 175, 194), // Matching Admin Dashboard background
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Quiz Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Quiz Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updateQuiz,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 190, 146, 152),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
                child:
                    const Text('Update Quiz', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'score_screen.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;

  QuizAttemptScreen({required this.quizId});

  @override
  _QuizAttemptScreenState createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('quizzes');
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() async {
    final snapshot =
        await _database.child(widget.quizId).child('questions').get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      setState(() {
        questions = data.map((q) {
          return {
            'question': q['question'],
            'options': q['options'],
            'correctAnswer': q['correctAnswer'],
          };
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _checkAnswer(String selectedOption) {
    if (questions[currentQuestionIndex]['correctAnswer'] == selectedOption) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreScreen(
            score: score,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attempt Quiz"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.pink[50], // Light Pink Background
          image: DecorationImage(
            image: AssetImage("assets/quiz_sticker.png"), // Add a sticker
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        padding: const EdgeInsets.all(20.0), // Increase padding for spacing
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : questions.isEmpty
                ? const Center(child: Text("No Questions Available"))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Q${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]['question']}",
                                style: const TextStyle(
                                  fontSize:
                                      24, // Increase text size for clarity
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: (questions[currentQuestionIndex]
                                        ['options'] as List<dynamic>)
                                    .map(
                                      (option) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                12.0), // Increase space between buttons
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            _checkAnswer(option);
                                          },
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'quiz_attempt_screen.dart'; // Import your attempt screen
import 'dart:math'; // For generating random colors

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('quizzes');
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;

  final List<Color> lightColors = [
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
    Colors.amber.shade100,
    Colors.indigo.shade100,
  ];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  void _fetchQuizzes() {
    _database.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> loadedQuizzes = [];

        data.forEach((key, value) {
          loadedQuizzes.add({
            'id': key,
            'title': value['title'],
            'description': value['description'],
            'color': lightColors[_random.nextInt(lightColors.length)],
          });
        });

        setState(() {
          quizzes = loadedQuizzes;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz List"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 202, 120, 189),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? const Center(
                  child: Text(
                    "No quizzes available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: quizzes[index]['color'], // Random light color
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(2, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        title: Text(
                          quizzes[index]['title'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            quizzes[index]['description'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizAttemptScreen(
                                quizId: quizzes[index]['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

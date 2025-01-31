import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Import the Login Screen
import 'home_screen.dart'; // Import the Home Screen
import 'admin_dashboard.dart'; // Import the Admin Dashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBvNe0C5HY_BZlLY1gQCzoSFWFV9Mb4v_E",
        authDomain: "quizapp-beaee.firebaseapp.com",
        databaseURL: "https://quizapp-beaee-default-rtdb.firebaseio.com",
        projectId: "quizapp-beaee",
        storageBucket: "quizapp-beaee.appspot.com", // Fixed storage bucket URL
        messagingSenderId: "830850394082",
        appId: "1:830850394082:web:81ba934f3c74799a463bbb",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(), // Determines initial screen based on authentication
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(); // User is signed in, navigate to Home Screen
        }
        return LoginScreen(); // User is not signed in, navigate to Login Screen
      },
    );
  }
}

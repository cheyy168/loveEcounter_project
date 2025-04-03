import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file is generated using Firebase CLI
import 'screens/loading_screen.dart';
import 'screens/welcom_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/HomeScreen.dart'; // Ensure this import path is correct
import 'screens/successful_screen.dart'; // Correct the path to your success screen


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase Initialized Successfully!");
  } catch (e) {
    print("Firebase Initialization Error: $e");
    // You could show an error screen or message to the user if initialization fails
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set LogoScreen as the initial screen
      routes: {
        '/': (context) => LogoScreen(), // Assuming LogoScreen is implemented
        '/welcom': (context) => WelcomScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPassword(), // Route to ForgotPassword screen
        '/home': (context) => HomeScreen(), // Route to HomeScreen
        '/successful': (context) => SuccessScreen(), // Correct route to SuccessScreen
      },
    );
  }
}

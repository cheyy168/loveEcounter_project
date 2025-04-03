import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register User
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in registration: ${e.toString()}");
      return null;
    }
  }

  // Login User
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in login: ${e.toString()}");
      return null;
    }
  }

  // Logout User
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error in logout: ${e.toString()}");
    }
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error in reset password: ${e.toString()}");
    }
  }
}

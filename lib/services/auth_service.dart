import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user (nullable)
  User? get currentUser => _auth.currentUser;

  /// Register a new user with email and password
  Future<User?> register(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      debugPrint('New user registered: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration error: ${e.code}');
      throw AuthException(_handleErrorCode(e.code));
    } catch (e) {
      debugPrint('Unexpected registration error: $e');
      throw AuthException('An unknown error occurred during registration');
    }
  }

  /// Login existing user with email and password
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      debugPrint('User logged in: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code}');
      // Handle specific error codes
      if (e.code == 'user-not-found') {
        throw AuthException(
          'No account found with this email. Please register or try again.',
        );
      } else if (e.code == 'wrong-password') {
        throw AuthException('Incorrect password. Please try again.');
      } else {
        throw AuthException(_handleErrorCode(e.code));
      }
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      throw AuthException('An unknown error occurred during login');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      debugPrint('User logged out');
    } on FirebaseAuthException catch (e) {
      debugPrint('Logout error: ${e.code}');
      throw AuthException(_handleErrorCode(e.code));
    } catch (e) {
      debugPrint('Unexpected logout error: $e');
      throw AuthException('An unknown error occurred during logout');
    }
  }

  /// Enhanced password reset with deep linking
  Future<void> resetPassword(String email) async {
    try {
      final actionSettings = ActionCodeSettings(
        url:
            'https://loveecounter.com/reset-password?email=${Uri.encodeComponent(email)}',
        handleCodeInApp: true,
        androidPackageName: 'com.example.love_ecounte',
        iOSBundleId: 'com.example.love_ecounte',
        androidMinimumVersion: '21',
      );

      await _auth.sendPasswordResetEmail(
        email: email.trim(),
        actionCodeSettings: actionSettings,
      );

      debugPrint(
        'Password reset sent to $email with settings: $actionSettings',
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw AuthException(_handleErrorCode(e.code));
    } catch (e) {
      debugPrint('Unexpected reset error: $e');
      throw AuthException('Failed to send password reset email');
    }
  }

  /// Reauthenticate user with credentials
  Future<void> reauthenticate(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );
      await currentUser?.reauthenticateWithCredential(credential);
      debugPrint('User reauthenticated: $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('Reauth error: ${e.code}');
      throw AuthException(_handleErrorCode(e.code));
    } catch (e) {
      debugPrint('Unexpected reauth error: $e');
      throw AuthException('Reauthentication failed');
    }
  }

  /// Update user email with verification
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail.trim());
      debugPrint('Email update initiated for: $newEmail');
    } on FirebaseAuthException catch (e) {
      debugPrint('Email update error: ${e.code}');
      throw AuthException(_handleErrorCode(e.code));
    } catch (e) {
      debugPrint('Unexpected email update error: $e');
      throw AuthException('Failed to update email');
    }
  }

  /// Comprehensive error code handling
  String _handleErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password. Try again or reset it';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'operation-not-allowed':
        return 'Email/password login is not enabled';
      case 'weak-password':
        return 'Password must be at least 8 characters';
      case 'requires-recent-login':
        return 'Please log in again to perform this action';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again';
      case 'invalid-action-code':
        return 'Invalid security code. Request a new link';
      case 'expired-action-code':
        return 'Security code expired. Request a new link';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'missing-android-pkg-name':
        return 'Android configuration missing in app';
      case 'missing-ios-bundle-id':
        return 'iOS configuration missing in app';
      default:
        return 'An error occurred (${code})';
    }
  }
}
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

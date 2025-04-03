import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user data
  Future<void> saveUserData(String uid, String email, String fullName) async {
    try {
      await _db.collection("users").doc(uid).set({
        "email": email,
        "full_name": fullName,
        "created_at": Timestamp.now(),
      });
      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: ${e.toString()}");
    }
  }

  // Save additional user information
  Future<void> saveUserAdditionalInfo(String uid, String fullName, String phoneNumber) async {
    try {
      await _db.collection("users").doc(uid).set({
        "full_name": fullName,
        "phone_number": phoneNumber,
      }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
      print("Additional user info saved successfully.");
    } catch (e) {
      print("Error saving additional user info: ${e.toString()}");
    }
  }

  // Fetch user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uid).get();
      print("Fetched user data for $uid");
      return snapshot;
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
      throw e; // Re-throw the error for better handling elsewhere
    }
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection("users").doc(uid).update(updatedData);
      print("User data updated successfully.");
    } catch (e) {
      print("Error updating user data: ${e.toString()}");
    }
  }

  // Fetch all users (for admin purposes)
  Future<QuerySnapshot> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection("users").get();
      print("Fetched all users.");
      return snapshot;
    } catch (e) {
      print("Error fetching all users: ${e.toString()}");
      throw e; // Re-throw the error for better handling elsewhere
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Collection Reference
  CollectionReference get _users => _db.collection('users');
  
  // Bookings Collection Reference
  CollectionReference get _bookings => _db.collection('bookings');
  
  // Companions Collection Reference
  CollectionReference get _companions => _db.collection('companions');

  /// Saves user data to Firestore
  Future<void> saveUserData({
    required String uid,
    required String email,
    String fullName = '',
    String? photoUrl,
    String phoneNumber = '',
  }) async {
    try {
      await _users.doc(uid).set({
        'uid': uid,
        'email': email,
        'full_name': fullName,
        'photo_url': photoUrl,
        'phone_number': phoneNumber,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (kDebugMode) {
        print('User data saved successfully for $uid');
      }
    } catch (e, stackTrace) {
      _logError('saveUserData', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Updates user profile data
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _users.doc(uid).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('User profile updated successfully for $uid');
      }
    } catch (e, stackTrace) {
      _logError('updateUserProfile', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets user profile data
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await _users.doc(uid).get();
    } catch (e, stackTrace) {
      _logError('getUserProfile', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Stream of user profile changes
  Stream<DocumentSnapshot> getUserProfileStream(String uid) {
    return _users.doc(uid).snapshots().handleError((e, stackTrace) {
      _logError('getUserProfileStream', e, stackTrace);
      throw _handleFirestoreError(e);
    });
  }

  /// Creates a new booking
  Future<String> createBooking({
    required String userId,
    required String companionId,
    required String companionName,
    required double totalAmount,
    required String meetingPlace,
    required DateTime dateTime,
    required String duration,
    required List<String> optionalServices,
    String status = 'confirmed',
    String paymentStatus = 'pending',
  }) async {
    try {
      final docRef = await _bookings.add({
        'user_id': userId,
        'companion_id': companionId,
        'companion_name': companionName,
        'total_amount': totalAmount,
        'meeting_place': meetingPlace,
        'date_time': Timestamp.fromDate(dateTime),
        'duration': duration,
        'optional_services': optionalServices,
        'status': status,
        'payment_status': paymentStatus,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Booking created with ID: ${docRef.id}');
      }
      return docRef.id;
    } catch (e, stackTrace) {
      _logError('createBooking', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Updates booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      await _bookings.doc(bookingId).update({
        'status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Booking $bookingId status updated to $status');
      }
    } catch (e, stackTrace) {
      _logError('updateBookingStatus', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Updates payment status
  Future<void> updatePaymentStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      await _bookings.doc(bookingId).update({
        'payment_status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Booking $bookingId payment status updated to $status');
      }
    } catch (e, stackTrace) {
      _logError('updatePaymentStatus', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets stream of user bookings
  Stream<QuerySnapshot> getUserBookingsStream(String userId) {
    return _bookings
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .handleError((e, stackTrace) {
      _logError('getUserBookingsStream', e, stackTrace);
      throw _handleFirestoreError(e);
    });
  }

  /// Gets list of user bookings
  Future<List<DocumentSnapshot>> getUserBookings(String userId) async {
    try {
      final snapshot = await _bookings
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();
      return snapshot.docs;
    } catch (e, stackTrace) {
      _logError('getUserBookings', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets booking details
  Future<DocumentSnapshot> getBookingDetails(String bookingId) async {
    try {
      return await _bookings.doc(bookingId).get();
    } catch (e, stackTrace) {
      _logError('getBookingDetails', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets available companions
  Future<List<DocumentSnapshot>> getAvailableCompanions({
    int limit = 10,
    String? city,
  }) async {
    try {
      Query query = _companions
          .where('is_available', isEqualTo: true)
          .limit(limit);

      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }

      final snapshot = await query.get();
      return snapshot.docs;
    } catch (e, stackTrace) {
      _logError('getAvailableCompanions', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets companion profile
  Future<DocumentSnapshot> getCompanionProfile(String companionId) async {
    try {
      return await _companions.doc(companionId).get();
    } catch (e, stackTrace) {
      _logError('getCompanionProfile', e, stackTrace);
      throw _handleFirestoreError(e);
    }
  }

  /// Gets stream of companion profile changes
  Stream<DocumentSnapshot> getCompanionProfileStream(String companionId) {
    return _companions.doc(companionId).snapshots().handleError((e, stackTrace) {
      _logError('getCompanionProfileStream', e, stackTrace);
      throw _handleFirestoreError(e);
    });
  }

  // Private helper methods
  void _logError(String methodName, dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Error in $methodName: $error');
      print(stackTrace);
    }
  }

  Exception _handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      return Exception('Firestore error: ${error.message}');
    }
    return Exception('An unexpected error occurred');
  }
}
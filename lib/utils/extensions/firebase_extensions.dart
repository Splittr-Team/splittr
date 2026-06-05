import 'package:firebase_core/firebase_core.dart';
import 'package:sky_architecture/sky_architecture.dart';

extension FirebaseExceptionX on FirebaseException {
  /// Converts any [FirebaseException] (Auth, Firestore, Storage, etc.)
  /// into a domain-friendly [ServerException].
  ServerException toServerException() => switch (code) {
    // --- Firebase Auth Errors ---
    'user-not-found' => ServerException(
      message: 'No user found for that email.',
      code: code,
    ),
    'wrong-password' || 'invalid-credential' => ServerException(
      message: 'Invalid email or password provided.',
      code: code,
    ),
    'email-already-in-use' => ServerException(
      message: 'An account already exists for that email.',
      code: code,
    ),
    'invalid-email' => ServerException(
      message: 'The email address is not valid.',
      code: code,
    ),
    'weak-password' => ServerException(
      message: 'The password provided is too weak.',
      code: code,
    ),
    'user-disabled' => ServerException(
      message: 'This user account has been disabled.',
      code: code,
    ),
    'operation-not-allowed' => ServerException(
      message: 'This sign-in method is not enabled.',
      code: code,
    ),
    'requires-recent-login' => ServerException(
      message: 'Please log in again to perform this action.',
      code: code,
    ),

    // --- Firestore & General Errors ---
    'permission-denied' => ServerException(
      message: 'You do not have permission to perform this action.',
      code: code,
    ),
    'unavailable' => ServerException(
      message: 'The service is currently unavailable. Please try again later.',
      code: code,
    ),
    'not-found' => ServerException(
      message: 'The requested document or resource was not found.',
      code: code,
    ),
    'already-exists' => ServerException(
      message: 'The document you are trying to create already exists.',
      code: code,
    ),
    'deadline-exceeded' => ServerException(
      message: 'The operation took too long to complete.',
      code: code,
    ),

    // --- Network Errors ---
    'network-request-failed' => ServerException(
      message: 'Network error. Please check your connection.',
      code: code,
    ),
    'too-many-requests' => ServerException(
      message: 'Too many attempts. Please try again later.',
      code: code,
    ),
    _ => ServerException(
      message: message ?? 'An unknown error occurred in $plugin.',
      code: code,
    ),
  };
}

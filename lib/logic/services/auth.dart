import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repos/firestore_service.dart';

class Auth {
  /// Sin in with email and password
  Future signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up with email and password
  Future signUp(FirestoreService db, String email, String password) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Add user with user ID from Auth to Firestore
      await db.addUser(userID: user.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      rethrow;
    }
  }
}

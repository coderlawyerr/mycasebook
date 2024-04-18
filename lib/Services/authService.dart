import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() => _auth.currentUser;

   Future<String?> signIn(String email, String password) async {
    User? user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      if (kDebugMode) {
        print('Error: Giriş işleminde Hata!: $e');
      }
      return null;
    }
    return user!.uid;
  }

  Future<String?> signupWithEmail(String email, String password) async {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user!.uid;
  }

  void signOut() async {
    return await _auth.signOut();
  }
}

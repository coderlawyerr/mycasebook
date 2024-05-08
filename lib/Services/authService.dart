import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// AuthServis sınıfı, kimlik doğrulama işlemlerini gerçekleştiren metotları içerir.
class AuthService {
  // FirebaseAuth örneği oluşturulur.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //  Bu metodd mevcut oturum açmış kullanıcıyı döndürür.
  User? getCurrentUser() => _auth.currentUser;
  // Kullanıcı giriş işlemi için e-posta ve şifre ile oturum açma işlemi gerçekleştirir.
  Future<String?> signIn(String email, String password) async {
    User? user; // Kullanıcı nesnesi oluşturulur.
    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      // Hata durumunda hatanın ekrana yazdırılması.
      if (kDebugMode) {
        print('Error: Giriş işleminde Hata!: $e');
      }
      return null;
    }
    return user!.uid;
  }

  // E-posta ve şifreyle yeni bir kullanıcı hesabı oluşturma işlemi gerçekleştirir.
  Future<String?> signupWithEmail(String email, String password) async {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user!.uid;
  }

  //sıfre deg
  Future<bool> passwordReset(String email) async {
    return await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => true)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    });
  }

  // Bu fonksiyon, bir şifre sıfırlama işleminin onaylanmasını sağlar.
  Future<bool> confirmPasswordReset(
      {required String code, required String newPassword}) async {
    return await _auth
        .confirmPasswordReset(code: code, newPassword: newPassword)
        .then((value) => true)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    });
  }

  // Kullanıcının oturumunu sonlandırır.
  void signOut() async {
    return await _auth.signOut();
  }
}

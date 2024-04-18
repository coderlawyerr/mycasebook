import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/product_model.dart';

class DataBaseService {
  final FirebaseFirestore ref = FirebaseFirestore.instance;

  ///kullanıcı kayıt etmek ıcın
  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await ref
          .collection('users')
          .doc(data['UserID'])
          .set(data)
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }
  ////kullanıcı bılgılerını fırebaseden getırıyor

  Future<Map<String, dynamic>?> findUserbyID(String userID) async {
    try {
      return await ref.collection("users").doc(userID).get().then((userData) {
        return userData.data();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

//// urun  ekelem sayfasınıa aıt
  ///
  Future<bool?> addNewProduct(String userId,ProductModel data) async {
    try {
      data.productID = AutoIdGenerator.autoId();
      return await ref
          .collection('users')
          .doc(userId)
          .collection('Products')
          .doc(data.productID)
          .set(data.toMap())
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }
}

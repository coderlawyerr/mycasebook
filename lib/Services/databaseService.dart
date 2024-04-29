import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';

class DataBaseService {
  final FirebaseFirestore _ref = FirebaseFirestore.instance;

  ///kullanıcı kayıt etmek ıcın///eklemme
  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await _ref
          .collection('users')
          .doc(data['UserID'])
          .set(data)
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }
  ////kullanıcı bılgılerını fırebaseden getırıyor//okuma

  Future<Map<String, dynamic>?> findUserbyID(String userID) async {
    try {
      return await _ref.collection("users").doc(userID).get().then((userData) {
        return userData.data();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

//// urun  ekleme sayfasınıa aıt
  ///
  Future<bool?> addNewProduct(String userId, ProductModel data) async {
    try {
      data.productID = AutoIdGenerator.autoId();
      ProcessModel processModel = ProcessModel.predefined(
          product: data, date: DateTime.now(), processType: IslemTipi.alis);
      processModel.processId = AutoIdGenerator.autoId();
      return await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap())
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  //ürünlerım sayfası//getıme
  Future<List<ProductModel>> fetchProcess(String userID) async {
    try {
      List<ProductModel> productList = [];
      return await _ref
          .collection('users')
          .doc(userID)
          .collection('Processes')
          .where("processType", isEqualTo: IslemTipi.alis.index)
          .get()
          .then((processes) {
        for (var process in processes.docs) {
          ProcessModel p = ProcessModel();
          p.parseMap(process.data());
          productList.add(p.product);
        }
        return productList;
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool?> addSupplierOrCustomer(
      {required String userId, required SuplierCustomerModel data}) async {
    try {
      String referans =
          data.currentType == CurrentType.musteri ? "Customer" : "Supplier";
      return await _ref
          .collection('users')
          .doc(userId)
          .collection(referans)
          .doc()
          .set(data.toMap())
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<SuplierCustomerModel>> fetchCustomer(String userID) async {
    try {
      List<SuplierCustomerModel> customerlist = [];
      await _ref
          .collection('users')
          .doc(userID)
          .collection('Customer')
          .get()
          .then((customer) {
        if (customer.size > 0) {
          for (var customer in customer.docs) {
            SuplierCustomerModel c = SuplierCustomerModel();
            c.parseMap(customer.data());
            c.id = customer.id;
            customerlist.add(c);
          }
        }
      });

      await _ref
          .collection('users')
          .doc(userID)
          .collection('Supplier')
          .get()
          .then((suplier) {
        if (suplier.size > 0) {
          for (var sup in suplier.docs) {
            SuplierCustomerModel c = SuplierCustomerModel();
            c.parseMap(sup.data());
            c.id = sup.id;
            customerlist.add(c);
          }
        }
      });

      return customerlist;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> deleteSuplierOrCustomer(
      {required String userId, required SuplierCustomerModel data}) async {
    try {
      String referans =
          data.currentType == CurrentType.musteri ? "Customer" : "Supplier";
      await _ref
          .collection('users')
          .doc(userId)
          .collection(referans)
          .doc(data.id)
          .delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

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
      if (kDebugMode) {
        print(e);
      }
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
      data.date = DateTime.now().millisecondsSinceEpoch;
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
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool?> createSaleProcess({
    required String userId,
    required ProcessModel processModel,
  }) async {
    try {
      processModel.processId = AutoIdGenerator.autoId();

      return await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap())
          .then((value) => true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  //ürünlerım sayfası//getıme
  Future<List<ProcessModel>> fetchProcess(
      {required String userID, required IslemTipi tip}) async {
    try {
      List<ProcessModel> productList = [];
      return await _ref
          .collection('users')
          .doc(userID)
          .collection('Processes')
          .where("processType", isEqualTo: tip.index)
          .get()
          .then((processes) {
        for (var process in processes.docs) {
          ProcessModel p = ProcessModel();
          p.parseMap(process.data());
          productList.add(p);
        }
        return productList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<ProcessModel>> fetchAllProcess({required String userID}) async {
    try {
      List<ProcessModel> processList = [];
      return await _ref
          .collection('users')
          .doc(userID)
          .collection('Processes')
          .get()
          .then((processes) {
        for (var process in processes.docs) {
          ProcessModel p = ProcessModel();
          p.parseMap(process.data());
          processList.add(p);
        }
        return processList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<ProductModel>> fetchProducts(String userID) async {
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
          ProcessModel d = ProcessModel();
          d.parseMap(process.data());
          productList.add(d.product);
        }
        return productList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> addSupplierOrCustomer(
      {required String userId, required SuplierCustomerModel data}) async {
    try {
      return await _ref
          .collection('users')
          .doc(userId)
          .collection("Customer&Supplier")
          .doc()
          .set(data.toMap())
          .then((value) => true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<SuplierCustomerModel>> fetchCustomerAndSuppliers(
      String userID) async {
    try {
      List<SuplierCustomerModel> customerlist = [];
      await _ref
          .collection('users')
          .doc(userID)
          .collection("Customer&Supplier")
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

      return customerlist;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<SuplierCustomerModel>> fetchCustomers(String userID) async {
    try {
      List<SuplierCustomerModel> customerlist = [];
      await _ref
          .collection('users')
          .doc(userID)
          .collection("Customer&Supplier")
          .where("currentType", isEqualTo: 1)
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

      return customerlist;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

//// sılme ıslemı
  Future<bool> deleteSuplierOrCustomer(
      {required String userId, required SuplierCustomerModel data}) async {
    try {
      await _ref
          .collection('users')
          .doc(userId)
          .collection("Customer&Supplier")
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

  Future<bool> updateProcess(
      {required String userID, required ProcessModel newData}) async {
    try {
      return await _ref
          .collection('users')
          .doc(userID)
          .collection("Processes")
          .doc(newData.processId)
          .update(newData.toMap())
          .then((value) => true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

//sılme ıslemı
  Future<bool> deleteProcess(
      {required String userId, required ProcessModel data}) async {
    try {
      await _ref
          .collection('users')
          .doc(userId)
          .collection("Processes")
          .doc(data.processId)
          .delete();
      if (kDebugMode) {
        print("process sİlindi");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> editSuplierOrCustomer(
      {required String userId, required SuplierCustomerModel newData}) async {
    try {
      await _ref
          .collection('users')
          .doc(userId)
          .collection("Customer&Supplier")
          .doc(newData.id)
          .update(newData.toMap()); // newData ile verileri güncelle
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> editProcess(
      {required String userId, required ProcessModel newData}) async {
    try {
      await _ref
          .collection('users')
          .doc(userId)
          .collection("Processes")
          .doc(newData.processId)
          .update(newData.toMap()); // newData ile verileri güncelle
      if (kDebugMode) {
        print("process güncellendi");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<Map<String, double>> bringStatistics({required String userID}) async {
    try {
      Map<String, double> data = {};
      List<ProcessModel> processesList = await fetchAllProcess(userID: userID);

      double totalIncome = 0;
      double totalOutcome = 0;
      processesList.forEach((process) {
        if (process.processType == IslemTipi.satis) {
          totalIncome += process.gelirHesapla();
        } else {
          totalOutcome += process.giderHesapla();
        }
      });

      double total = totalIncome + totalOutcome;

      data["Gelir"] = (100.0 * totalIncome) / total;
      data["Gider"] = (100.0 * totalOutcome) / total;

      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }
}

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

//// urun  ekleme sayfasında / ürün ekler / ürün alış işlemi modelin içindedir
  Future<bool?> addNewProduct(String userId, ProductModel data) async {
    try {
      data.productID = AutoIdGenerator.autoId();
      data.date = DateTime.now().millisecondsSinceEpoch;
      // İşlem modelini oluştur
      ProcessModel processModel = ProcessModel.predefined(
          product: data, date: DateTime.now(), processType: IslemTipi.alis);
      processModel.processId = AutoIdGenerator.autoId();
      await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap());
     // Kullanıcının bakiyesini güncelle
      await _ref.collection('users').doc(userId).update({
        "bakiye": FieldValue.increment(-(data.buyPrice * data.productAmount))
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  //urun satıs işlemi modeli oluşturup firebase e kaydeder
  Future<bool?> createSaleProcess({
    required String userId,
    required ProcessModel processModel,
    required ProcessModel otherProcess,
  }) async {
    try {
      processModel.processId = AutoIdGenerator.autoId();

      await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap());

      await _ref.collection('users').doc(userId).update({
        "bakiye": FieldValue.increment((processModel.product.sellPrice *
            processModel.product.productAmount))
      });

      if (processModel.product.productAmount ==
          otherProcess.product.productAmount) {
        await _ref
            .collection('users')
            .doc(userId)
            .collection('Processes')
            .doc(otherProcess.processId)
            .delete();
      } else {
        otherProcess.product.productAmount -=
            processModel.product.productAmount;
        var tem = otherProcess.product.toMap();
        await _ref
            .collection('users')
            .doc(userId)
            .collection('Processes')
            .doc(otherProcess.processId)
            .update({"product": tem});
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  //ürünlerım sayfası// alış işlemlerini getirir
  Future<List<ProcessModel>> fetchProcess(
      {required String userID, required IslemTipi tip}) async {
    try {
      List<ProcessModel> productList = [];
      // Firestore'dan belirli bir kullanıcının işlemlerini getirmek için sorgu yapılıyor
      return await _ref
          .collection('users')
          .doc(userID)
          .collection('Processes')
          .where("processType", isEqualTo: tip.index)
          .get()
          .then((processes) {
       // `processes.docs` içindeki her belge için döngü oluşturuluyor
        processes.docs.forEach((process) {
          // Boş bir `ProcessModel` örneği oluşturuluyor ve `parseMap` fonksiyonu ile verileri işleniyor
          ProcessModel p = ProcessModel()..parseMap(process.data());
          productList.add(p);
        });

        // Tarihine göre sıralama yapılıyor
        productList.sort((a, b) =>
            a.date.microsecondsSinceEpoch < b.date.microsecondsSinceEpoch
                ? 1
                : 0);
        return productList;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  //bütün işlemleri getirir / işlemlerin içinde ürünler var
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

  ///sadece alış işlemlerindeki ürünlerin listesini getiriyor
  Future<List<ProcessModel>> fetchProducts(String userID) async {
    try {
      List<ProcessModel> processList = [];
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
          processList.add(d);
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

////tedarıkcı ve musterı ekleme sayfası
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

//müşteri&Tedarikçi modellerinin listesini döndürür
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
           // Her bir müşteri veya tedarikçi belgesi için döngü oluşturuyoruz.
          for (var customer in customer.docs) {
             // Yeni bir SuplierCustomerModel nesnesi oluşturuyoruz.
            SuplierCustomerModel c = SuplierCustomerModel();
            // Firestore'dan alınan verileri SuplierCustomerModel nesnesine dönüştürüp atıyoruz.
            c.parseMap(customer.data());
             // Müşteri veya tedarikçi belgesinin kimliğini ilgili modele atıyoruz.
            c.id = customer.id;
             // Oluşturduğumuz müşteri veya tedarikçi modelini listeye ekliyoruz.
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

//sadece müşterileri döndürür
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

//guncelleme urun sayfası
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

//sılme ıslemı urun
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

  //musterı tedarıkcı guncelle
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

  ///urun guncelle
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

//over vıew  grafık
  Future<Map<String, double>> bringStatistics({required String? userID}) async {
    if (userID == null) return {};
    try {
      Map<String, double> data = {};
      List<ProcessModel> processesList = await fetchAllProcess(userID: userID);

      double totalIncome = 0;
      double totalOutcome = 0;
      for (var process in processesList) {
        if (process.processType == IslemTipi.satis) {
          totalIncome += process.gelirHesapla();
        } else {
          totalOutcome += process.giderHesapla();
        }
      }

      double total = totalIncome + totalOutcome;

      data["Alım"] = (100.0 * totalIncome) / total;
      data["Satım"] = (100.0 * totalOutcome) / total;

      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }
}

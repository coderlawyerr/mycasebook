
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<bool?> addNewProduct(String userId, ProductModel product, File imageFile) async {
    try {
      product.productID = AutoIdGenerator.autoId();
      product.date = DateTime.now().millisecondsSinceEpoch;

      DocumentReference productRef = await _ref
          .collection('users')
          .doc(userId)
          .collection('Products')
          .add(product.toMap());

      String productId = productRef.id;
      // Fotoğrafı Firebase Storage'a yükle
      String imageURL = await uploadImage(imageFile, productId);
      // Firestore'da ürün belgesini güncelle, fotoğraf URL'si ekleyerek
      await productRef.update({'photoURL': imageURL});
    
    // İşlem modelini oluştur ve Firestore'a gönder
      var pref = _ref
          .collection('users')
          .doc(userId)
          .collection('Products')
          .doc(product.productID);

      ProcessModel processModel = ProcessModel.predefined(
          product: product, date: DateTime.now(), processType: IslemTipi.alis);

      processModel.productRef = pref;

      processModel.processId = AutoIdGenerator.autoId();

      await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap());
  // Kullanıcının bakiyesini güncelle (opsiyonel)
      await _ref.collection('users').doc(userId).update({
        "bakiye":
            FieldValue.increment(-(product.buyPrice * product.productAmount))
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

   Future<String> uploadImage(File imageFile, String productId) async {
    try {
      String imagePath = 'images/$productId.jpg';
      final Reference ref = FirebaseStorage.instance.ref().child(imagePath);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }

    Future<bool> deleteProductImage(String userId, String productId) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child('images/$productId.jpg')
          .delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

Future<bool> updateProductImage(String userId, String productId, File? newImageFile) async {
  try {
    if (newImageFile != null) { // Dosya nesnesi null değilse işlem yap
      await FirebaseStorage.instance
          .ref()
          .child('images/$productId.jpg')
          .putFile(newImageFile);
      return true;
    } else {
      // Dosya nesnesi null ise işlem yapma
      if (kDebugMode) {
        print('Yeni resim dosyası bulunamadı.');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}


  Future<String?> getProductImageURL(String userId, String productId,File? newImageFile) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child('images/$productId.jpg')
          .getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //urun satıs işlemi modeli oluşturup firebase e kaydeder
  Future<bool?> createSaleProcess({
    required String userId,
    required ProcessModel processModel,
  }) async {
    try {
      processModel.processId = AutoIdGenerator.autoId();

      var pref = _ref
          .collection('users')
          .doc(userId)
          .collection("Products")
          .doc(processModel.product.productID);

      processModel.productRef = pref;
      await _ref
          .collection('users')
          .doc(userId)
          .collection('Processes')
          .doc(processModel.processId)
          .set(processModel.toMap());

     

      await _ref.doc(pref.path).update({
        "productAmount":
            FieldValue.increment(processModel.product.productAmount * -1)
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

Future<List<ProcessModel>> fetchProcess({required String userID, required IslemTipi tip}) async {
  try {
    List<ProcessModel> processList = [];
    
    // Firestore'dan belirli bir kullanıcının işlemlerini getirmek için sorgu yapılıyor
    QuerySnapshot<Map<String, dynamic>> processes = await _ref
        .collection('users')
        .doc(userID)
        .collection('Processes')
        .where("processType", isEqualTo: tip.index)
        .get();

    // Her bir işlem belgesi için döngü oluşturuluyor
    for (var process in processes.docs) {
      // Boş bir `ProcessModel` örneği oluşturuluyor ve `parseMap` fonksiyonu ile verileri işleniyor
      ProcessModel p = ProcessModel();
      p.parseMap(map: process.data());
      
      // İşlem belgesinde fotoğraf URL'si varsa, fotoğraf bilgisini al ve `ProcessModel` örneğine ekle
      if (process.data().containsKey('photoURL')) {
        p.photoURL = process.data()['photoURL'];
      }
      
      // İşlem listesine ekle
      processList.add(p);
    }

    // Tarihe göre sıralama yapılıyor
    processList.sort((a, b) => a.date.compareTo(b.date));
    
    return processList;
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
          // Boş bir `ProcessModel` örneği oluşturuluyor ve `parseMap` fonksiyonu ile verileri işleniyor
          ProcessModel p = ProcessModel();
          p.parseMap(map: process.data());
          processList.add(p);
        }
        processList.sort(((a, b) =>
            b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch));
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
  Future<List<ProductModel>> fetchProducts(String userID) async {
    try {
      List<ProductModel> productsList = [];
      return await _ref
          .collection('users')
          .doc(userID)
          .collection('Products')
          .get()
          .then((products) {
        for (var product in products.docs) {
          ProductModel p = ProductModel();
          p.parseMap(product.data());
          productsList.add(p);
        }
        return productsList;
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
// Firestore üzerinde belirli bir kullanıcının ürün bilgisini güncellemek için kullanılan metod.
  Future<bool> updateProduct(
      {required String userID, required ProductModel newData}) async {
    try {
      return await _ref
          .collection('users')
          .doc(userID)
          .collection("Products")
          .doc(newData.productID)
          .update(newData.toMap())
          .then((value) => true);
    } catch (e) {
      // Eğer güncelleme işlemi sırasında bir hata oluşursa, bu hata yakalanır ve işlem hata ayıklama modunda (debug mode) ise konsola yazdırılır.
      // Güncelleme işlemi başarısız olduğu için false döndürülür.
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

//sılme ıslemı urun
  Future<bool> deleteProduct(
      {required String userId, required ProductModel data}) async {
    try {
      await _ref
          .collection('users')
          .doc(userId)
          .collection("Products")
          .doc(data.productID)
          .delete();
      if (kDebugMode) {
        print("product silindi");
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
// Kullanıcı istatistiklerini getirmek için kullanılan fonksiyon
// Parametre olarak kullanıcı kimliği alır
  Future<Map<String, double>> bringStatistics({required String? userID}) async {
    // Eğer kullanıcı kimliği null ise, boş bir harita döndür
    if (userID == null) return {};

    try {
      // Veri haritası oluştur
      Map<String, double> data = {};

      // Kullanıcının tüm işlemlerini al
      List<ProcessModel> processesList = await fetchAllProcess(userID: userID);

      // Toplam gelir ve gider miktarlarını saklamak için değişkenler oluştur
      double totalIncome = 0;
      double totalOutcome = 0;

      // İşlemler listesini döngüye alarak toplam gelir ve gider miktarlarını hesapla
      for (var process in processesList) {
        // İşlem türüne göre gelir ve gider miktarlarını hesapla
        if (process.processType == IslemTipi.satis) {
          // Gelir hesabı yap ve toplam gelire ekle
          totalIncome += process.gelirHesapla();
        } else {
          // Gider hesabı yap ve toplam gider miktarına ekle
          totalOutcome += process.giderHesapla();
        }
      }

      // Toplam gelir ve gider miktarlarının toplamını hesapla
      double total = totalIncome + totalOutcome;

      // Veri haritasına gelir ve gider yüzdelerini ekle
      data["Gelirler - $totalIncome TL"] = (100.0 * totalIncome) / total;
      data["Giderler - $totalOutcome TL"] = (100.0 * totalOutcome) / total;

      // İstatistik verilerini düzenle ve döndür
      return data;
    } catch (e) {
      // Hata durumunda hata mesajını konsola yazdır
      if (kDebugMode) {
        print(e);
      }
      // Boş bir harita döndür
      return {};
    }
  }
}

//////////////////////////////


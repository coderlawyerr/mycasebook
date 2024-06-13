import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/product_model.dart';

// KarZarar enum sınıfı, bir ürünün kar, zarar veya stabil olduğunu belirtir.
enum KarZarar { kar, zarar, stabil }

// IslemTipi enum sınıfı, bir işlemin alış mı yoksa satış mı olduğunu belirtir.
enum IslemTipi { alis, satis }

class ProcessModel {
  late String processId;
  late DateTime date;
  late ProductModel product; 
  late DocumentReference<Map<String, dynamic>> productRef;
  late String? customerName;
  late KarZarar? profitState;
  late IslemTipi processType;
  String? photoURL;

  ProcessModel(); //Constractor

  ProcessModel.predefined({
    // named Constractor
    required this.date,
    required this.product,
    this.customerName,
    required this.processType,
  }) {
    if (product.buyPrice < product.sellPrice) {
      profitState = KarZarar.kar;
    } else if (product.buyPrice == product.sellPrice) {
      profitState = KarZarar.stabil;
    } else {
      profitState = KarZarar.zarar;
    }
  }

  get customerId => null;

// İşlem kazancını hesaplayan fonksiyon
  double gelirHesapla() {
    double kazancFiyat = product.productAmount.toDouble() * product.sellPrice;
    return kazancFiyat;
  }

  double giderHesapla() {
    // Alış adeti ile alış birim fiyatının çarpılması
    return product.productAmount.toDouble() * product.buyPrice;
  }

  double karHesapla() {
    return gelirHesapla() - giderHesapla();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': processId,
      'product': product.toMap(),
      'productRef': productRef,
      'date': date.millisecondsSinceEpoch,
      'customerName': customerName ?? "",
      'profitState':
          profitState != null ? profitState!.index : KarZarar.stabil.index,
      'processType': processType.index,
    };
  }

  void parseMap({
    required Map<String, dynamic> map,
  }) {
    processId = map["id"];
    date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    product = ProductModel();
    product.parseMap(map["product"]);
    customerName = map["customerName"];
    profitState = KarZarar.values[map["profitState"]];
    processType = IslemTipi.values[map["processType"]];
    productRef = map["productRef"];
  }
}

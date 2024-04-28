import 'package:flutter_application_1/models/product_model.dart';

// KarZarar enum sınıfı, bir ürünün kar, zarar veya stabil olduğunu belirtir.
enum KarZarar { kar, zarar, stabil }

// IslemTipi enum sınıfı, bir işlemin alış mı yoksa satış mı olduğunu belirtir.
enum IslemTipi { alis, satis }

class ProcessModel {
  late String processId;
  late DateTime date;
  late ProductModel product;
  late String? customerName;
  late KarZarar? profitState;
  late IslemTipi processType;

  ProcessModel(); //Constractor

  ProcessModel.predefined({
    // named Constractor
    required this.date,
    required this.product,
    this.customerName,
    this.profitState,
    required this.processType,
  });

// İşlem kazancını hesaplayan fonksiyon
  double kazancHesapla() {
    double kazancFiyat = product.productAmount.toDouble() * product.sellPrice;
    return kazancFiyat;
  }

  // İşlem toplam tutarını hesaplayan fonksiyon
  double toplamTutar() {
    return product.productAmount.toDouble() * product.buyPrice;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': processId,
      'product': product.toMap(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'customerName': customerName ?? "",
      'profitState': profitState != null ? profitState!.index : KarZarar.stabil.index,
      'processType': processType.index,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    processId = map["id"];
    date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    product = ProductModel();
    product.parseMap(map["product"]);
    customerName = map["customerName"];
    profitState = KarZarar.values[map["profitState"]];
    processType = IslemTipi.values[map["processType"]];
  }
}



class ProductModel {
  late String productID;
  late String productName;
  late double buyPrice;
  late double sellPrice;
  late int productAmount;
  late int date;

  Map<String, dynamic> toMap() {
    return {
      'id': productID,
      'productName': productName,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'productAmount': productAmount,
      'date': DateTime.now().millisecondsSinceEpoch,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    productName = map["productName"] ?? "null";
    buyPrice = map["buyPrice"] ?? "null";
    sellPrice = map["sellPrice"] ?? 0;
    productID = map["id"];
    date = map["date"];
    productAmount = map["productAmount"];
  }
}

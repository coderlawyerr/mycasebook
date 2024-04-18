class ProductModel {
  late String productID;
  late String productName;
  late double buyPrice;
  late double sellPrice;
  late int productAmount;


 Map<String, dynamic> toMap() {
    return {
      'id':productID,
      'productName': productName,
      'buyPrice': buyPrice ,
      'sellPrice': sellPrice ,
      'productAmount': productAmount,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    productName = map["productName"] ?? "null";
    buyPrice = map["buyPrice"] ?? "null";
    sellPrice = map["sellPrice"] ?? 0;
    productID = map["id"];
  }
}

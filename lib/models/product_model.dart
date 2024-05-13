//model urun

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
      'date': date,
    };
  }

  ProductModel parseMap(Map<String, dynamic> map) {
    // Ürün adını al, eğer boşsa "null" olarak ata
    productName = map["productName"] ?? "null";
    buyPrice = map["buyPrice"] ?? 0;
    sellPrice = map["sellPrice"] ?? 0;
    productID = map["id"];
    date = map["date"];
    productAmount = map["productAmount"];
    return this;
  }
}

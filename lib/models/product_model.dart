//model urun

class ProductModel {
  late String productID;
  late String productName;
  late double buyPrice;
  late double sellPrice;
  late int productAmount;
  late int date;
  late String photoURL;

  late String imageURL;

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'id': productID,
      'productName': productName,///kafam akrıstı bılrıkte yapalım mı esıtleme kısmını o daha mantıklı
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'productAmount': productAmount,
      'date': date,
      'photoURL': photoURL,
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
    photoURL = map["photoURL"]; // Resim URL'si
    return this;
  }
}

enum CurrentType { tedarikci, musteri }

class SuplierCustomerModel {
  late CurrentType currentType;
  late String username;
  late int tel;
  late String adress;

  Map<String, dynamic> toMap() {
    return {
      'currentType': currentType.index,
      'username': username,
      'tel': tel,
      'adress': adress,
    };
  }

  void parseMap(Map<String, dynamic> data) {
    currentType = CurrentType.values[data["currentType"]];
    username = data["username"];
    tel = data["tel"];
    adress = data["adress"];
  }
}

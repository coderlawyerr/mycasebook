enum CurrentType { tedarikci, musteri }

class SuplierCustomerModel {
  late String id;
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
     // 'id':id
    };
  }

  void parseMap(Map<String, dynamic> data) {
    currentType = CurrentType.values[data["currentType"]];
    username = data["username"];
    tel = data["tel"];
    adress = data["adress"];
   // id=data['id'];
  }
}

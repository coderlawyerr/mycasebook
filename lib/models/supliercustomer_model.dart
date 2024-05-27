import 'package:cloud_firestore/cloud_firestore.dart';

enum CurrentType { tedarikci, musteri }

class SuplierCustomerModel {
  late String id;
  late CurrentType currentType;
  late String username;
  late int tel;
  late String adress;
  late DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'currentType': currentType.index,
      'username': username,
      'tel': tel,
      'adress': adress,
      'date': Timestamp.fromDate(date),
     // 'id':id
    };
  }

  void parseMap(Map<String, dynamic> data) {
    currentType = CurrentType.values[data["currentType"]];
    username = data["username"];
    tel = data["tel"];
    adress = data["adress"];
    date = (data["date"] as Timestamp).toDate();
   // id=data['id'];
  }
}

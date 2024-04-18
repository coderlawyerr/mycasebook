class UserModel {
  final String userID;
  String? _name;
  String? _surname;
  String? _email;
  int? _telNo;
  UserModel({required this.userID});

  //Getter
  String getUserId() => userID;
  String? getUserName() => _name;
  String? getSurname()=> _surname;
  String? getEmail()=> _email;
  int? getTelNo()=> _telNo;

  //Setter
  void setUserName(String name) {
    _name = name;
  }

  void setUserSurname(String surname) {
    _surname = surname;
  }
  void setEmail(String email) {
    _email = email;
  }
  void setTelno(int telno) {
    _telNo = telno;
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': _name ?? 'null',
      'Surname': _surname ?? 'null',
      'Email': _email ?? 'null',
      'PhoneNumber': _telNo ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    _name = map["Name"] ?? "null";
    _surname = map["Surname"] ?? "null";
    _email = map["Email"] ?? "null";
    _telNo = map["PhoneNumber"] ?? 0;
  }

}
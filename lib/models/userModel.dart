class UserModel {
  final String userID;
  String? name;
  String? email;
  int? telNo;
  UserModel({required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'UserID': userID,
      'Name': name ?? 'null',
      'Email': email ?? 'null',
      'PhoneNumber': telNo ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    name = map["Name"] ?? "null";
    email = map["Email"] ?? "null";
    telNo = map["PhoneNumber"] ?? 0;
  }
}

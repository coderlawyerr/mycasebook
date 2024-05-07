// UserModel sınıfı, kullanıcı verilerini temsil eder ve bu verileri bir harita şeklinde saklamak ve işlemek için kullanılır.
class UserModel {
  final String userID; // Kullanıcıya ait benzersiz bir kimlik tanımlayıcısı

  String? name; // Kullanıcının adı
  String? email; // Kullanıcının e-posta adresi
  int? telNo; // Kullanıcının telefon numarası
  double bakiye = 0;

  // UserModel sınıfının kurucu metodu, userID parametresini zorunlu olarak alır.
  UserModel({required this.userID});

  // Bu metod, UserModel örneğini bir haritaya dönüştürür.
  Map<String, dynamic> toMap() {
    return {
      'UserID': userID, // Kullanıcı kimliği
      'Name': name ?? 'null', // Kullanıcı adı, null ise 'null' olarak ayarlanır
      'Email': email ??
          'null', // Kullanıcı e-postası, null ise 'null' olarak ayarlanır
      'PhoneNumber':
          telNo ?? 0, // Kullanıcı telefon numarası, null ise 0 olarak ayarlanır
      'bakiye': bakiye
    };
  }

  // Bu metod, bir haritayı UserModel örneğine dönüştürür.
  void parseMap(Map<String, dynamic> map) {
    // Haritadan kullanıcı adını alır, null ise 'null' olarak ayarlar
    name = map["Name"] ?? "null";
    // Haritadan kullanıcı e-postasını alır, null ise 'null' olarak ayarlar
    email = map["Email"] ?? "null";
    // Haritadan kullanıcı telefon numarasını alır, null ise 0 olarak ayarlar
    telNo = map["PhoneNumber"] ?? 0;
    bakiye = map["bakiye"] as double;
  }
}

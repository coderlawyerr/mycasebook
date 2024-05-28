/*
Firebase Storage'a fotoğraf yüklemek için kullanılır.

*/
import 'dart:io'; // Dosya işlemleri için dart:io kütüphanesi
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async'; 

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Firebase Storage örneği
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firebase Firestore örneği


  // Ürün resmini yükleyen fonksiyon
  Future<String?> uploadProductImage({XFile? imagePath}) async {//
    if (imagePath != null) {
      // Eğer resim yolu belirlenmişse devam et
      // Dosyayı File türüne dönüştürün
      final File file = File(imagePath.path);

      // Firebase Storage'a yükleyin
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}'; // Dosya adını belirleme
      Reference storageRef =
          _storage.ref().child(fileName); // Yüklenecek dosyanın referansı
      UploadTask uploadTask =
          storageRef.putFile(file); // Dosyayı yükleme işlemi

      // Yükleme tamamlandığında URL'yi alın
      TaskSnapshot snapshot = await uploadTask;
      return snapshot.ref.getDownloadURL(); // Yüklenen dosyanın URL'sini döndür
    }
    // Resim yolu belirlenmemişse null döndür
    return null;
  }
}

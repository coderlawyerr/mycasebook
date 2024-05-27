import 'dart:io'; // Dosya işlemleri için dart:io kütüphanesi
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage kütüphanesi
import 'package:image_picker/image_picker.dart'; // Resim seçiminden sorumlu ImagePicker kütüphanesi
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore kütüphanesi

import 'dart:async'; // Asenkron işlemler için dart:async kütüphanesi

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Firebase Storage örneği
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firebase Firestore örneği

  // // Kullanıcıdan bir resim seçerek yükleme işlemini gerçekleştiren fonksiyon
  // Future<void> uploadImage() async {
  //   // Kullanıcıdan bir dosya seçmesini isteyin
  //   final picker = ImagePicker(); // Resim seçiminden sorumlu ImagePicker örneği
  //   // ignore: deprecated_member_use
  //   final PickedFile? pickedFile = await picker.getImage(
  //       source: ImageSource.gallery); // Galeriden resim seçme işlemi

  //   if (pickedFile != null) {
  //     // Eğer kullanıcı bir resim seçtiyse devam et
  //     // Dosyayı File türüne dönüştürün
  //     final File file = File(pickedFile.path);

  //     // Firebase Storage'a yükleyin
  //     String fileName =
  //         'images/${DateTime.now().millisecondsSinceEpoch.toString()}'; // Dosya adını belirleme
  //     Reference storageRef =
  //         _storage.ref().child(fileName); // Yüklenecek dosyanın referansı
  //     UploadTask uploadTask =
  //         storageRef.putFile(file); // Dosyayı yükleme işlemi

  //     // Yükleme tamamlandığında URL'yi alın
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref
  //         .getDownloadURL(); // Yüklenen dosyanın URL'sini alma

  //     // Firestore'a kaydedin
  //     await _firestore.collection('uploaded_images').add({
  //       'url': downloadUrl, // URL
  //       'uploaded_at': DateTime.now(), // Yükleme tarihi
  //     });
  //   }
  // }

  // Ürün resmini yükleyen fonksiyon
  Future<String?> uploadProductImage({XFile? imagePath}) async {
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

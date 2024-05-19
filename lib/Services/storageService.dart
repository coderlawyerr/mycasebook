import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadImage() async {
    // Kullanıcıdan bir dosya seçmesini isteyin
    final picker = ImagePicker();
    final PickedFile? pickedFile =
        await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Dosyayı File türüne dönüştürün
      final File file = File(pickedFile.path);

      // Firebase Storage'a yükleyin
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(file);

      // Yükleme tamamlandığında URL'yi alın
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'a kaydedin
      await _firestore.collection('uploaded_images').add({
        'url': downloadUrl,
        'uploaded_at': DateTime.now(),
      });
    }
  }
}

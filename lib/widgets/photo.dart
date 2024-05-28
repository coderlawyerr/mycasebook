/*

Bu widget, kullanıcının galeriden bir resim seçmesine olanak tanır.


*/

import 'dart:io'; // Dosya işlemleri için gerekli kütüphane
import 'package:flutter/material.dart'; // Flutter'ın temel widget'ları
import 'package:image_picker/image_picker.dart'; // Resim seçmek için gerekli kütüphane

class ProductPhoto extends StatefulWidget {
  final void Function(File)? onPhotoSelected; // Seçilen fotoğrafı geri bildirim olarak göndermek için bir callback fonksiyonu

  const ProductPhoto({super.key, this.onPhotoSelected}); 
  @override
  State<ProductPhoto> createState() => _ProductPhotoState(); // State oluşturma
}

class _ProductPhotoState extends State<ProductPhoto> {
  File? _image; // Seçilen resim dosyasını tutacak değişken

  final picker = ImagePicker(); // ImagePicker nesnesi
///galerıden resım secme için
  Future getImage() async {
    // Galeriden resim seçmek için fonksiyon
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Galeriden resim seç

    setState(() {
      // Ekranı güncelle
      if (pickedFile != null) {
        // Eğer resim seçildiyse
        _image = File(pickedFile.path); // Seçilen resmin dosya yolunu al ve _image değişkenine ata
        if (widget.onPhotoSelected != null) {
          // Eğer callback fonksiyonu tanımlandıysa
          widget.onPhotoSelected!(_image!); // Callback fonksiyonunu çağır ve seçilen resmi gönder
        }
      } else {
        print('Görüntü seçilmedi.'); // Resim seçilmediyse konsola mesaj yaz
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget ağacını oluştur
    return Column(
      children: [
        const SizedBox(height: 20), // Sabit yüksekliğe sahip boşluk
        GestureDetector(
          onTap: getImage, // Dokunma olayında getImage fonksiyonunu çağır
          child: SizedBox(
            width: 300, // Kutunun genişliği
            height: 300, // Kutunun yüksekliği
            child: CustomPaint(
              // Özel bir çizim yapabilmek için CustomPaint widget'ı
              painter: DottedBorderPainter(), // DottedBorderPainter sınıfını kullanarak kenarlıkları çiz
              child: _image == null
                  ? const Center(
                      // Eğer resim seçilmediyse
                      child: Text(
                        'Resim Seç', // Ortada "Resim Seç" metnini göster
                        style: TextStyle(color: Colors.grey, fontSize: 16), // Metin stili
                      ),
                    )
                  : ClipRRect(
                      // Eğer resim seçildiyse
                      borderRadius: BorderRadius.circular(8.0), // Resim köşelerini yuvarla
                      child: Image.file(_image!, fit: BoxFit.cover), // Resmi göster ve kutuyu tamamen dolduracak şekilde ölçeklendir
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Bir Paint nesnesi oluşturarak çizgi özelliklerini belirle
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke // Stili çizgi olarak ayarla
      ..strokeCap = StrokeCap.round; // Çizgi uçlarını yuvarlak yap

    // Kesik çizgilerin uzunluğu ve aralığını belirle
    const dashWidth = 5;
    const dashSpace = 5;

    // Yatay kesik çizgileri çiz
    double startY = 0;
    while (startY < size.height) {
      // Her bir kesik çizgiyi çizmek için canvas.drawLine kullan
      canvas.drawLine(
        Offset(0, startY), // Çizginin başlangıç noktası (x=0, y=startY)
        Offset(0, startY + dashWidth), // Çizginin bitiş noktası (x=0, y=startY + dashWidth)
        paint,
      );
      // Bir sonraki kesik çizgi için başlangıç noktasını güncelle
      startY += dashWidth + dashSpace; // Kesik çizgi uzunluğu ve aralığı kadar arttır
    }

    // Dikey kesik çizgileri çiz
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      // Bir sonraki kesik çizgi için başlangıç noktasını güncelle
      startX += dashWidth + dashSpace;
    }

    // Sağ alt köşeden yukarı doğru kesik çizgileri çiz
    double endY = size.height;
    while (endY > 0) {
      canvas.drawLine(
        Offset(size.width, endY),
        Offset(size.width, endY - dashWidth),
        paint,
      );
      endY -= dashWidth + dashSpace;
    }

    // Sağ alt köşeden sola doğru kesik çizgileri çiz
    double endX = size.width;
    while (endX > 0) {
      canvas.drawLine(
        Offset(endX, size.height),
        Offset(endX - dashWidth, size.height),
        paint,
      );
      endX -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // Yeniden boyama gerekip gerekmediğini belirler
}

import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPhoto extends StatefulWidget {
  final void Function(File)?
      onPhotoSelected; // e varmış zaten bda baktif mi kullanıyor msuun? ısde dosyayı secebılıyorum max hersey bırbırıne gırdıı suan kafam karıstıı
  ProductPhoto({Key? key, this.onPhotoSelected}) : super(key: key);
  @override
  _ProductPhotoState createState() => _ProductPhotoState();
}

class _ProductPhotoState extends State<ProductPhoto> {
  File? _image;

// buraya bir fonksiyon ekliyebilirsin dışarıdan alınan. bu fonksiyon geriye seçilen resmi döndürür
  Future<void> dosyayukle() async {
    // ben hızlı olsun diye kopyaladım. sen sonra düzenlersin kodları
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("productphoto")
        .child("${const Uuid().v1()}.png");
    // burada son child dosyanın adıymış! burada resmi yuklerken resme özel id verebilirsin.
    // sonra bu id yi kaydedip ürünler sayfasında çektiğinde alakalı resmi bulursun.
    // benden bu kadar

    // bu resimleri topalyacağın klasör olduğu için hedefin burası. son child bu olmalı

    try {
      await storageRef.putFile(_image!);
      debugPrint("ref: oldu!");
    } on firebase_core.FirebaseException {
      // deni bi
      debugPrint(
          "HATA"); // dosyayukle bunu çalıştırmadık ki boşta bekliyor!! yukleme butonun nerede
    }
  }

  final picker = ImagePicker();
//kullanıcı galerıden bır resım  sectiğinde bu işlev calısır
  Future getImage() async {
    // bu fonksiyon çalıştığında geri döndürdüğü resim kullanıcınn seçtiği resim. sen bunu ekrana yazdırıyorsun.
    // düzenlemen gereken onayla butonuyla keydetme işlemini gerçekleştirmek. ben test etmek için hızlıca ekledim sadece. textfieldi düzeltince eklersin onayla butonuna.
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      //eger bır resım secılmısse secılen resımı gostermek ııcn
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        dosyayukle();
        // denermisimn sorun su  text feıeldlerı dolduramadıgımız ıcın onaylayıp acaba
        if (widget.onPhotoSelected != null) {
          widget.onPhotoSelected!(_image!); // Callback fonksiyonunu çağır
        }
      } else {
        print('Görüntü seçilmedi.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: getImage,
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              // Özel çizim işlevini kullanarak kesik çizgili çerçeve oluştur
              painter: DottedBorderPainter(),
              child: _image == null
                  ? Center(
                      child: Text(
                        'Resim Seç',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(_image!, fit: BoxFit.cover),
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
      ..style = PaintingStyle.stroke //Stili çizgi olarak ayarla
      ..strokeCap = StrokeCap.round; // Çizgi uçlarını yuvarlak yap

    // Kesik çizgilerin uzunluğu ve aralığını belirle
    final dashWidth = 5;
    final dashSpace = 5;
    // Yatay kesik çizgileri çiz
    double startY = 0;
    while (startY < size.height) {
      // Her bir kesik çizgiyi çizmek için canvas.drawLine kullan
      canvas.drawLine(
        Offset(0, startY), // Çizginin başlangıç noktası (x=0, y=startY)
        Offset(
            0,
            startY +
                dashWidth), // Çizginin bitiş noktası (x=0, y=startY + dashWidth)
        paint,
      );
      // Bir sonraki kesik çizgi için başlangıç noktasını güncelle
      startY +=
          dashWidth + dashSpace; // Kesik çizgi uzunluğu ve aralığı kadar arttır
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

    double endY = size.height;
    while (endY > 0) {
      canvas.drawLine(
        Offset(size.width, endY),
        Offset(size.width, endY - dashWidth),
        paint,
      );
      endY -= dashWidth + dashSpace;
    }
    // Sağ alt köşeden yukarı doğru kesik çizgileri çiz
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

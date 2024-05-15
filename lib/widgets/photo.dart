
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPhoto extends StatefulWidget {
  @override
  _ProductPhotoState createState() => _ProductPhotoState();
}

class _ProductPhotoState extends State<ProductPhoto> {
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
          child: Container(
            width: 300,
            height: 300,
            child: CustomPaint(
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
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashWidth = 5;
    final dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
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

/*
burası yapılan ıslemler sayfası 
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/table_model.dart';
import 'package:flutter_application_1/widgets/small_button.dart';
import 'package:flutter_application_1/widgets/table.dart';
import 'package:flutter_application_1/wiew/overview.dart';

import '../widgets/container.dart';

class Todo extends StatefulWidget {
  const Todo({super.key}); // Yapılacaklar sayfası için stateful bir bileşen

  @override
  State<Todo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Özel AppBar bileşeni
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallButton(
                  text: "GÜNLÜK", // Günlük buton metni
                ),
                SmallButton(text: "HAFTALIK"), // Haftalık buton metni
                SmallButton(text: "AYLIK"), // Aylık buton metni
                SmallButton(text: "Yıllık"), // Yıllık buton metni
              ],
            ),
            Constants.sizedbox, // Sabit boyutlu bir boşluk bileşeni
            CustomContainer(), // Özel konteyner bileşeni
            Constants.sizedbox, // Sabit boyutlu bir boşluk bileşeni
            //
            // tablonun oldugu alan

            // MyTable(tableData: [
            //   TableDataModel(
            //     tarih: '13.05.2024 -14:20',
            //     urun: 'Beyaz opak kumas',
            //     urunAdet: "12",
            //     urunAlisFiyati: 'gider',
            //     urunSatisFIyati: 'nee',
            //     urunKarZararDurumu: 'urunKarZararDurumu',
            //     urunGider: '123',
            //     urunGelir: '123',zzz
            //   ),
            // ], tableValue: 2)
          ],
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
      title: const Text(
        "Yapılan İşlemler", // Başlık metni
        style: Constants
            .textStyle, // Sabit bir metin stili kullanarak başlık metni stilini belirtme
      ),
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey, // Gri renkli geri dönüş ikonu
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Overview())); // Genel bakış sayfasına geri dönüş işlemi
          }),
    );
  }
}

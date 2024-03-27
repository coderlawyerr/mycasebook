/*
tedarıkcı ve musterı ekleme sayfası
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/supplier_and_customer.dart';

class supplier_and_customeradd extends StatefulWidget {
  const supplier_and_customeradd(
      {super.key}); // Tedarikçi ve Müşteri eklemek için stateful bir bileşen

  @override
  State<supplier_and_customeradd> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<supplier_and_customeradd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Üst çubuk olarak kullanılacak özel AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.sizedbox,
              const CustomTextWidget(
                text: "Seç", // Seçim metni
              ),
              DropdownMenuExample(initialValue: 'Seç',), // Dropdown menü örneği
              Constants.sizedbox, // Sabit boyutlu bir boşluk
              /////////////
              const CustomTextWidget(
                text: "Telefon", // Telefon metni
              ),
              const CustomTextField(), // Özel metin giriş alanı
              Constants.sizedbox, // Sabit boyutlu bir boşluk
              ///////////
              const CustomTextWidget(
                text: "Adres", // Adres metni
              ),
              const CustomTextField(), // Özel metin giriş alanı
              Constants.sizedbox, // Sabit boyutlu bir boşluk

              const Center(
                child: CustomButton(
                  text: "ONAYLA", // Onayla metni
                  page:
                      supplier_and_customer(), // Tedarikçi ve Müşteri sayfasına geçişi sağlayan sayfa
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
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
                        const Overview())); // Genel bakış sayfasına geri dönüş işlemi
          }),
      title: const Text(
        " TEDARİKÇİ VE MÜŞTERİ EKLE ", // Başlık metni
        style:
            TextStyle(fontSize: 20, color: Colors.white), // Başlık metni stili
      ),
    );
  }
}

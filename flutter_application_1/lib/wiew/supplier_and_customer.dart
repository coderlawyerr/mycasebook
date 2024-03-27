/*
tedarıkcı ve musterı lıstesı burada  ve sılme ıslemı gerceklesıyo
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/search.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class supplier_and_customer extends StatefulWidget {
  const supplier_and_customer({super.key});

  @override
  State<supplier_and_customer> createState() => _ProductState();
}

class _ProductState extends State<supplier_and_customer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Özel AppBar bileşeni
      body: Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Search(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                child: const CustomCard(
                  text:
                      "Şahıs:Müşteri\nTel:115665\nAdres:sabahat sok.İzmir apt", // Kart içeriği metni
                ),
              ),
            ),
          ],
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
        "Tedarikçi Ve Müşteriler", // Başlık metni
        style: Constants
            .textStyle, // Sabit bir metin stili kullanarak başlık metni stilini belirtme
      ),
    );
  }
}

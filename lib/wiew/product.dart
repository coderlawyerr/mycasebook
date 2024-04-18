/*
 bu sayfa urunler sayfası yanı eklenen urunler ve bunu sılmek ıcın kırmızı çöp kutusu
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/search.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    // Ürün sayfasının yapılandırılması
    return Scaffold(
      appBar: _appbar(context), // Uygulama çubuğunun oluşturulması
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            const Search(
              searchType: SearchType.urun,
            ), //

            /// arama butonu
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                child: const CustomCard(
                  text:
                      "Ürün Adı: Beyaz Kumaş\nAlış Fiyat: 500TL\nSatış Fiyat: 20.000\nAdet: 450\nTarih:12.03.2024\nSaat:12:03", // Ürün bilgileri içeren metin
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Uygulama çubuğunun oluşturulması
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Arkaplan rengi şeffaf olsun
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey, // Sol üst köşede geri butonu, gri renkte olsun
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Overview())); // Geri butonuna basıldığında genel bakış sayfasına yönlendir
          }),
      title: const Text(
        "Ürünlerim", // Uygulama çubuğunda "Ürünler" başlığı
        style: Constants.textStyle, // Başlık stili belirtildi
      ),
    );
  }
}

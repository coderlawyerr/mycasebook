/*
bu sayfa genel bakıs sayfası
*/

import 'package:flutter/material.dart';

import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/listtile.dart';
import 'package:flutter_application_1/widgets/pie_chart.dart';
import 'package:flutter_application_1/wiew/add_product.dart';
import 'package:flutter_application_1/wiew/product.dart';
import 'package:flutter_application_1/wiew/sales.dart';
import 'package:flutter_application_1/wiew/suplier_and_customer_add.dart';
import 'package:flutter_application_1/wiew/supplier_and_customer.dart';
import 'package:flutter_application_1/wiew/things_todo.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    // Ana ekranın yapılandırılması
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Genel Bakış Sayfası", // Uygulama çubuğunda "Genel Bakış Sayfası" başlığı
          style: Constants.textStyle, // Başlık stilini belirt
        ),
      ),
      drawer: _drawerr(context), // Yan menüyü oluştur
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: MyPieChart(), // Pasta grafiğini ekle
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Yan menüyü oluştur
  Drawer _drawerr(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,

      backgroundColor: Colors.grey, // Menü arka plan rengi gri olsun
      child: Container(
        child: ListView(
          children: [
            // Kullanıcı bilgilerini göster
            CircleAvatar(
              radius: 50, // İstediğiniz bir boyut
              backgroundColor:
                  Colors.transparent, // Arka plan rengini şeffaf yapın

              child: Image.asset(
                "assets/prof.png",
                fit: BoxFit.cover, // Resmi doldurmak için BoxFit kullanın
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("BETÜL ŞENSOY"), // Kullanıcı adını göster
                Text(
                    "betulsensoy00@gmail.com"), // Kullanıcı e-posta adresini göster
                Divider(
                  color: Color.fromARGB(
                      255, 60, 60, 60), // Ayırıcı rengi gri olsun
                ),
              ],
            ),
            // Menü seçenekleri
            CustomListTile(
              title: "Ürün Ekle", // Menü öğesi: Ürün Ekle
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
            ),
            CustomListTile(
              title: "Ürünler", // Menü öğesi: Ürünler
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Product()),
                );
              },
            ),
            CustomListTile(
              title: "Yapılan İşlemler", // Menü öğesi: Yapılan İşlemler
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Todo()),
                );
              },
            ),
            CustomListTile(
              title:
                  "Tedarikçi Müşteri Ekle", // Menü öğesi: Tedarikçi Müşteri Ekle
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => supplier_and_customeradd()),
                );
              },
            ),
            CustomListTile(
              title:
                  "Tedarikçiler ve Müşteriler", // Menü öğesi: Tedarikçi Müşteri Sil
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => supplier_and_customer()),
                );
              },
            ),
            // CustomListTile(
            //   title: "Satış", // Menü öğesi: Satış
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Sales()),
            //     );
            //   },
            // ),

            CustomListTile(
              title: "Çıkış", // Menü öğesi: Çıkış
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

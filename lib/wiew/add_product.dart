/*
 bu sayda urunlerı ekleme sayfası
*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DataBaseService databaseService = DataBaseService();

  final TextEditingController productName = TextEditingController();
  final TextEditingController buyPrice = TextEditingController();
  final TextEditingController sellPrice = TextEditingController();
  final TextEditingController productAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Uygulama çubuğunu oluştur
    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.sizedbox,
                  // Ürün adı giriş alanı
                  CustomTextWidget(text: "Ürün Adı"),
                  // Ürün adı metin giriş alanı
                  customTextField(controller: productName),
                  // Boşluk
                  Constants.sizedbox,
                  ///////////////
                  // Ürün alış fiyatı giriş alanı
                  CustomTextWidget(text: "Ürün Alış Fiyatı"),
                  // Ürün alış fiyatı metin giriş alanı
                  customTextField(controller: buyPrice),
                  // Boşluk
                  Constants.sizedbox,

                  // Ürün satış fiyatı giriş alanı
                  CustomTextWidget(text: "Ürün Satış Fiyatı"),
                  // Ürün satış fiyatı metin giriş alanı
                  customTextField(controller: sellPrice),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  // Adet giriş alanı
                  CustomTextWidget(text: "Adet"),
                  // Adet metin giriş alanı
                  customTextField(controller: productAmount),
                  // Boşluk ekleyin
                  Constants.sizedbox,
                  Center(
                    child: CustomButton(
                      // Onayla butonu
                      text: "ONAYLA",
                      // Ürün sayfasına yönlendir

                      toDo: () {
                        if (productName.text.isNotEmpty &&
                            buyPrice.text.isNotEmpty &&
                            sellPrice.text.isNotEmpty &&
                            productAmount.text.isNotEmpty) {
                          ProductModel product = ProductModel();
                          product.buyPrice =
                              double.tryParse(buyPrice.text) ?? 0.0;
                          product.sellPrice =
                              double.tryParse(sellPrice.text) ?? 0.0;
                          product.productName = productName.text;
                          product.productAmount =
                              int.tryParse(productAmount.text) ?? 0;
                          databaseService
                              .addNewProduct(
                                  AuthService().getCurrentUser()!.uid, product)
                              .then((value) {
                            if (value != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Ürün Başarıyla  Eklendi")));
                            }
                          });
                        }
                        /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => Product(),
                              ));*/
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Uygulama çubuğunda "Ürün Ekle" başlığı
  // Başlık stilini belirt
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // Sol üst köşede geri butonu, gri renkte olsun
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          // Geri butonuna basıldığında önceki sayfaya yönlendir
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Overview()));
          }),
      title: const Text(
        "Ürün Ekle",
        style: Constants.textStyle,
      ),
    );
  }
}

/*
  Bu sayfa, kayıt olma işlemlerini içerir. Text alanları ve metin widget'ları özel widget'lar olarak tanımlanmıştır.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class Register extends StatelessWidget {
  const Register({Key? key});

  @override
  Widget build(BuildContext context) {
    // Kayıt sayfasının yapılandırılması
    return Scaffold(
      appBar: _appbar(context), // Uygulama çubuğunun oluşturulması
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ad-Soyad metin alanı
              const CustomTextWidget(text: " Ad-Soyad"),
              const CustomTextField(), // Ad-Soyad metin alanı
              Constants.sizedbox, // Sabit boşluk eklenmiş
              // Telefon numarası metin alanı
              const CustomTextWidget(text: "Telefon"),
              const CustomTextField(), // Telefon numarası metin alanı
              Constants.sizedbox, // Sabit boşluk eklenmiş
              // Şifre metin alanı
              const CustomTextWidget(text: "Şifre"),
              const CustomTextField(), // Şifre metin alanı
              Constants.sizedbox, // Sabit boşluk eklenmiş
              const SizedBox(
                height: 100,
              ), // Yükseklik için sabit bir değer eklenmiş
              Center(
                child: CustomButton(
                  text: "KAYDOL", // Buton metni: KAYDOL
                  page: LoginPage(), // Butona tıklandığında yönlendirilecek sayfa: Giriş Sayfası
                ),
              ),
            ],
          ),
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
                context, MaterialPageRoute(builder: (context) => LoginPage())); // Geri butonuna basıldığında giriş sayfasına yönlendir
          }),
      title: const Text(
        "Kayıt Ol", // Uygulama çubuğunda "Kayıt Ol" başlığı
        style: Constants.textStyle, // Başlık stili belirtildi
      ),
    );
  }
}

/*
bu sayfa urun sılme sayfası
*/
import 'package:flutter/material.dart';

import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/squre.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

// Şifremi unuttum işlemleri
class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 125,
            ),
            Center(child: CustomSquare()), // Özel Kareyi ortala
            const SizedBox(
              height: 100,
            ),
            const Text(
              "E-postanıza kod gönderildi", // Bilgi metni: E-postanıza kod gönderildi
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const Text(
              "Kodun Süresi Doluyor 5 sn", // Bilgi metni: Kodun Süresi Doluyor 5 sn
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                child: Center(
                  child: Text(
                    "DOĞRULAMA KODU TEKRAR GÖNDER", // Buton metni: DOĞRULAMA KODU TEKRAR GÖNDER
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                width: 254,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Uygulama çubuğunu oluştur
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
                        LoginPage())); // Geri butonuna basıldığında önceki sayfaya yönlendir
          }),
      title: const Text(
        "Parolanızı Mı  Unuttunuz", // Uygulama çubuğunda "Parolanızı Mı  Unuttunuz" başlığı
        style: Constants.textStyle, // Başlık stilini belirt
      ),
    );
  }
}

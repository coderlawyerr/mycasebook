/*
bu sayfa urun sılme sayfası
*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/const/const.dart';

class ForgotPassword extends StatelessWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 125,
            ),
            //Center(child: CustomSquare()), // Özel Kareyi ortala
            const SizedBox(
              height: 100,
            ),
            const Text(
              "E-postanıza kod gönderildi", // Bilgi metni: E-postanıza kod gönderildi
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            /*const Text(
              "Kodun Süresi Doluyor 5 sn", // Bilgi metni: Kodun Süresi Doluyor 5 sn
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),*/
            const SizedBox(
              height: 50,
            ),
            Center(
              child: GestureDetector(
                onTap: (){
                  ///sıfre sıfırlanıyo
                  AuthService()
                        .passwordReset(email);
                },
                child: Container(
                  width: 254,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: Text(
                      "DOĞRULAMA KODU TEKRAR GÖNDER", // Buton metni: DOĞRULAMA KODU TEKRAR GÖNDER
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
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
            Navigator.pop(context);
          }),
      title: const Text(
        "Parolanızı Mı  Unuttunuz", // Uygulama çubuğunda "Parolanızı Mı  Unuttunuz" başlığı
        style: Constants.textStyle, // Başlık stilini belirt
      ),
    );
  }
}

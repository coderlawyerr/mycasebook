/*
  Bu sayfa, kayıt olma işlemlerini içerir. Text alanları ve metin widget'ları özel widget'lar olarak tanımlanmıştır.
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class Register extends StatelessWidget {
  Register({super.key});

  AuthService authService = AuthService();
  DataBaseService databaseService = DataBaseService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adsoyadController = TextEditingController();
  final TextEditingController telNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Kayıt sayfasının yapılandırılması
    return Scaffold(
      appBar: _appbar(context), // Uygulama çubuğunun oluşturulması
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ad-Soyad metin alanı
                const CustomTextWidget(text: " Ad-Soyad"),
                customTextField(
                    controller: adsoyadController), // Ad-Soyad metin alanı
                Constants.sizedbox, // Sabit boşluk eklenmiş
                // Telefon numarası metin alanı
                const CustomTextWidget(text: "Telefon"),
                customTextField(
                    controller:
                        telNoController), // Telefon numarası metin alanı
                Constants.sizedbox, // Sabit boşluk eklenmiş
                // Şifre metin alanı
                const CustomTextWidget(text: "E-Posta"),
                customTextField(
                    controller: emailController), // Şifre metin alanı
                Constants.sizedbox, // Sabit boşluk eklenmiş
                ///
                const CustomTextWidget(text: "Şifre"),
                customTextField(
                    controller: passwordController), // Şifre metin alanı
                const SizedBox(
                  height: 100,
                ), // Yükseklik için sabit bir değer eklenmiş
                Center(
                  child: CustomButton(
                    text: "KAYDOL", // Buton metni: KAYDOL
                    toDo: () async {
                      if (adsoyadController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          telNoController.text.isNotEmpty) {
                        await authService
                            .signupWithEmail(
                                emailController.text, passwordController.text)
                            .then((userid) async {
                          if (userid != null) {
                            UserModel userdata = UserModel(userID: userid);
                            userdata.email = emailController.text;
                            userdata.telNo = int.tryParse(telNoController.text);
                            userdata.name = adsoyadController.text;
                            await databaseService.newUser(userdata.toMap());
                            authService.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      LoginPage(),
                                ));
                          }
                        });
                      }
                    }, // Butona tıklandığında yönlendirilecek sayfa: Giriş Sayfası
                  ),
                ),
              ],
            ),
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
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage())); // Geri butonuna basıldığında giriş sayfasına yönlendir
          }),
      title: const Text(
        "Kayıt Ol", // Uygulama çubuğunda "Kayıt Ol" başlığı
        style: Constants.textStyle, // Başlık stili belirtildi
      ),
    );
  }
}

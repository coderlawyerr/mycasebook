/*
  Bu sayfa, kullanıcıların kayıt olma işlemlerini yönetir. 
  Text alanları ve metin widget'ları özel widget'lar olarak tanımlanmıştır.
*/

// Flutter bileşenlerini içe aktarır
import 'package:flutter/material.dart';

// Servis ve model dosyalarını projeye dahil eder
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

// Kayıt sayfasını oluşturan sınıf
class Register extends StatelessWidget {
  Register({super.key}); // Register sınıfının yapıcı metodu

  // AuthService ve DataBaseService sınıflarından nesneler oluşturulur
  AuthService authService = AuthService();
  DataBaseService databaseService = DataBaseService();

  // Metin alanları için kontrolcüler
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adsoyadController = TextEditingController();
  final TextEditingController telNoController = TextEditingController();

  // Kayıt sayfasının yapılandırılması
  @override
  Widget build(BuildContext context) {
    // Scaffold bileşeni ile sayfa yapısı oluşturulur
    return Scaffold(
      // Uygulama çubuğunu belirleyen metot çağrılır
      appBar: _appbar(context),

      // Sayfanın ana içeriği
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28), // Kenar boşlukları belirlenir
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Yatayda sola yasla
              children: [
                // Ad-Soyad metin alanı ve giriş kutusu
                const CustomTextWidget(text: " Ad-Soyad"),
                customTextField(controller: adsoyadController),
                Constants.sizedbox,

                // Telefon numarası metin alanı ve giriş kutusu
                const CustomTextWidget(text: "Telefon"),
                customTextField(controller: telNoController),
                Constants.sizedbox,

                // E-Posta metin alanı ve giriş kutusu
                const CustomTextWidget(text: "E-Posta"),
                customTextField(controller: emailController),
                Constants.sizedbox,

                // Şifre metin alanı ve giriş kutusu
                const CustomTextWidget(text: "Şifre"),
                customTextField(controller: passwordController),
                const SizedBox(
                  height: 100,
                ),

                // Kayıt butonu
                Center(
                  child: CustomButton(
                    text: "KAYDOL",
                    toDo: () async {
                      if (adsoyadController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          telNoController.text.isNotEmpty) {
                        // Boş alan kontrolü yapılır, eğer tüm alanlar doluysa devam edilir
                        await authService
                            .signupWithEmail(
                                emailController.text, passwordController.text)
                            .then((userid) async {
                              
                          if (userid != null) {
                            // Kullanıcı kimliği (userID) alınır
                            UserModel userdata = UserModel(userID: userid);
                            // Kullanıcı kimliği (userID) alınır
                            userdata.email = emailController.text;
                            // Kullanıcı bilgileri UserModel'den bir haritaya dönüştürülür ve veritabanına eklenir
                            userdata.telNo = int.tryParse(telNoController.text);
                            userdata.name = adsoyadController.text;
                            await databaseService.newUser(userdata.toMap());
                            // Kullanıcı kaydı başarılı bir şekilde tamamlandıktan sonra oturumu kapatır
                            authService.signOut();
                            // Kullanıcı giriş sayfasına yönlendirilir
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      LoginPage(),
                                ));
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Uygulama çubuğunu oluşturan metod
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }),
      title: const Text(
        "Kayıt Ol",
        style: Constants.textStyle,
      ),
    );
  }
}

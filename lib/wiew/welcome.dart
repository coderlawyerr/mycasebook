/*
Bu sayfa hoş geldiniz kısmı, yani splash ekranından sonra gelen özel metin ve metin giriş alanlarını tanımlıyor. 
Navigator kısmı, kullanıcıyı başka bir sayfaya yönlendiriyor.
Sayfanın amacı: Kullanıcı girişi yapmak veya kayıt olmak için kullanılan bir sayfadır.
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/forgot_password.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/register.dart';

class LoginPage extends StatelessWidget {
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(), // Özel AppBar bileşeni
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "HOŞGELDİNİZ", // Hoş geldiniz metni
                    style: Constants
                        .textStyle, // Sabit bir metin stili kullanarak metin stilini belirtme
                  ),
                ),
                const SizedBox(height: 70),
                const CustomTextWidget(
                  text: "E-Posta", // E-posta metni
                ),
                customTextField(
                    controller:
                        emailController), // Özel metin giriş alanı bileşeni
                Constants.sizedbox, // Sabit boyutlu bir boşluk bileşeni
                const CustomTextWidget(
                  text: "Şifre", // Şifre metni
                ),
                customTextField(
                    controller:
                        passwordController), // Özel metin giriş alanı bileşeni
                GestureDetector(
                  onTap: () {
                    if (emailController.text.isNotEmpty) {
                      authService
                          .passwordReset(emailController.text)
                          .then((value) {
                        if (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword(
                                        email: emailController.text,
                                      )));
                        }
                      });
                    }
                    // Şifremi unuttum sayfasına yönlendirme
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Şifremi Unuttum", // Şifremi unuttum metni
                        style:
                            TextStyle(color: Colors.grey), // Metin rengi stili
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                //////////
                Center(
                    child: CustomButton(
                  text: "GİRİŞ YAP", // Giriş yap buton metni
                  // Kullanıcının giriş yapabilmesi için e-posta ve şifre giriş alanlarının dolu olup olmadığını kontrol eden asenkron bir işlev.
                  toDo: () async {
                    _formKey.currentState!.validate();
                    // Eğer e-posta ve şifre alanları doluysa devam et
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      // AuthService sınıfından signIn metodu kullanılarak kullanıcı girişi yapılır ve dönen kullanıcı kimliği (userid) alınır.
                      await authService
                          .signIn(emailController.text, passwordController.text)
                          .then((userid) {
                        // Eğer kullanıcı kimliği null değilse, yani giriş başarılı olduysa
                        if (userid != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Hoş geldiniz!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Yeni sayfaya geçiş için Navigator kullanılarak mevcut sayfa yerine Overview sayfası geçilir.
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Overview(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Giriş başarısız. Lütfen tekrar deneyin.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    } else
                      // Eğer e-posta veya şifre alanları boşsa, "Boş" mesajı konsola yazdırılır.
                      print("Boş");
                  },

                  // Genel bakış sayfasına yönlendirme
                )),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Gri renkli bir çizgi
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "veya", // Veya metni
                        style:
                            TextStyle(color: Colors.grey), // Metin rengi stili
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Gri renkli bir çizgi
                        height: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CustomButton(
                    text: "KAYDOL", // Kaydol buton metni

                    toDo: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Register(),
                          ));
                    }, // Kayıt sayfasına yönlendirme
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
    );
  }
}

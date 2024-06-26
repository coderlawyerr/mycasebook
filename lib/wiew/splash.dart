/*
burası splash ekran gırıs yapmadan oncekı  future delayed beklem suresını  ve sonra navigator pushla gıbundan sonra hangı sayfaya gıdecegımızı yazdım

*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/wiew/dashboard.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthService _authService = AuthService();
  late UserModel userdata;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      if (_authService.getCurrentUser() != null) {
        await DataBaseService()
            .findUserbyID(AuthService().getCurrentUser()!.uid)
            .then((data) {
          if (data != null) {
            userdata = UserModel(userID: AuthService().getCurrentUser()!.uid);
            userdata.parseMap(data);
          }
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Overview()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/ss.png"),
            ),
          ],
        ),
      ),
    );
  }
}

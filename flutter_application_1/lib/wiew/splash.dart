/*
burası splash ekran gırıs yapmadan oncekı  future delayed beklem suresını  ve sonra navigator pushla gıbundan sonra hangı sayfaya gıdecegımızı yazdım

*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

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

import 'package:flutter/material.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/sales.dart';
import 'package:flutter_application_1/wiew/welcome.dart';

import 'wiew/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(145, 7, 3, 48)),
      title: 'Flutter Demo',
      home: const Splash(),
    );
  }
}

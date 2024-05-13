import 'dart:math';

import 'package:flutter/material.dart';

class Constants {
  static const SizedBox sizedbox =
      SizedBox(height: 25); //textfield arası bosluk

  static const TextStyle textStyle =
      TextStyle(fontSize: 24, color: Colors.grey); //bu baslıkların rengı

  static const Color backgroundcolor = Colors.transparent; //arkapplanı
  static const Color mycontainer =
      Color.fromARGB(255, 162, 162, 234); //contaainer rengı
}

double heightSize(BuildContext context, double value) {
  value /= 100;
  return MediaQuery.of(context).size.height * value;
}

double widthSize(BuildContext context, double value) {
  value /= 100;
  return MediaQuery.of(context).size.width * value;
}

String dateFormat(DateTime date, {bool hoursIncluded = false}) {
  String yil = date.year.toString();
  String ay = date.month.toString();
  String gun = date.day.toString();
  String saat = date.hour.toString();
  String dakika = date.minute.toString();
  String saniye = date.second.toString();

  if (date.month < 10) ay = "0${date.month}";
  if (date.day < 10) gun = "0${date.day}";
  if (date.hour < 10) saat = "0${date.hour}";
  if (date.minute < 10) dakika = "0${date.minute}";
  if (date.second < 10) saniye = "0${date.second}";

  String vakit = "$saat:$dakika:$saniye";

  if (hoursIncluded) {
    return "$gun/$ay/$yil  -  $vakit";
  } else {
    return "$gun/$ay/$yil";
  }
}

class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 10;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}

Future showAreYouSureDialog(BuildContext context, {required String message}) {
  return showDialog(
      context: context,
      builder: (con) {
        return AlertDialog(
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Hayır")),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Evet"))
          ],
        );
      });
}

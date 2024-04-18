import 'package:flutter/material.dart';

class Constants {
  static const SizedBox sizedbox =
      SizedBox(height: 53); //textfield arası bosluk

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

String dateFormat(DateTime date,{bool hoursIncluded=false}) {
  var yil = date.year;
  var ay = date.month;
  var gun = date.day;
  var saat = "${date.hour}:${date.minute}:${date.second}";
  if(hoursIncluded) {
    return "$yil/$ay/$gun  -  $saat";
  } else {
    return "$yil/$ay/$gun";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/const/const.dart';

Widget customCard(
    {required String text,
    required BuildContext context,
    Function()? onDelete}) {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    height: heightSize(context, 20),
    width: widthSize(context, 90),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: widthSize(context, 10),
        ),
        Image.asset(
          "assets/edıt.png",
        ),
        GestureDetector(onTap: onDelete, child: Image.asset("assets/bin.png")),
      ],
    ),
  );
}

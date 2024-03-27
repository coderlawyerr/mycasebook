import 'package:flutter/material.dart';

class CustomTextFieldTwo extends StatelessWidget {
  const CustomTextFieldTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 41,
      decoration: const BoxDecoration(
        color:  Color(0xFF5D5353),
      ),
      child: const TextField(
          decoration: InputDecoration(border: InputBorder.none),
          style: TextStyle(color: Colors.white)),
    );
  }
}

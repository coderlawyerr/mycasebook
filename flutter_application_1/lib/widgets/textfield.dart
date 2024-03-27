import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 372,
      height: 42,
      decoration:const BoxDecoration(
        color: const Color(0xFF5D5353),

     
      ),
      child: const TextField(
          decoration: InputDecoration(border: InputBorder.none),
          style: TextStyle(color: Colors.white)),
    );
  }
}

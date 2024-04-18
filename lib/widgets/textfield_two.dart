import 'package:flutter/material.dart';

class TextTwo extends StatefulWidget {
  const TextTwo({super.key});

  @override
  State<TextTwo> createState() => _TextTwoState();
}

class _TextTwoState extends State<TextTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 41,
      decoration: const BoxDecoration(
        color: Color(0xFF5D5353),
      ),
      child: TextField(
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(color: Colors.white)),
    );
  }
}

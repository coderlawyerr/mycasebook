import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.right,
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
      ),
    );
  }
}

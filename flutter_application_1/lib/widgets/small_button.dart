import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;

  SmallButton({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 27,
      decoration: BoxDecoration(
        color: const Color(0xFFFED36A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;

  const CustomCard({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 161,
      width: 371,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 85,
          ),
          Image.asset(
            "assets/edıt.png",
          ),
          Image.asset("assets/bin.png"),
        ],
      ),
    );
  }
}

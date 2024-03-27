import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Widget page;

  const CustomButton({
    super.key,
    required this.text,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ));
      },
      child: Container(
        width: 274,
        height: 61,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 212, 164),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

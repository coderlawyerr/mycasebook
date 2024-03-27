import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSquare extends StatefulWidget {
  late String text;

  @override
  State<CustomSquare> createState() => _SquareState();
}

class _SquareState extends State<CustomSquare> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Text 1'in değeri değiştiğinde yapılacak işlemler
            },
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Text 2'nin değeri değiştiğinde yapılacak işlemler
            },
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.grey,
              filled: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Text 3'ün değeri değiştiğinde yapılacak işlemler
            },
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Text 4'ün değeri değiştiğinde yapılacak işlemler
            },
          ),
        ),
      ],
    );
  }
}

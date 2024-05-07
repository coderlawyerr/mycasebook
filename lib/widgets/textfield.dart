import 'package:flutter/material.dart';

Widget customTextField({TextEditingController? controller}) {
  return Container(
    width: 372,
    height: 42,
    decoration: const BoxDecoration(
      color: Color(0xFF5D5353),
    ),
    child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? " Boş bırakmayınız" : null,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(color: Colors.white)),
  );
}

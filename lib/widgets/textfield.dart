import 'package:flutter/material.dart';

Widget customTextField({TextEditingController? controller, String? hint}) {
  return Container(
    width: 372,
    height: 42,
    decoration: const BoxDecoration(
      color: Color(0xFF5D5353),
    ),
    child: TextFormField(
        controller: controller,
        enableSuggestions: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            hintStyle: const TextStyle(color: Colors.grey)),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) => value!.isEmpty ? " Boş bırakmayınız" : null,
        style: const TextStyle(color: Colors.white)),
  );
}

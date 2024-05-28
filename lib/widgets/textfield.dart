import 'package:flutter/material.dart';

Widget customTextField({TextEditingController? controller, String? hint}) {
  return Container(
    width: 372,
    height: 42,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      controller: controller,
      enableSuggestions: true,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        hintStyle: const TextStyle(color: Colors.grey),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: const TextStyle(color: Colors.white), // Hata mesajı stili
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (value) => value!.isEmpty ? "Boş bırakmayınız" : null,
      style: const TextStyle(color: Colors.grey),
    ),
  );
}

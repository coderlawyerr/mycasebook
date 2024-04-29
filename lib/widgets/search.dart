import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';

Widget searchBar(searchController, context, String hintText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            const SizedBox(
              width: 2,
            ),
            SizedBox(
              width: widthSize(context, 80),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        )),
  );
}

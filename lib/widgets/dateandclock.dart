
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';

class DATE extends StatelessWidget {
  final String text;
  final String imagepath;

  const DATE({super.key, required this.text, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            color: Constants.mycontainer,
            child: Image.asset(
              imagepath,
            ),
          ),
          Container(
            color: Colors.grey,
            width: 75,
            height: 40,
            child: Center(child: Text(text)),
          ),
        ],
      ),
    );
  }
}

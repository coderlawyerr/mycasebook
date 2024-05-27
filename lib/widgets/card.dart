import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';

Widget customCard({
  required String text,
  required BuildContext context,
  Function()? onDelete,
  Function()? onEdit,
  required String imageUrl,
}) {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    // height: heightSize(context, 20),
    width: widthSize(context, 90),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(
          imageUrl,
          width: widthSize(context, 20),
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: widthSize(context, 10),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Image.asset(
            "assets/edıt.png",
          ),
        ),
        GestureDetector(onTap: onDelete, child: Image.asset("assets/bin.png")),
      ],
    ),
  );
}

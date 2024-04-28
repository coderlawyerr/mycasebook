import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';

class Search extends StatefulWidget {
  final SearchType searchType;
  const Search({super.key, required this.searchType});

  @override
  State<Search> createState() => _SearchState();
}

enum SearchType { urun, tedarikci }

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: widget.searchType == SearchType.urun
                          ? "ÜRÜN ARA"
                          : "TEDARİKÇİ ARA",
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          )), 
    );
  }
}

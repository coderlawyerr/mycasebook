import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  final List<String> list = <String>[
    'Müşteri',
    'Tedarikçi',
    'Ürün',
    "kasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqdkasdjkasnkdlşwqdasdqd"
  ];
  final String initialValue;

  DropdownMenuExample({Key? key, required this.initialValue}) : super(key: key);

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = "${widget.initialValue} Seç";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: Color(0xFF5D5353),
      child: DropdownButton<String>(
        value: null,
        hint: Text(dropdownValue ?? ""),
        iconEnabledColor: Colors.white,
        isExpanded: true,
        dropdownColor: Color(0xFF5D5353),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Column(children: [
              Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(
                color: Colors.white,
                height: 1,
              ),
            ]),
          );
        }).toList(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

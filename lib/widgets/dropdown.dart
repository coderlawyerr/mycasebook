import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';

class DropdownMenuExample extends StatefulWidget {
  final List<String> list = <String>[
    'Müşteri',
    'Tedarikçi',
  ];
  final String initialValue;
  final Function(CurrentType) setter;

  DropdownMenuExample(
      {super.key, required this.initialValue, required this.setter});

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
      color: const Color(0xFF5D5353),
      child: DropdownButton<String>(
        value: null,
        hint: Text(dropdownValue ?? ""),
        iconEnabledColor: Colors.white,
        isExpanded: true,
        dropdownColor: const Color(0xFF5D5353),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.setter(newValue == widget.list[0]
                ? CurrentType.musteri
                : CurrentType.tedarikci);
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
              const Divider(
                color: Colors.white,
                height: 1,
              ),
            ]),
          );
        }).toList(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

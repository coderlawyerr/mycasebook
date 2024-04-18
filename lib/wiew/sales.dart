import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/table_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dateandclock.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/dataList.dart';

import 'package:flutter_application_1/widgets/textwidget.dart';
import 'overview.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  TextEditingController satisFiyatController = TextEditingController();

  TextEditingController urunAdetiController = TextEditingController();

  int toplamFiyat = 0;

  @override
  void initState() {
    // Satis fiyatı alanının değişikliklerini dinleyen listener
    satisFiyatController.addListener(() {
      //// Satış fiyatını al
      int? satis = int.tryParse(satisFiyatController.text);
      // Ürün adedini al
      int? adet = int.tryParse(urunAdetiController.text);
      setState(() {
        // Eğer her ikisi de null değilse, toplam fiyatı güncelle
        if (satis != null && adet != null) toplamFiyat = satis * adet;
      });
    });
    urunAdetiController.addListener(() {
      int? satis = int.tryParse(satisFiyatController.text);
      int? adet = int.tryParse(urunAdetiController.text);
      // Eğer her ikisi de null değilse, toplam fiyatı güncelle
      setState(() {
        if (satis != null && adet != null) toplamFiyat = satis * adet;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Text controller'ları temizle
    satisFiyatController.dispose();
    urunAdetiController.dispose();
    super.dispose();
  }

  List<TableDataModel> data = [
    TableDataModel(
      tarih: DateTime.now(),
      urun: 'BEYAZ KUMAŞ ',
      musteriAd: "zeynep kavak",
      urunAdet: 11,
      urunSatisFiyati: 150,
    ),
    TableDataModel(
      tarih: DateTime.now(),
      urun: 'siyah kadife parlak opak',
      musteriAd: "ahmet veli",
      urunAdet: 11,
      urunSatisFiyati: 150,
    ),
    TableDataModel(
      tarih: DateTime.now(),
      urun: 'ahşap masa ayağı',
      musteriAd: "hasan koca",
      urunAdet: 11,
      urunSatisFiyati: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                _buildDateTimeRow(),
                SizedBox(height: 8),
                _buildDropdownRow(),
                SizedBox(height: 8),
                _buildDataInputRow(),
                SizedBox(height: 8),
                CustomButton(
                  text: "KAYDET",
                  toDo: () {},
                ),
                SizedBox(height: 8),
              ] +

              ///datacard cagırıyoruz2. tablo gelsın dıye
              dataCardList(context, data, 2),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Overview()),
          );
        },
      ),
      title: const Text(
        "Satış",
        style: Constants.textStyle,
      ),
    );
  }

  // Tarih ve saat satırı oluşturuluyor
  Widget _buildDateTimeRow() {
    return const Row(
      children: [
        DATE(imagepath: "assets/clock.png", text: "13:20"),
        SizedBox(width: 15),
        DATE(imagepath: "assets/calendar.png", text: "1/2/2024"),
      ],
    );
  }

  ///dropdown menu satırını olusuturuyor
  Widget _buildDropdownRow() {
    return Container(
      child: Column(
        children: [
          _buildDropdownColumn("Müşteri Seç"),
          const SizedBox(height: 20),
          _buildDropdownColumn("Ürün Seç"),
        ],
      ),
    );
  }

//////dropdown sutunun olusturan wıdget
  Widget _buildDropdownColumn(String labelText) {
    String initialValue = '';
    switch (labelText) {
      case 'Tedarikçi Seç':
        initialValue = 'Tedarikçi';
        break;
      case 'Müşteri Seç':
        initialValue = 'Müşteri';
        break;
      case 'Ürün Seç':
        initialValue = 'Ürün';
        break;
      default:
        initialValue = 'Seç';
        break;
    }

    return Column(
      children: [
        CustomTextWidget(text: labelText),
        const SizedBox(height: 10),
        DropdownMenuExample(initialValue: initialValue),
      ],
    );
  }

////textler
  Widget _buildDataInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDataInputField("Satış Fiyatı", satisFiyatController),
        const SizedBox(width: 10),
        _buildDataInputField("Ürün Adedi", urunAdetiController),
        const SizedBox(width: 10),
        Container(
          child: Column(
            children: [
              const CustomTextWidget(text: "Toplam Tutar"),
              SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      toplamFiyat.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDataInputField(
      String labelText, TextEditingController controller) {
    return Container(
      child: Column(
        children: [
          CustomTextWidget(text: labelText),
          customTextFieldTwo(controller),
        ],
      ),
    );
  }

  Widget customTextFieldTwo(TextEditingController controller) {
    return Container(
      width: 116,
      height: 41,
      decoration: const BoxDecoration(
        color: Color(0xFF5D5353),
      ),
      child: TextField(
          controller: controller,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(color: Colors.white)),
    );
  }
}

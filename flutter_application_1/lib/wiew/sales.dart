// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/const/const.dart';
// import 'package:flutter_application_1/models/table_model.dart';
// import 'package:flutter_application_1/widgets/button.dart';
// import 'package:flutter_application_1/widgets/dateandclock.dart';
// import 'package:flutter_application_1/widgets/dropdown.dart';
// import 'package:flutter_application_1/widgets/table.dart';
// import 'package:flutter_application_1/widgets/table_two.dart';
// import 'package:flutter_application_1/widgets/textfieldtwo.dart';
// import 'package:flutter_application_1/widgets/textwidget.dart';
// import 'overview.dart';

// class Sales extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 25),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildDateTimeRow(),
//               Constants.sizedbox,
//               _buildDropdownRow(),
//               SizedBox(height: 35),
//               _buildDataInputRow(),
//               Constants.sizedbox,
//               _buildSaveButtonAndReport(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       leading: IconButton(
//         icon: Icon(
//           Icons.arrow_back_ios,
//           color: Colors.grey,
//         ),
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Overview()),
//           );
//         },
//       ),
//       title: Text(
//         "Satış",
//         style: Constants.textStyle,
//       ),
//     );
//   }

//   // Tarih ve saat satırı oluşturuluyor
//   Widget _buildDateTimeRow() {
//     return Row(
//       children: [
//         DATE(imagepath: "assets/clock.png", text: "13:20"),
//         SizedBox(width: 15),
//         DATE(imagepath: "assets/calendar.png", text: "1/2/2024"),
//       ],
//     );
//   }

//   ///dropdown menu satırını olusuturuyor
//   Widget _buildDropdownRow() {
//     return Container(
//       child: Column(
//         children: [
//           _buildDropdownColumn("Tedarikçi Seç"),
//           SizedBox(height: 20),
//           _buildDropdownColumn("Müşteri Seç"),
//           SizedBox(height: 20),
//           _buildDropdownColumn("Ürün Seç"),
//         ],
//       ),
//     );
//   }

// //////dropdown sutunun olusturan wıdget
//   Widget _buildDropdownColumn(String labelText) {
//     String initialValue = '';
//     switch (labelText) {
//       case 'Tedarikçi Seç':
//         initialValue = 'Tedarikçi';
//         break;
//       case 'Müşteri Seç':
//         initialValue = 'Müşteri';
//         break;
//       case 'Ürün Seç':
//         initialValue = 'Ürün';
//         break;
//       default:
//         initialValue = 'Seç';
//         break;
//     }

//     return Column(
//       children: [
//         CustomTextWidget(text: labelText),
//         SizedBox(height: 10),
//         DropdownMenuExample(initialValue: initialValue),
//       ],
//     );
//   }

// ////textler
//   Widget _buildDataInputRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _buildDataInputField("Satış Fiyatı"),
//         SizedBox(width: 10),
//         _buildDataInputField("Ürün Adedi"),
//         SizedBox(width: 10),
//         _buildDataInputField("Toplam Tutar"),
//       ],
//     );
//   }

//   Widget _buildDataInputField(String labelText) {
//     return Container(
//       child: Column(
//         children: [
//           CustomTextWidget(text: labelText),
//           CustomTextFieldTwo(),
//         ],
//       ),
//     );
//   }

//   //verı gırıs alanı
//   Widget _buildSaveButtonAndReport() {
//     return Container(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomButton(text: "KAYDET", page: Sales()),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 20),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   //   MyTabletwo(),

//                   MyTable(
//                     tableValue: 1,
//                     tableData: [
//                       TableDataModel(
//                           tarih: "13.04.2024 -  3:20",
//                           urun: 'BEYAZ KUMAŞ ',
//                           urunAdet: '11',
//                           urunAlisFiyati: '120',
//                           urunSatisFIyati: '150\$',
//                           urunKarZararDurumu: 'karda',
//                           urunSatisTutari: '123'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

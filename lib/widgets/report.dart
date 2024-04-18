/*
burası genel rapor sayfası


*/
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/const/const.dart';
// import 'package:flutter_application_1/widgets/table_two.dart';


// class Report extends StatefulWidget {
//   const Report({Key? key}) : super(key: key);

//   @override
//   State<Report> createState() => _ReportState();
// }

// class _ReportState extends State<Report> {
//   @override
//   Widget build(BuildContext context) {
//     // Rapor sayfasının yapılandırılması
//     return Scaffold(
//       // Uygulama çubuğunun oluşturulması
//       body:  Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 20),
//                 padding: const EdgeInsets.all(20),
//                 width: 350,
//                 height: 350,
//                 decoration: const BoxDecoration(
//                   color: Constants.mycontainer, // Arka plan rengi: mycontainer
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "RAPOR", // Tarih ve saat bilgisi
//                       style:
//                           TextStyle(color: Colors.black), // Metin rengi: siyah
//                     ),
//                     const SizedBox(height: 20),
//                     MyTabletwo(), // Özel tabloyu ekle
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//   // Uygulama çubuğunun oluşturulması
//   AppBar _appbar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent, // Arkaplan rengi: şeffaf
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios,
//           color: Colors.grey, // Sol üst köşede geri butonu, gri renkte
//         ),
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     const Overview()), // Geri butonuna basıldığında genel bakış sayfasına yönlendir
//           );
//         },
//       ),
//       title: const Text(
//         "RAPOR", // Uygulama çubuğunda "RAPOR" başlığı
//         style: Constants.textStyle, // Başlık stili belirtildi
//       ),
//     );
//   }
// }

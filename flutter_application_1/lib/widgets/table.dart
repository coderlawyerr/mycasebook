// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/table_model.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// class MyTable extends StatelessWidget {
//   MyTable({super.key, required this.tableData, required this.tableValue});

//   // verinin widgete gonderilmesi

// // tablodaki veriler
//   List<TableDataModel> tableData;
//   int tableValue;

//   // tablonun kolon basluklari
//   List<String> tabloKolonBasliklari = [];

//   List<GridColumn> _list = [];

//   @override
//   Widget build(BuildContext context) {
//     if (tableValue == 1) {
//       tabloKolonBasliklari = [
//         'Tarih',
//         'Ürün',
//         'Ürün Adeti',
//         'Alış',
//         'Satış',
//         'Kar Zarar Durumu',
//         'gider',
//         'gelir'
//       ];
//     } else {
//       tabloKolonBasliklari = [
//         'Tarih',
//         'Urun',
//         'Adet',
//         'İşlem tipi',
//         'Tutar',
//       ];
//     }
//     // gelen basliklari kolona donusturme
//     for (var element in tabloKolonBasliklari) {
//       _list.add(buildColumn(element));
//     }
//     return SfDataGrid(
//         source: ProductDataSource(data: tableData, tableValue: tableValue),
//         columns: _list);
//   }

//   GridColumn buildColumn(String name) {
//     return GridColumn(
//       width: 150,
//       columnName: name,
//       label: Container(
//         alignment: Alignment.center,
//         child: Text(
//           name,
//           style: _style(),
//         ),
//       ),
//     );
//   }

//   TextStyle _style() {
//     return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
//   }
// }

// //

// class ProductDataSource extends DataGridSource {
//   ProductDataSource(
//       {required List<TableDataModel> data, required this.tableValue}) {
//     if (tableValue == 1) {
//       _data = data
//           .map<DataGridRow>((e) => DataGridRow(cells: [
//                 DataGridCell<String>(columnName: 'Tarih-Saat', value: e.tarih),
//                 DataGridCell<String>(columnName: 'Ürün', value: e.urunAdet),
//                 DataGridCell<String>(
//                     columnName: 'Adet', value: e.urunAlisFiyati),
//                 DataGridCell<String>(
//                     columnName: 'Satış Fiyatı', value: e.urunSatisTutari),
//                 DataGridCell<String>(
//                     columnName: 'AlısFiyatı', value: e.urunSatisTutari),
//                 DataGridCell<String>(
//                     columnName: 'Kar Zarar Durumu',
//                     value: e.urunKarZararDurumu),
//               ]))
//           .toList();
//     } else if (tableValue == 2) {
//       _data = data
//           .map<DataGridRow>((e) => DataGridRow(cells: [
//                 DataGridCell<String>(columnName: 'Tarih', value: e.tarih),
//                 DataGridCell<String>(columnName: 'Ürün', value: e.urun),
//                 DataGridCell<String>(
//                     columnName: 'Ürün Adet', value: e.urunAdet),
//                 DataGridCell<String>(
//                     columnName: 'İşlem Tipi', value: e.urunAlisFiyati),
//                 DataGridCell<String>(
//                     columnName: 'Tutar', value: e.urunSatisTutari),
//               ]))
//           .toList();
//     }
//   }

//   List<DataGridRow> _data = [];
//   int tableValue;

//   @override
//   List<DataGridRow> get rows => _data;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//       return Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           dataGridCell.value.toString(),
//           style: TextStyle(color: Colors.white),
//         ),
//       );
//     }).toList());
//   }
// }

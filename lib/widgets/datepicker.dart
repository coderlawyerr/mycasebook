// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// class DatePickerApp extends StatelessWidget {
//   const DatePickerApp({Key? key, required this.onDateSelected})
//       : super(key: key);

//   final void Function(DateTime) onDateSelected;

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       localizationsDelegates: [
//         DefaultCupertinoLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('tr', ''), // Turkish locale
//       ],
//       theme: CupertinoThemeData(brightness: Brightness.light),
//       home: DatePickerExample(onDateSelected: onDateSelected),
//     );
//   }
// }

// class DatePickerExample extends StatefulWidget {
//   const DatePickerExample({Key? key, required this.onDateSelected})
//       : super(key: key);

//   final void Function(DateTime) onDateSelected;

//   @override
//   State<DatePickerExample> createState() => _DatePickerExampleState();
// }

// class _DatePickerExampleState extends State<DatePickerExample> {
//   DateTime date = DateTime(2016, 10, 26);
//   DateTime time = DateTime(2016, 5, 10, 22, 35);

//   void _showDialog(Widget child) {
//     showCupertinoModalPopup<void>(
//       context: context,
//       builder: (BuildContext context) => Container(
//         height: 216,
//         padding: const EdgeInsets.only(top: 6.0),
//         margin: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         color: CupertinoColors.systemBackground.resolveFrom(context),
//         child: SafeArea(
//           top: false,
//           child: child,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: DefaultTextStyle(
//         style: TextStyle(
//           color: CupertinoColors.label.resolveFrom(context),
//           fontSize: 22.0,
//         ),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(bottom: 20),
//               ),
//               _DatePickerItem(
//                 children: <Widget>[
//                   const Text(
//                     'Tarih Seçiniz',
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   CupertinoButton(
//                     onPressed: () => _showDialog(
//                       CupertinoDatePicker(
//                         initialDateTime: date,
//                         mode: CupertinoDatePickerMode.date,
//                         use24hFormat: true,
//                         showDayOfWeek: true,
//                         onDateTimeChanged: (DateTime newDate) {
//                           setState(() => date = newDate);
//                         },
//                       ),
//                     ),
//                     child: Text(
//                       '${_getFormattedDate(date)}',
//                       style: const TextStyle(fontSize: 22.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getFormattedDate(DateTime dateTime) {
//     final localizations = CupertinoLocalizations.of(context);
//     final year = localizations.datePickerYear(dateTime.year);
//     final month = localizations.datePickerMonth(dateTime.month);
//     final day = localizations.datePickerDayOfMonth(dateTime.day);
//     return '$day $month $year';
//   }
// }

// class _DatePickerItem extends StatelessWidget {
//   const _DatePickerItem({required this.children});

//   final List<Widget> children;

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: CupertinoColors.inactiveGray,
//             width: 0.0,
//           ),
//           bottom: BorderSide(
//             color: CupertinoColors.inactiveGray,
//             width: 0.0,
//           ),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: children,
//         ),
//       ),
//     );
//   }
// }

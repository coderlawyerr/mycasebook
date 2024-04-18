import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DATETODO extends StatefulWidget {
  final Function(DateTime start, DateTime end) datePickerNotifier;

  const DATETODO({super.key, required this.datePickerNotifier});

  @override
  State<DATETODO> createState() => _DATETODOState();
}

class _DATETODOState extends State<DATETODO> {
  String text = "--";

  final String imagepath = "assets/calendar.png";

  PickerDateRange? dateRange;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    dateRange = args.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Tarih Seçin'),
              content: SizedBox(
                  width: widthSize(context, 80),
                  height: heightSize(context, 50),
                  child: SfDateRangePicker(
                    initialSelectedDate: DateTime.now(),
                    view: DateRangePickerView.month,
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1),
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (dateRange != null &&
                        dateRange!.startDate != null &&
                        dateRange!.endDate != null) {
                      Navigator.of(context)
                          .pop([dateRange!.startDate, dateRange!.endDate]);
                    }
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        ).then((value) => setState(() {
              if (value != null) {
                List<DateTime?> dates = value as List<DateTime?>;
                text = "${dateFormat(dates[0]!)}\n${dateFormat(dates[1]!)}";
                widget.datePickerNotifier(dates[0]!, dates[1]!);
              }
            }));
      },
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
            width: 150,
            height: 40,
            child: Center(child: Text(text)),
          ),
        ],
      ),
    );
  }
}

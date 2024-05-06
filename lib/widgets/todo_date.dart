import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// DATETODO adında bir StatefulWidget sınıfı tanımlıyoruz.
class DATETODO extends StatefulWidget {
  final Function(DateTime start, DateTime end)
      datePickerNotifier; // Tarih seçim bildirimlerini almak için bir fonksiyon

  // DATETODO sınıfının yapıcı metodunu tanımlıyoruz
  const DATETODO({super.key, required this.datePickerNotifier});

  @override
  State<DATETODO> createState() =>
      _DATETODOState(); // DATETODO sınıfının durumunu oluşturmak için metot
}

// DATETODO durum sınıfını tanımlıyoruz.
class _DATETODOState extends State<DATETODO> {
  String text = "--"; // Tarih seçimi sonucunu göstermek için metin değişkeni

  final String imagepath = "assets/calendar.png"; // Takvim resminin dosya yolu

  PickerDateRange? dateRange; //Seçilen tarih aralığını saklamak için değişken
  // Tarih seçimi değiştiğinde çalışacak metot
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    dateRange = args.value; // Seçilen tarih aralığını güncelle
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
                    // Synchronize Fusion tarih seçici bileşeni
                    initialSelectedDate:
                        DateTime.now(), // Başlangıçta seçili olan tarih
                    view: DateRangePickerView.month, // Tarih seçici görünümü
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1),
                    onSelectionChanged:
                        _onSelectionChanged, // Tarih seçimi değiştiğinde tetiklenecek fonksiyon
                    selectionMode:
                        DateRangePickerSelectionMode.range, // Tarih seçici modu
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (dateRange != null && // Eğer tarih aralığı belirlenmişse
                        dateRange!.startDate !=
                            null && // ...bitiş tarihi belirlenmişse
                        dateRange!.endDate != null) {
                      Navigator.of(context).pop([
                        dateRange!.startDate,
                        dateRange!.endDate
                      ]); // ...pop() metoduyla bu dialogu kapat ve seçilen tarih aralığını iletişim halinde gönder
                    }
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        ).then((value) => setState(() {
              if (value != null) {
                //// Değerin boş olmadığı kontrol edilir
                List<DateTime?> dates = value
                    as List<DateTime?>; // Gelen değer listeye dönüştürülür
                // Seçilen tarih aralığını göstermek için metni güncelliyoruz
                text = "${dateFormat(dates[0]!)}\n${dateFormat(dates[1]!)}";
                // Ebeveyn bileşene seçilen tarih aralığını iletiyoruz
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

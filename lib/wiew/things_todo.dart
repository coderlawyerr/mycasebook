

import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/table_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dataList.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/widgets/todo_date.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class Todo extends StatefulWidget {
  const Todo({
    super.key,
  }); // Yapılacaklar sayfası için stateful bir bileşen

  @override
  State<Todo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Todo> {
  double toplamSatis = 0.0;
  double toplamAlis = 0.0;
  double bakiye = 10000.0;
  bool showCards = false;
  List<TableDataModel> data = [
    //modellerımızı çağırıyoruz
    TableDataModel(
      tarih: DateTime.now(),
      urun: 'BEYAZ KUMAŞ ',
      urunAdet: 25,
      islemTipi: IslemTipi.alis,
      urunAlisFiyati: 150,
      urunSatisFiyati: 200,
      urunKarZararDurumu: KarZarar.kar,
    ),
    TableDataModel(
      tarih: DateTime(2024, 5, 6),
      urun: 'BEYAZ KUMAŞ ',
      urunAdet: 50,
      islemTipi: IslemTipi.alis,
      urunAlisFiyati: 150,
      urunSatisFiyati: 200,
      urunKarZararDurumu: KarZarar.kar,
    ),
    TableDataModel(
      tarih: DateTime(2024, 4, 6),
      urun: 'kara kumaş',
      urunAdet: 15,
      islemTipi: IslemTipi.satis,
      urunAlisFiyati: 150,
      urunSatisFiyati: 200,
      urunKarZararDurumu: KarZarar.kar,
    ),
  ];
  List<TableDataModel> filteredData = [];

// Fonksiyon, başlangıç ve bitiş tarihleri alır.
  void datePickerNotifier(DateTime baslangic, DateTime bitis) {
    // Toplam alış ve satış miktarlarını sıfırla.
    toplamAlis = 0.0;
    toplamSatis = 0.0;

    // Filtrelenmiş veriyi temizle.
    filteredData.clear();

    // Kartları gösterme kapat.
    showCards = false;
    
    

    // Veri listesindeki her bir öğe için kontrol yap.
    for (TableDataModel eleman in data) {
      // Eğer öğenin tarihi, başlangıç ve bitiş tarihleri arasındaysa
      if (eleman.tarih!.millisecondsSinceEpoch >=
              baslangic.millisecondsSinceEpoch &&
          eleman.tarih!.millisecondsSinceEpoch <=
              bitis.millisecondsSinceEpoch) {
        // Filtrelenmiş veri listesine öğeyi ekle.
        filteredData.add(eleman);

        // Eğer öğe bir satış işlemi ise
        if (eleman.urunSatisFiyati != null &&
            eleman.islemTipi == IslemTipi.satis) {
          // Toplam satış miktarına öğenin kazancını ekle.
          toplamSatis += eleman.kazancHesapla();
        }

        // Eğer öğe bir alış işlemi ise
        if (eleman.urunAlisFiyati != null &&
            eleman.islemTipi == IslemTipi.alis) {
          // Toplam alış miktarına öğenin toplam tutarını ekle.
          toplamAlis += eleman.toplamTutar();
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Özel AppBar bileşeni
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
                  Row(
                    children: [
                      const Text(
                        "Tarih Aralığı Seç",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      DATETODO(
                        datePickerNotifier: datePickerNotifier,
                      ),
                    ],
                  ),
                  Constants.sizedbox,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const CustomTextWidget(
                              text: 'Toplam Satış',
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              toplamSatis.toString(),
                              style: Constants.textStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const CustomTextWidget(
                              text: 'Toplam Alış',
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              toplamAlis.toString(),
                              style: Constants.textStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const CustomTextWidget(
                              text: 'Bakiye',
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              bakiye.toString(),
                              style: Constants.textStyle,
                            ),
                          ],
                        ),
                      ]),
                  Constants.sizedbox,
                  CustomButton(
                      text: "Raporla",
                      toDo: () => setState(() {
                            showCards = true;
                          })),
                  const SizedBox(height: 8),
                ] +
                (showCards
                    ? dataCardList(context, filteredData, 1)
                    : []), // dataCardList fonksiyonunu doğru şekilde çağırın
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
      title: const Text(
        "Yapılan İşlemler", // Başlık metni
        style: Constants
            .textStyle, // Sabit bir metin stili kullanarak başlık metni stilini belirtme
      ),
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey, // Gri renkli geri dönüş ikonu
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Overview())); // Genel bakış sayfasına geri dönüş işlemi
          }),
    );
  }
}

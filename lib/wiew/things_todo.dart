import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dataList.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/widgets/todo_date.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class Todo extends StatefulWidget {
  const Todo({
    super.key,
  });

  @override
  State<Todo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Todo> {
  DataBaseService dataBaseService = DataBaseService();
  double toplamSatis = 0.0;
  double toplamAlis = 0.0;
  double bakiye = 0.0;
  bool showCards = false;
  List<ProcessModel> data = [];
  List<ProcessModel> filteredData = [];
  late UserModel userdata;

  @override
  void initState() {
    bringUserData();
    bringProcesses();
    super.initState();
  }

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
    for (ProcessModel eleman in data) {
      // Eğer öğenin tarihi, başlangıç ve bitiş tarihleri arasındaysa
      if (eleman.date.millisecondsSinceEpoch >=
              baslangic.millisecondsSinceEpoch &&
          eleman.date.millisecondsSinceEpoch <= bitis.millisecondsSinceEpoch) {
        // Filtrelenmiş veri listesine öğeyi ekle.
        filteredData.add(eleman);

        // Eğer öğe bir satış işlemi ise
        if (eleman.processType == IslemTipi.satis) {
          // Toplam satış miktarına öğenin kazancını ekle.
          toplamSatis += eleman.gelirHesapla();
        }

        // Eğer öğe bir alış işlemi ise
        if (eleman.processType == IslemTipi.alis) {
          // Toplam alış miktarına öğenin toplam tutarını ekle.
          toplamAlis += eleman.giderHesapla();
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
                (showCards ? dataCardList(context, filteredData, 1) : []),
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

  Future<void> bringProcesses() async {
    data = await dataBaseService
        .fetchAllProcess(userID: AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {}));
  }

  Future<void> bringUserData() async {
    var d =
        await dataBaseService.findUserbyID(AuthService().getCurrentUser()!.uid);
    if (d != null) {
      userdata = UserModel(userID: AuthService().getCurrentUser()!.uid);
      userdata.parseMap(d);
      setState(() {
        bakiye = userdata.bakiye;
      });
    }
  }
}

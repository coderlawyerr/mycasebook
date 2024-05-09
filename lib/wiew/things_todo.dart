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
  // Veritabanı hizmeti nesnesi oluşturulur.
  DataBaseService dataBaseService = DataBaseService();

  // Toplam satış, alış ve bakiye miktarları saklanır.
  double toplamSatis = 0.0;
  double toplamAlis = 0.0;
  double bakiye = 0.0;

  // Kartları gösterme durumu kontrolü için bayrak.
  bool showCards = false;

  // Tüm işlemlerin orijinal ve filtrelenmiş listeleri oluşturulur.
  List<ProcessModel> data = [];
  List<ProcessModel> filteredData = [];

  // Kullanıcı verileri saklanır.
  late UserModel userdata;

  @override
  void initState() {
    // Kullanıcı verilerini ve işlemleri getiren fonksiyonlar çağrılır.
    bringUserData();
    // Tüm işlemleri getiren asenkron fonksiyon.
    bringProcesses();
    super.initState();
  }

  // Tarih seçici tarafından bildirilen tarih aralığına göre işlemleri filtreleyen fonksiyon.
  void datePickerNotifier(DateTime baslangic, DateTime bitis) {
    // Toplam satış ve alış miktarlarını sıfırla.
    toplamAlis = 0.0;
    toplamSatis = 0.0;

    // Filtrelenmiş veri listesini temizle.
    filteredData.clear();

    // Kartları gizle.
    showCards = false;

    // Tüm işlemleri kontrol et.
    for (ProcessModel eleman in data) {
      // İşlemin tarihi, belirlenen tarih aralığında ise
      if (eleman.date.millisecondsSinceEpoch >=
              baslangic.millisecondsSinceEpoch &&
          eleman.date.millisecondsSinceEpoch <= bitis.millisecondsSinceEpoch) {
        // Filtrelenmiş veri listesine ekle.
        filteredData.add(eleman);

        // Eğer işlem satış ise
        if (eleman.processType == IslemTipi.satis) {
          // Toplam satış miktarına ekle.
          toplamSatis += eleman.gelirHesapla();
        }

        // Eğer işlem alış ise
        if (eleman.processType == IslemTipi.alis) {
          // Toplam alış miktarına ekle.
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
                      // Tarih seçici bileşeni ve metin alanı oluşturulur.
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
                  // Toplam satış, alış ve bakiye miktarlarını gösteren sütunlar oluşturulur.
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
                  // "Raporla" butonu oluşturulur.
                  CustomButton(
                      text: "Raporla",
                      toDo: () => setState(() {
                            showCards = true;
                          })),
                  const SizedBox(height: 8),
                ] +
                // Kartların gösterilmesi için koşul eklenir.
                (showCards ? dataCardList(context, filteredData, 1) : []),
          ),
        ),
      ),
    );
  }

  // Özel AppBar bileşeni oluşturulur.
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
            // Genel bakış sayfasına geri dönüş işlemi
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Overview()));
          }),
    );
  }

  // Tüm işlemleri getiren asenkron fonksiyon.
  Future<void> bringProcesses() async {
    data = await dataBaseService
        .fetchAllProcess(userID: AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {}));
  }

  // Kullanıcı verilerini getiren asenkron fonksiyon.
  Future<void> bringUserData() async {
    var d =
        await dataBaseService.findUserbyID(AuthService().getCurrentUser()!.uid);
    if (d != null) {
      // Kullanıcı modeli oluşturulur ve verileri atanır.
      userdata = UserModel(userID: AuthService().getCurrentUser()!.uid);
      userdata.parseMap(d);
      // Bakiye güncellenir ve state yenilenir.
      setState(() {
        bakiye = userdata.bakiye;
      });
    }
  }
}

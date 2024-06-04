// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/models/userModel.dart';

import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dataList.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/widgets/todo_date.dart';
import 'package:flutter_application_1/widgets/todobuttonpdf.dart';
import 'package:flutter_application_1/wiew/dashboard.dart';

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

  // Kartları gösterme durumu kontrolü için
  bool showCards = false;

  // Tüm işlemlerin orijinal ve filtrelenmiş listeleri oluşturulur.
  List<ProcessModel> data = [];
  List<ProcessModel> filteredData = [];

  // Kullanıcı verileri saklanır.
  late UserModel userdata;

  // Müşteri dropdown seçimi için
  //SuplierCustomerModel? selectedCustomer;
  double satisFiyati = 0.0; // Satış fiyatı
  List<SuplierCustomerModel> customers = [];
  SuplierCustomerModel? selectedCustomer; // Seçili müşteri
  DateTime? tarih = DateTime.now(); // Tarih
  int maxUrunAdeti =
      2147483647; // Flutter'da en büyük int değeri // Maksimum ürün adeti
  List<ProductModel> products = []; // Ürünler listesi

  ProductModel? selectedProduct; // Seçili ürün

  List<ProcessModel> soldProcessList = []; // Satılan işlemlerin listesi
  double toplamFiyat = 0.0; // Toplam fiyat

  @override
  void initState() {
    // Kullanıcı verilerini ve işlemleri getiren fonksiyonlar çağrılır.
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

    setState(() {
      bakiye = toplamSatis - toplamAlis;
    });
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
                  // Yeni widget için alan eklenir.
                  _buildDropdownRow(),
                  // Toplam satış, alış ve bakiye miktarlarını gösteren sütunlar oluşturulur.
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const CustomTextWidget(
                            text: 'Toplam Satış Fiyatı',
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
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          const CustomTextWidget(
                            text: 'Toplam Alış Fiyatı',
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
                      SizedBox(
                        height: 15,
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
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // "Raporla" butonu oluşturulur.
                  CustomButton(
                    text: "Raporla",
                    toDo: () => setState(() {
                      showCards = true;
                    }),
                  ),
                  SizedBox(height: 8),
                  Todobuttonpdf(text: "PDF OLUŞTUR", data: data.firstOrNull),
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Overview()));
        },
      ),
    );
  }

  // Yeni dropdown widgetları ekleme
  Widget _buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          customersDropDown(), // Müşteri dropdown bileşeni
          const SizedBox(height: 20),
          productsDropDown(), // Ürün dropdown bileşeni
        ],
      ),
    );
  }

  // Müşteri dropdown bileşeni
  Widget customersDropDown() {
    return DropdownButtonFormField<SuplierCustomerModel>(
      value: selectedCustomer,
      style: const TextStyle(color: Colors.black), // Metin rengini siyah yap
      hint: const Text(
        "Müşteri Seç", // Varsayılan metin
        style: TextStyle(color: Colors.grey),
      ),
      isExpanded: true,
      dropdownColor: const Color(0xFF5D5353),
      validator: (value) => value == null ? "Müşteri Seçiniz!" : null,
      autovalidateMode: AutovalidateMode.always,
      items: customers.isEmpty
          ? null
          : customers
              .map((e) => DropdownMenuItem<SuplierCustomerModel>(
                  value: e, child: Text(e.username)))
              .toList(),
      onChanged: (selected) {
        setState(() {
          selectedCustomer = selected;
        });
      },
      decoration: const InputDecoration(
        errorStyle:
            TextStyle(color: Colors.white), // Validator metni için siyah renk
        errorBorder: OutlineInputBorder(
          // Hata durumunda çerçeve rengi
          borderSide: BorderSide(color: Colors.white), // Şeffaf bir çizgi
        ),
      ),
    );
  }

  // Ürün dropdown bileşeni
  Widget productsDropDown() {
    return DropdownButtonFormField<ProductModel>(
      value: selectedProduct,
      style: const TextStyle(color: Colors.black), // Metin rengini siyah yap
      hint: Text(
        products.isEmpty ? "Ürün Yok!" : "Ürün Seç", // Varsayılan metin
        style: const TextStyle(color: Colors.grey),
      ),
      validator: (value) => value == null ? "Ürün Seçiniz!" : null,
      autovalidateMode: AutovalidateMode.always,
      items: products.isEmpty
          ? null
          : products
              .map((e) => DropdownMenuItem<ProductModel>(
                  value: e, child: Text(e.productName)))
              .toList(),
      onChanged: (selected) {
        setState(() {
          selectedProduct = selected;
          satisFiyati = selected!.sellPrice;
          //urunAdetiController.text = "1";
          maxUrunAdeti = selected.productAmount;
        });
      },
      decoration: const InputDecoration(
        errorStyle:
            TextStyle(color: Colors.white), // Validator metni için siyah renk
        errorBorder: OutlineInputBorder(
          // Hata durumunda çerçeve rengi
          borderSide: BorderSide(color: Colors.white), // Şeffaf bir çizgi
        ),
      ),
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

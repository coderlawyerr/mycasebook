import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart'; // Yetkilendirme servisi
import 'package:flutter_application_1/Services/databaseService.dart'; // Veritabanı servisi
import 'package:flutter_application_1/const/const.dart'; // Sabitler dosyası
import 'package:flutter_application_1/models/process_model.dart'; // İşlem modeli
import 'package:flutter_application_1/models/product_model.dart'; // Ürün modeli
import 'package:flutter_application_1/models/supliercustomer_model.dart'; // Tedarikçi/Müşteri modeli
import 'package:flutter_application_1/widgets/button.dart'; // Özel düğme bileşeni
import 'package:flutter_application_1/widgets/dateandclock.dart'; // Tarih ve saat göstergesi bileşeni
import 'package:flutter_application_1/widgets/dataList.dart'; // Veri listesi bileşeni
import 'package:flutter_application_1/widgets/salesbuttonpdf.dart';
import 'package:flutter_application_1/widgets/textwidget.dart'; // Özel metin bileşeni
import 'package:omni_datetime_picker/omni_datetime_picker.dart'; // Tarih/saat seçici
import 'dashboard.dart'; // Genel bakış sayfası

// Satış işlemlerinin yapıldığı bileşen
class Sales extends StatefulWidget {
  const Sales({super.key});
  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  // Değişkenlerin tanımlanması
  double satisFiyati = 0.0; // Satış fiyatı
  final _formkey = GlobalKey<FormState>(); // Form anahtarı
  TextEditingController urunAdetiController =
      TextEditingController(); // Ürün adeti kontrolcüsü
  int maxUrunAdeti =
      2147483647; // Flutter'da en büyük int değeri // Maksimum ürün adeti
  DateTime? tarih = DateTime.now(); // Tarih
  List<SuplierCustomerModel> customers = []; // Müşteriler listesi
  List<ProductModel> products = []; // Ürünler listesi
  SuplierCustomerModel? selectedCustomer; // Seçili müşteri
  ProductModel? selectedProduct; // Seçili ürün
  DataBaseService dataBaseService = DataBaseService(); // Veritabanı servisi
  List<ProcessModel> soldProcessList = []; // Satılan işlemlerin listesi
  double toplamFiyat = 0.0; // Toplam fiyat
  @override
  void initState() {
    // İlk durum ayarı
    bringCustomers(); // Müşterileri getir
    bringProducts(); // Ürünleri getir
    bringSoldProcesses(); // Satılan işlemleri getir
    // Ürün adeti kontrolcüsü dinleniyor
    urunAdetiController.addListener(() {
      // Giriş alanından alınan değer double türüne çeviriliyor
      double? adet = double.tryParse(urunAdetiController.text.trim());
      setState(() {
        // 'toplamFiyat', satış fiyatı ile adet çarpılarak hesaplanır ve 'toplamFiyat' değişkenine atanır.
        if (adet != null) {
          toplamFiyat = satisFiyati * adet;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // Kontrolcülerin temizlenmesi
    urunAdetiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                  _buildDateTimeRow(), // Tarih ve saat satırı
                  const SizedBox(height: 10),
                  _buildDropdownRow(), // Dropdown satırı
                  const SizedBox(height: 15),
                  _buildDataInputRow(), // Veri girişi satırı
                  const SizedBox(height: 15),
                  CustomButton(
                      text: "KAYDET", // Düğme metni
                      toDo: () async {
                        // Seçilen müşteri, ürün, ürün adedi ve tarih kontrol edilir
                        if (selectedCustomer != null &&
                            selectedProduct != null &&
                            urunAdetiController.text.isNotEmpty &&
                            int.parse(urunAdetiController.text) <=
                                maxUrunAdeti &&
                            tarih != null) {
                          // Yeni bir işlem oluşturuluyor
                          var temp = selectedProduct!.toMap();
                          ProcessModel processModel = ProcessModel.predefined(
                              product: ProductModel().parseMap(
                                  temp), // Seçilen ürünün bilgileri işleme eklenir
                              date: tarih!, // Seçilen tarih işleme eklenir,
                              customerName: selectedCustomer!
                                  .username, // Müşteri adı işleme eklenir
                              processType: IslemTipi
                                  .satis); // İşlem tipi "satış" olarak belirlenir
                          // Satış fiyatı ve ürün adedi ekleniyor
                          processModel.product.productAmount =
                              int.tryParse(urunAdetiController.text) ?? 0;
                          // Veritabanı hizmeti üzerinden satış işlemi oluşturuluyor
                          await dataBaseService
                              .createSaleProcess(
                                  userId: AuthService().getCurrentUser()!.uid,
                                  processModel: processModel)
                              .then((value) {
                            // Ekleme başarılıysa bilgilendirme gösteriliyor
                            if (value != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Satış Başarıyla  Eklendi")));
                              // Alanlar temizleniyor ve satılan işlemler yeniden getiriliyor
                              setState(() {
                                selectedCustomer = null;
                                selectedProduct = null;
                                urunAdetiController.text = "0";
                                toplamFiyat = 0;
                                satisFiyati = 0.0;
                                tarih = DateTime.now();
                                bringSoldProcesses();
                                bringProducts();
                              });
                            }
                          });
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Salesbuttonpdf(
                    text: "PDF OLUSTUR",
                    product: soldProcessList.firstOrNull,
                  ),
                  const SizedBox(height: 8),
                ] +
                // Satılan işlemlerin listesi oluşturuluyor
                dataCardList(context, soldProcessList, 2),
          ),
        ),
      ),
    );
  }

  // Üst çubuk bileşeni
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Overview()),
          );
        },
      ),
      title: const Text(
        "Satış", // Başlık metni
        style: Constants.textStyle,
      ),
    );
  }

  // Tarih ve saat satırı bileşeni
  Widget _buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 15),
        Container(
            width: 40,
            height: 40,
            color: Constants.mycontainer,
            child: IconButton(
                onPressed: () async {
                  // Tarih seçimi yapılıyor
                  tarih = await showOmniDateTimePicker(
                          context: context, is24HourMode: true)
                      .then((value) {
                    if (value == null) return DateTime.now();
                    return value;
                  });
                  setState(() {});
                },
                icon: const Icon(Icons.date_range))),
        const Spacer(),
        DATE(
            imagepath: "assets/clock.png",
            text: "${tarih!.hour}:${tarih!.minute}"),
        const SizedBox(width: 15),
        DATE(
            imagepath: "assets/calendar.png",
            text: "${tarih!.day}/${tarih!.month}/${tarih!.year}"),
        const SizedBox(width: 15),
      ],
    );
  }

  ///dropdown menü satırını oluşturuyor
  Widget _buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          customersDropDown(), // Müşteri dropdown bileşeni
          const SizedBox(height: 20),
          productsDropDown() // Ürün dropdown bileşeni
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
        style: TextStyle(color: Colors.white),
      ),
      isExpanded: true,
      dropdownColor: Color.fromARGB(255, 255, 255, 255),
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

  // Veri giriş satırı bileşeni
  Widget _buildDataInputRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            // Satış fiyatı ve ürün adeti giriş alanları
            const CustomTextWidget(text: "Satış Fiyatı"),
            SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    satisFiyati.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
        const SizedBox(width: 10),
        _buildDataInputField(
            "Ürün Adedi", urunAdetiController), // Ürün adeti giriş alanı
        const SizedBox(width: 15),
        // Toplam tutar gösteriliyor
        Column(
          children: [
            // Satış fiyatı ve ürün adeti giriş alanları
            const CustomTextWidget(text: "Toplam Tutar"),
            SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    toplamFiyat.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
          ],
        )
      ],
    );
  }

  // Veri giriş alanı bileşeni
  Widget _buildDataInputField(
      String labelText, TextEditingController controller) {
    return Column(
      children: [
        CustomTextWidget(text: labelText),
        customTextFieldTwo(controller),
      ],
    );
  }

  Widget customTextFieldTwo(TextEditingController controller) {
    return Container(
      width: widthSize(context, 90),
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLines: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          errorStyle:
              TextStyle(color: Colors.black), // Validator metni için siyah renk
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Şeffaf bir çizgi
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Ürün Adedi giriniz!";
          } else if (int.parse(value) > maxUrunAdeti) {
            return "Ürün adedi en fazla $maxUrunAdeti kadar olabilir";
          } else {
            return null;
          }
        },
        onChanged: (value) {
          _formkey.currentState!.validate();
        },
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Müşteri verilerini getir
  Future<void> bringCustomers() async {
    customers = await dataBaseService
        .fetchCustomerAndSuppliers(AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {}));
  }

  // Ürün verilerini getir
  Future<void> bringProducts() async {
    products = await dataBaseService
        .fetchProducts(AuthService().getCurrentUser()!.uid)
        .then((val) {
      if (val.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Satılabilecek Ürün kalmadı!")));
      }
      return val;
    }).whenComplete(() => setState(() {}));
  }

  // Satılan işlemleri getir
  Future<void> bringSoldProcesses() async {
    soldProcessList = await dataBaseService
        .fetchProcess(
            userID: AuthService().getCurrentUser()!.uid, tip: IslemTipi.satis)
        .then((processes) => processes.reversed.toList())
        .whenComplete(() => setState(() {}));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dateandclock.dart';
import 'package:flutter_application_1/widgets/dataList.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'overview.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  TextEditingController satisFiyatController = TextEditingController();

  TextEditingController urunAdetiController = TextEditingController();

  DateTime? tarih = DateTime.now();
  List<SuplierCustomerModel> customers = [];
  List<ProductModel> products = [];
  SuplierCustomerModel? selectedCustomer;
  ProductModel? selectedProduct;
  DataBaseService dataBaseService = DataBaseService();
  List<ProcessModel> soldProcessList = [];

  int toplamFiyat = 0;

  @override
  void initState() {
    // Satis fiyatı alanının değişikliklerini dinleyen listener
    bringCustomers();
    bringProducts();
    bringSoldProcesses();
    satisFiyatController.addListener(() {
      //// Satış fiyatını al
      int? satis = int.tryParse(satisFiyatController.text);
      // Ürün adedini al
      int? adet = int.tryParse(urunAdetiController.text);
      setState(() {
        // Eğer her ikisi de null değilse, toplam fiyatı güncelle
        if (satis != null && adet != null) toplamFiyat = satis * adet;
      });
    });
    urunAdetiController.addListener(() {
      int? satis = int.tryParse(satisFiyatController.text);
      int? adet = int.tryParse(urunAdetiController.text);
      // Eğer her ikisi de null değilse, toplam fiyatı güncelle
      setState(() {
        if (satis != null && adet != null) toplamFiyat = satis * adet;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Text controller'ları temizle
    satisFiyatController.dispose();
    urunAdetiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                _buildDateTimeRow(),
                const SizedBox(height: 8),
                _buildDropdownRow(),
                const SizedBox(height: 8),
                _buildDataInputRow(),
                const SizedBox(height: 8),
                CustomButton(
                  text: "KAYDET",
                  toDo: () async {
                    if (selectedCustomer != null &&
                        selectedProduct != null &&
                        satisFiyatController.text.isNotEmpty &&
                        urunAdetiController.text.isNotEmpty &&
                        tarih != null) {
                           // Yeni bir işlem modeli oluşturuluyor
                      ProcessModel processModel = ProcessModel.predefined(
                          product: selectedProduct!,
                          date: tarih!,
                          customerName: selectedCustomer!.username,
                          processType: IslemTipi.satis);
                     // Satış fiyatı ve ürün adedi ekleniyor
                      processModel.product.sellPrice =
                          double.tryParse(satisFiyatController.text) ?? 0;
                      processModel.product.productAmount =
                          int.tryParse(urunAdetiController.text) ?? 0;

                      await dataBaseService
                          .createSaleProcess(
                              userId: AuthService().getCurrentUser()!.uid,
                              processModel: processModel)
                          .then((value) {
                            // Ekleme başarılıysa bilgilendirme gösteriliyor
                        if (value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Satış Başarıyla  Eklendi")));
                         // Alanlar temizleniyor ve satılan işlemler yeniden getiriliyor
                          setState(() {
                            selectedCustomer = null;
                            selectedProduct = null;
                            satisFiyatController.text = "";
                            urunAdetiController.text = "";
                            toplamFiyat = 0;
                            tarih = DateTime.now();
                            bringSoldProcesses();
                          });
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
              ] +

             // Satılan işlemlerin listesi oluşturuluyor

              dataCardList(context, soldProcessList, 2),
        ),
      ),
    );
  }

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
        "Satış",
        style: Constants.textStyle,
      ),
    );
  }

  // Tarih ve saat satırı oluşturuluyor
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

  ///dropdown menu satırını olusuturuyor
  Widget _buildDropdownRow() {
    return Column(
      children: [
        customersDropDown(),
        const SizedBox(height: 20),
        productsDropDown()
      ],
    );
  }

  DropdownButton<SuplierCustomerModel> customersDropDown() {
    return DropdownButton<SuplierCustomerModel>(
        value: selectedCustomer,
        style: Constants.textStyle,
        //dropdownColor: Colors.red,
        // isExpanded: true,
        hint: const Text(
          "Müşteri Seç",
          style: TextStyle(color: Colors.grey),
        ),
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
        });
  }
 // Ürün dropdown bileşeni oluşturuluyor
  DropdownButton<ProductModel> productsDropDown() {
    return DropdownButton<ProductModel>(
        value: selectedProduct,
        style: Constants.textStyle,
        //dropdownColor: Colors.red,
        // isExpanded: true,
        hint: const Text(
          "Ürün Seç",
          style: TextStyle(color: Colors.grey),
        ),
        items: products.isEmpty
            ? null
            : products
                .map((e) => DropdownMenuItem<ProductModel>(
                    value: e, child: Text(e.productName)))
                .toList(),
        onChanged: (selected) {
          setState(() {
            selectedProduct = selected;
          });
        });
  }
 // Veri giriş satırı oluşturuluyor
  Widget _buildDataInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDataInputField("Satış Fiyatı", satisFiyatController),
        const SizedBox(width: 10),
        _buildDataInputField("Ürün Adedi", urunAdetiController),
        const SizedBox(width: 10),
        // Toplam tutar gösteriliyor
        Column(
          children: [
             // Satış fiyatı ve ürün adeti giriş alanları oluşturuluyor
            const CustomTextWidget(text: "Toplam Tutar"),
            SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    toplamFiyat.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
          ],
        )
      ],
    );
  }
  // Veri giriş alanı oluşturuluyor
  Widget _buildDataInputField(
      String labelText, TextEditingController controller) {
    return Column(
      children: [
        CustomTextWidget(text: labelText),
        customTextFieldTwo(controller),
      ],
    );
  }
  // Özel metin giriş alanı oluşturuluyor
  Widget customTextFieldTwo(TextEditingController controller) {
    return Container(
      width: 116,
      height: 41,
      decoration: const BoxDecoration(
        color: Color(0xFF5D5353),
      ),
      child: TextField(
          controller: controller,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(color: Colors.white)),
    );
  }
   // Müşteri verileri getiriliyor
  Future<void> bringCustomers() async {
    customers = await dataBaseService
        .fetchCustomerAndSuppliers(AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {}));
  }

  // Ürün verileri getiriliyor
  Future<void> bringProducts() async {
    products = await dataBaseService
        .fetchProducts(AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {}));
  }
//// Satılan işlemlerin listesi getiriliyor
  Future<void> bringSoldProcesses() async {
    soldProcessList = await dataBaseService
        .fetchProcess(
            userID: AuthService().getCurrentUser()!.uid, tip: IslemTipi.satis)
        .whenComplete(() => setState(() {}));
  }
}

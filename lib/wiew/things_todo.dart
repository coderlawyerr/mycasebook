import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dataList.dart';
import 'package:flutter_application_1/widgets/datepicker.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/widgets/todo_date.dart';
import 'package:flutter_application_1/widgets/todobuttonpdf.dart';
import 'package:flutter_application_1/wiew/dashboard.dart';

////////////////////////////orjinalllll//////////////////
class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Todo> {
  List<SuplierCustomerModel> customers = [];
  List<ProductModel> products = [];
  SuplierCustomerModel? selectedCustomer;
  ProductModel? selectedProduct;
  DataBaseService dataBaseService = DataBaseService();

  double toplamSatis = 0.0;
  double toplamAlis = 0.0;
  double bakiye = 0.0;

  bool showCards = false;
  List<ProcessModel> data = [];
  List<ProcessModel> filteredData = [];

  DateTime? baslangicTarihi;

  DateTime? bitisTarihi;
  @override
  void initState() {
    super.initState();
    bringProcesses();
    bringCustomers();
    bringProducts();
  }

  void datePickerNotifier(DateTime baslangic, DateTime bitis) {
    setState(() {
      baslangicTarihi = baslangic;
      bitisTarihi = bitis; // burada bitisTarihi'ni güncelliyoruz
      filterData();
    });
  }

  // void datePickerNotifier(DateTime baslangic, DateTime bitis) {
  //   setState(() {
  //     baslangicTarihi = baslangic;
  //     filterData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
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
                  _buildDropdownRow(),
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
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
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
                  const SizedBox(height: 5),
                  CustomButton(
                    text: "Raporla",
                    toDo: () {
                      filterData();
                      setState(() {
                        showCards = true;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Todobuttonpdf(
                    text: "PDF OLUŞTUR",
                    data: filteredData, // Filtrelenmiş süreçlerin listesi
                  ),
                ] +
                (showCards ? dataCardList(context, filteredData, 1) : []),
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text(
        "Yapılan İşlemler",
        style: Constants.textStyle,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Overview()));
        },
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          customersDropDown(),
          const SizedBox(height: 20),
          productsDropDown(),
        ],
      ),
    );
  }

  Widget customersDropDown() {
    return DropdownButtonFormField<SuplierCustomerModel>(
      value: selectedCustomer,
      style: const TextStyle(color: Colors.black),
      hint: const Text(
        "Müşteri Seç",
        style: TextStyle(color: Colors.grey),
      ),
      isExpanded: true,
      dropdownColor: Color.fromARGB(255, 255, 255, 255),
      validator: (value) => value == null ? "Müşteri Seçiniz!" : null,
      autovalidateMode: AutovalidateMode.always,
      items: customers.isEmpty
          ? []
          : customers
              .map((e) => DropdownMenuItem<SuplierCustomerModel>(
                  value: e, child: Text(e.username)))
              .toList(),
      onChanged: (selected) {
        setState(() {
          selectedCustomer = selected;
          filterData();
        });
      },
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget productsDropDown() {
    return DropdownButtonFormField<ProductModel>(
      value: selectedProduct,
      style: const TextStyle(color: Colors.black),
      hint: Text(
        products.isEmpty ? "Ürün Yok!" : "Ürün Seç",
        style: const TextStyle(color: Colors.grey),
      ),
      validator: (value) => value == null ? "Ürün Seçiniz!" : null,
      autovalidateMode: AutovalidateMode.always,
      items: products.isEmpty
          ? []
          : products
              .map((e) => DropdownMenuItem<ProductModel>(
                  value: e, child: Text(e.productName)))
              .toList(),
      onChanged: (selected) {
        setState(() {
          selectedProduct = selected;
          filterData();
        });
      },
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  void filterData() {
    setState(() {
      filteredData = data.where((process) {
        bool matchesDateRange = baslangicTarihi == null ||
            (bitisTarihi == null
                ? process.date
                    .isAfter(baslangicTarihi!.subtract(const Duration(days: 1)))
                : process.date.isAfter(
                        baslangicTarihi!.subtract(const Duration(days: 1))) &&
                    process.date
                        .isBefore(bitisTarihi!.add(const Duration(days: 1))));

        bool matchesCustomer = selectedCustomer == null ||
            process.customerName == selectedCustomer!.username;
        bool matchesProduct = selectedProduct == null ||
            process.product.productName == selectedProduct!.productName;

        // Check if at least one filter is applied
        bool atLeastOneFilterApplied = selectedCustomer != null ||
            selectedProduct != null ||
            (baslangicTarihi != null && bitisTarihi != null);

        return atLeastOneFilterApplied &&
            matchesDateRange &&
            matchesCustomer &&
            matchesProduct;
      }).toList();

      calculateTotals();
    });
  }

  void calculateTotals() {
    double totalSales = 0.0;
    double totalPurchases = 0.0;

    for (ProcessModel process in filteredData) {
      if (process.processType == IslemTipi.satis) {
        totalSales += process.gelirHesapla();
      } else if (process.processType == IslemTipi.alis) {
        totalPurchases += process.giderHesapla();
      }
    }

    setState(() {
      toplamSatis = totalSales;
      toplamAlis = totalPurchases;
      bakiye = totalSales - totalPurchases;
    });
  }

  Future<void> bringProcesses() async {
    data = await dataBaseService.fetchAllProcess(
        userID: AuthService().getCurrentUser()!.uid);
    filterData();
  }

  Future<void> bringCustomers() async {
    customers = await dataBaseService
        .fetchCustomerAndSuppliers(AuthService().getCurrentUser()!.uid);
    setState(() {});
  }

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
    });
    setState(() {});
  }
}

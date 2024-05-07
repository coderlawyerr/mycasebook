/*
 bu sayfa urunler sayfası yanı eklenen urunler ve bunu sılmek ıcın kırmızı çöp kutusu
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/search.dart';
import 'package:flutter_application_1/wiew/add_product.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  // Arama yapmak için kullanılacak metin denetleyicisi
  TextEditingController searchController = TextEditingController(text: "");
  // Veritabanı işlemlerini gerçekleştirmek için servis nesnesi
  DataBaseService dataBaseService = DataBaseService();
  // Tüm ürünlerin listesi
  List<ProcessModel> processes = [];
  // Filtrelenmiş ürünlerin listesi
  List<ProcessModel> filteredProcesses = [];
  // Ürünlerin getirilip getirilmediğini kontrol etmek için bayrak
  bool isProductsFetched = false;

  @override
  void initState() {
    bringProducts().whenComplete(() {
      setState(() {
        filteredProcesses.addAll(processes);
      });
      searchController.addListener(() {
        if (searchController.text.length <= 2) {
          filteredProcesses.clear();
          filteredProcesses.addAll(processes);
          setState(() {});
        }

        // Ürünler getirildiyse ve arama metni minimum uzunluğa ulaştıysa
        if (isProductsFetched &&
            processes.isNotEmpty &&
            searchController.text.length > 2) {
          filteredProcesses.clear();
          for (var process in processes) {
            if (process.product.productName.contains(searchController.text)) {
              filteredProcesses.add(process);
            }
          }

          setState(() {});
        }
      });
    }); // Ürünleri getirme işlemi

    super.initState();
  }

  // Veritabanından ürünleri getirme işlemi
  Future<void> bringProducts() async {
    processes = await dataBaseService
        .fetchProcess(
            userID: AuthService().getCurrentUser()!.uid, tip: IslemTipi.alis)
        .whenComplete(() => setState(() {
              isProductsFetched = true;
            }));
  }

  @override
  void dispose() {
    searchController
        .dispose(); // Bellek sızıntısını önlemek için metin denetleyicisi kapatılır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ürün sayfasının yapılandırılması
    return Scaffold(
      appBar: _appbar(context), // Uygulama çubuğunun oluşturulması
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
                  searchBar(searchController, context, "ürün ara"),
                ] +
                (filteredProcesses.isNotEmpty
                    ? filteredProcesses
                        .map((process) => productCard(process))
                        .toList()
                    : []),
          ),
        ),
      ),
    );
  }

  ////ürün kartı
  Widget productCard(ProcessModel process) {
    var tarih = dateFormat(
        DateTime.fromMillisecondsSinceEpoch(process.product.date),
        hoursIncluded: true);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: customCard(
          onDelete: () {
            showAreYouSureDialog(context, message: "Eminmisiniz?")
                .then((value) {
              if (value != null && value as bool) {
                dataBaseService
                    .deleteProcess(
                        userId: AuthService().getCurrentUser()!.uid,
                        data: process)
                    .then((value) {
                  if (value) {
                    processes.clear();
                    isProductsFetched = false;
                    filteredProcesses.clear();
                    bringProducts().whenComplete(() => setState(() {}));
                  }
                });
              }
            });
          },
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(
                  mod: AddProductMod.edit,
                  data: process,
                ),
              ),
            );
          },
          text:
              "Ürün Adı: ${process.product.productName}\nAlış Fiyat: ${process.product.buyPrice}TL\nSatış Fiyat: ${process.product.sellPrice}\nAdet: ${process.product.productAmount}\nTarih:${tarih}", // Ürün bilgileri içeren metin

          context: context),
    );
  }

  // Uygulama çubuğunun oluşturulması
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Arkaplan rengi şeffaf olsun
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey, // Sol üst köşede geri butonu, gri renkte olsun
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Overview())); // Geri butonuna basıldığında genel bakış sayfasına yönlendir
          }),
      title: const Text(
        "Ürünlerim", // Uygulama çubuğunda "Ürünler" başlığı
        style: Constants.textStyle, // Başlık stili belirtildi
      ),
    );
  }
}

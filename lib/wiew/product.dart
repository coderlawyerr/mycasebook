/*
 bu sayfa urunler sayfası yanı eklenen urunler ve bunu sılmek ıcın kırmızı çöp kutusu
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  TextEditingController searchController = TextEditingController();
  DataBaseService dataBaseService = DataBaseService();
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isProductsFetched = false;

  @override
  void initState() {
    bringProducts();
    searchController.addListener(() {
      filteredProducts.clear();

      if (isProductsFetched &&
          products.isNotEmpty &&
          searchController.text.length > 2) {
        //print("Filtrelendi");
        for (var product in products) {
          if (product.productName.contains(searchController.text)) {
            filteredProducts.add(product);
          }
        }
        /*filteredProducts.forEach((element) {
          print(element.productName);
        });*/
        setState(() {});
      }
    });
    super.initState();
  }

  Future<void> bringProducts() async {
    products = await dataBaseService
        .fetchProcess(AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {
              isProductsFetched = true;
            }));
  }

  @override
  void dispose() {
    searchController.dispose();
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
                  searchBar(),
                ] +
                (filteredProducts.isNotEmpty
                    ? filteredProducts
                        .map((product) => productCard(product))
                        .toList()
                    : []),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              const SizedBox(
                width: 2,
              ),
              SizedBox(
                width: widthSize(context, 80),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "ÜRÜN ARA",
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          )),
    );
  }

  Widget productCard(ProductModel product) {
    var tarih = dateFormat(DateTime.fromMillisecondsSinceEpoch(product.date),
        hoursIncluded: true);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomCard(
        text:
            "Ürün Adı: ${product.productName}\nAlış Fiyat: ${product.buyPrice}TL\nSatış Fiyat: ${product.sellPrice}\nAdet: ${product.productAmount}\nTarih:${tarih}", // Ürün bilgileri içeren metin
      ),
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

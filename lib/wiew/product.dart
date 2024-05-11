/*
 bu sayfa urunler sayfası yanı eklenen urunler ve bunu sılmek ıcın kırmızı çöp kutusu
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/product_model.dart';
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
  List<ProductModel> products = [];
  // Filtrelenmiş ürünlerin listesi
  List<ProductModel> filteredProducts = [];
  // Ürünlerin getirilip getirilmediğini kontrol etmek için bayrak
  bool isProductsFetched = false;

  @override
  void initState() {
    // Widget oluşturulduğunda verilerin getirilmesi ve arama işlevselliğinin başlatılması
    bringProducts().whenComplete(() {
      setState(() {
        filteredProducts.addAll(products);
      });
      //ARAMA METNİ DEGISTIGINDE FILTRELENECEK URUNLERIN GUNCELLENMESI
      searchController.addListener(() {
        if (searchController.text.length <= 2) {
          filteredProducts.clear();
          filteredProducts.addAll(products);
          setState(() {});
        }

        // Ürünler getirildiyse ve arama metni minimum uzunluğa ulaştıysa
        if (isProductsFetched &&
            products.isNotEmpty &&
            searchController.text.length > 2) {
          filteredProducts.clear();
          for (var pro in products) {
            if (pro.productName.contains(searchController.text)) {
              filteredProducts.add(pro);
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
    products = await dataBaseService
        .fetchProducts(AuthService().getCurrentUser()!.uid)
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
                (filteredProducts.isNotEmpty
                    ? filteredProducts.map((pro) => productCard(pro)).toList()
                    : []),
          ),
        ),
      ),
    );
  }

  ////ürün kartı
  Widget productCard(ProductModel pro) {
    var tarih = dateFormat(DateTime.fromMillisecondsSinceEpoch(pro.date),
        hoursIncluded: true);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: customCard(
          onDelete: () {
            showAreYouSureDialog(context, message: "Eminmisiniz?")
                .then((value) {
              if (value != null && value as bool) {
                dataBaseService
                    .deleteProduct(
                        userId: AuthService().getCurrentUser()!.uid, data: pro)
                    .then((value) {
                  if (value) {
                    products.clear();
                    isProductsFetched = false;
                    filteredProducts.clear();
                    bringProducts().whenComplete(() => setState(() {
                          filteredProducts.addAll(products);
                        }));
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
                  data: pro,
                ),
              ),
            ).whenComplete(() {
              bringProducts().whenComplete(() => setState(() {}));
            });
          },
          text:
              "Ürün Adı: ${pro.productName}\nAlış Fiyat: ${pro.buyPrice}TL\nSatış Fiyat: ${pro.sellPrice}\nAdet: ${pro.productAmount}\nTarih:$tarih", // Ürün bilgileri içeren metin

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

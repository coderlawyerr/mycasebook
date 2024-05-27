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
  const Product({Key? key}) : super(key: key);

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
    super.initState();
    bringProducts();// Ürünleri getir
    searchController.addListener(filterProducts);// Arama kutusu dinleyicisini ekle
  }
    // Ürünleri veritabanından getir
  void bringProducts() async {
    products = await dataBaseService
        .fetchProducts(AuthService().getCurrentUser()!.uid);
    setState(() {
      isProductsFetched = true;
      filteredProducts =
          List.from(products); // Klon oluşturarak referans hatasını önle
      filteredProducts.sort((a, b) =>
          b.date.compareTo(a.date)); // En son eklenen ürün en üstte olsun
    });
  }

  void filterProducts() {
    if (searchController.text.length >= 2) {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product.productName.contains(searchController.text))
            .toList();
      });
    } else {
      setState(() {
        filteredProducts = List.from(products);
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            searchBar(searchController, context, "Ürün Ara"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return productCard(filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(ProductModel product) {
    var date = dateFormat(DateTime.fromMillisecondsSinceEpoch(product.date),
        hoursIncluded: true);
    return Padding(
      padding: const EdgeInsets.all(9),
      child: customCard(
        imageUrl: product.photoURL,
        onDelete: () {
          showAreYouSureDialog(context, message: "Emin misiniz?").then((value) {
            if (value != null && value) {
              dataBaseService
                  .deleteProduct(
                      userId: AuthService().getCurrentUser()!.uid,
                      data: product)
                  .then((deleted) {
                if (deleted) {
                  setState(() {
                    products.remove(product);
                    filteredProducts.remove(product);
                  });
                }
              });
            }
          });
        },
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddProduct(mod: AddProductMod.edit, data: product),
            ),
          ).then((_) => bringProducts());
        },
        text:
            "Ürün Adı: ${product.productName}\nAlış Fiyatı: ${product.buyPrice}TL\nSatış Fiyatı: ${product.sellPrice}\nAdet: ${product.productAmount}\nTarih: $date",
        context: context,
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Overview()));
        },
      ),
      title: const Text(
        "Ürünlerim",
        style: Constants.textStyle,
      ),
    );
  }
}

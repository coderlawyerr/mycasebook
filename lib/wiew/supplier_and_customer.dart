/*
tedarıkcı ve musterı lıstesı burada  ve sılme ıslemı gerceklesıyo
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/search.dart';
import 'package:flutter_application_1/wiew/overview.dart';

class supplier_and_customer extends StatefulWidget {
  const supplier_and_customer({super.key});

  @override
  State<supplier_and_customer> createState() => _ProductState();
}

class _ProductState extends State<supplier_and_customer> {
  TextEditingController searchController = TextEditingController();
  DataBaseService dataBaseService = DataBaseService();
  List<SuplierCustomerModel> customerlist = [];
  List<SuplierCustomerModel> filterlist = [];
  List<Widget> indexedFilteredCardList = [];

  bool isCustomerFetched = false;

  @override
  void initState() {
    bringCustomer();
    searchController.addListener(() {
      filterlist.clear();
      if (isCustomerFetched &&
          customerlist.isNotEmpty &&
          searchController.text.length > 2) {
        print("Filtrelendi");
        for (var customer in customerlist) {
          if (customer.username.contains(searchController.text)) {
            filterlist.add(customer);
          }
        }

        setState(() {}); //
      }
    });
    super.initState();
  }

  Future<void> bringCustomer() async {
    customerlist = await dataBaseService
        .fetchCustomer(AuthService().getCurrentUser()!.uid)
        .whenComplete(() => setState(() {
              isCustomerFetched = true;
            }));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    indexedFilteredCardList.clear();
    filterlist.asMap().forEach((key, value) {
      indexedFilteredCardList.add(customerCard(index: key, customer: value));
    });
    return Scaffold(
      appBar: _appbar(context), // Özel AppBar bileşeni
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
                  searchBar(searchController, context, "Ara"),
                ] +
                (filterlist.isNotEmpty
                    ? indexedFilteredCardList
                    //filterlist.map((product) => customerCard(product)).toList()
                    : []),
          ),
        ),
      ),
    );
  }

  Widget customerCard(
      {required int index, required SuplierCustomerModel customer}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: customCard(
        context: context,
        onDelete: () async {
          await dataBaseService
              .deleteSuplierOrCustomer(
                  userId: AuthService().getCurrentUser()!.uid, data: customer)
              .then((value) {
            if (value) {
              setState(() {
                filterlist.removeAt(index);
                indexedFilteredCardList.removeAt(index);
              });
            }
          });
        },
        text:
            "Cari Tipi: ${customer.currentType.name}\nAd-Soyad: ${customer.username}\nTel: ${customer.tel}\nAdres: ${customer.adress}", // Ürün bilgileri içeren metin
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
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
      title: const Text(
        "Tedarikçi Ve Müşteriler", // Başlık metni
        style: Constants
            .textStyle, // Sabit bir metin stili kullanarak başlık metni stilini belirtme
      ),
    );
  }
}

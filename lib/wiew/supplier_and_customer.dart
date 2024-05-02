/*
 Bu sayfa, kullanıcıların tedarikçi ve müşteri listesini görüntüler ve silme işlemini gerçekleştirir.
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/card.dart';
import 'package:flutter_application_1/widgets/search.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/suplier_and_customer_add.dart';

class supplier_and_customer extends StatefulWidget {
  supplier_and_customer({Key? key});

  @override
  State<supplier_and_customer> createState() => _ProductState();
}

class _ProductState extends State<supplier_and_customer> {
  TextEditingController searchController = TextEditingController();
  DataBaseService dataBaseService = DataBaseService();
  List<SuplierCustomerModel> customerlist = []; // Müşteri listesi
  List<SuplierCustomerModel> filterlist = []; // Filtrelenmiş müşteri listesi

  bool isCustomerFetched =
      false; // Müşterilerin çekilip çekilmediğini belirten bayrak

  @override
  void initState() {
    bringCustomer(); // Müşterileri getiren fonksiyon çağrılır
    searchController.addListener(() {
      filterlist.clear();
      if (isCustomerFetched &&
          customerlist.isNotEmpty &&
          searchController.text.length > 2) {
        print("Filtrelendi");
        // Filtreleme işlemi
        for (var customer in customerlist) {
          if (customer.username.contains(searchController.text)) {
            filterlist.add(customer);
          }
        }
        setState(() {}); // State güncellenir
      }
    });
    super.initState();
  }

  // Müşterileri getiren fonksiyon
  Future<void> bringCustomer() async {
    customerlist = await dataBaseService
        .fetchCustomerAndSuppliers(AuthService().getCurrentUser()!.uid)
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
                    ? filterlist
                        .map((customer) => customerCard(customer: customer))
                        .toList()
                    : []),
          ),
        ),
      ),
    );
  }

  // Her bir müşteri için özel kart oluşturan metod
  Widget customerCard({required SuplierCustomerModel customer}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: customCard(
        context: context,
        onDelete: () async {
          // Silme işlemi
          showAreYouSureDialog(context, message: "Silmek istiyormusunuz?")
              .then((value) async {
            if (value != null && value) {
              await dataBaseService
                  .deleteSuplierOrCustomer(
                      userId: AuthService().getCurrentUser()!.uid,
                      data: customer)
                  .then((value) {
                if (value) {
                  setState(() {
                    customerlist.clear();
                    isCustomerFetched = false;
                    filterlist.clear();
                    bringCustomer().whenComplete(() => setState(() {}));
                  });
                }
              });
            }
          });
        },
        onEdit: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Supplier_And_Customeradd(
                mod: SupplierPageMode.edit,
                data: customer,
              ),
            ),
          );
        },
        text:
            "Cari Tipi: ${customer.currentType.name}\nAd-Soyad: ${customer.username}\nTel: ${customer.tel}\nAdres: ${customer.adress}", // Müşteri bilgileri
      ),
    );
  }

  // Özel AppBar bileşeni oluşturan metod
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Saydam arka plan rengi
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey, // Gri renkli geri dönüş ikonu
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: const Text(
        "Tedarikçi Ve Müşteriler", // Başlık metni
        style: Constants
            .textStyle, // Sabit bir metin stili kullanarak başlık metni stilini belirtme
      ),
    );
  }
}

/*
tedarıkcı ve musterı ekleme sayfası
*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textfield.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:flutter_application_1/wiew/supplier_and_customer.dart';

class Supplier_And_Customeradd extends StatefulWidget {
  const Supplier_And_Customeradd(
      {super.key}); // Tedarikçi ve Müşteri eklemek için stateful bir bileşen

  @override
  State<Supplier_And_Customeradd> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Supplier_And_Customeradd> {
  DataBaseService databaseService = DataBaseService();

  final TextEditingController username = TextEditingController();
  final TextEditingController tel = TextEditingController();
  final TextEditingController adres = TextEditingController();
  CurrentType? currentType;

  void currentTypeSetter(CurrentType type) {
    currentType = type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Üst çubuk olarak kullanılacak özel AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.sizedbox,
              const CustomTextWidget(
                text: "Cari Tipi", // Seçim metni
              ),
              DropdownMenuExample(
                initialValue: 'Cari Tipi ',
                setter: currentTypeSetter,
              ), // Dropdown menü örneği
              Constants.sizedbox, // Sabit boyutlu bir boşluk
              /////////////
              const CustomTextWidget(
                text: "Ad-Soyad", // Telefon metni
              ),
              customTextField(controller: username), // Özel metin giriş alanı
              Constants.sizedbox, // Sabit boyutlu bir boşluk
              ///////////
              const CustomTextWidget(
                text: "Telefon", // Adres metni
              ),
              customTextField(controller: tel), // Özel metin giriş alanı
              Constants.sizedbox, // Sabit boyutlu bir boşluk
              const CustomTextWidget(
                text: "Adres", // Adres metni
              ),
              customTextField(controller: adres),
              Constants.sizedbox,
              Center(
                child: CustomButton(
                  text: "ONAYLA", // Onayla metni
                  toDo: () {
                    if (username.text.isNotEmpty &&
                        tel.text.isNotEmpty &&
                        adres.text.isNotEmpty &&
                        currentType != null) {
                      SuplierCustomerModel data = SuplierCustomerModel();
                      data.tel = int.tryParse(tel.text) ?? 0;
                      data.username = username.text;
                      data.adress = adres.text;
                      data.currentType = currentType!;

                      databaseService
                          .addSupplierOrCustomer(
                              userId: AuthService().getCurrentUser()!.uid,
                              data: data)
                          .then((value) {
                        if (value != null) {
                          // Kullanıcıya başarılı ekleme mesajını göster
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Başarıyla  Eklendi")));
                          // Giriş alanlarını temizle
                          username.clear();
                          tel.clear();
                          adres.clear();
                          currentType = null;
                        }
                      });
                    }

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                               supplier_and_customer(),
                        ));
                  },
                  // Tedarikçi ve Müşteri sayfasına geçişi sağlayan sayfa
                ),
              ),
            ],
          ),
        ),
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
        " TEDARİKÇİ VE MÜŞTERİ EKLE ", // Başlık metni
        style:
            TextStyle(fontSize: 20, color: Colors.white), // Başlık metni stili
      ),
    );
  }
}

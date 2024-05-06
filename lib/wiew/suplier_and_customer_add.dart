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
import 'package:flutter_application_1/wiew/supplier_and_customer.dart';

enum SupplierPageMode { add, edit }

class Supplier_And_Customeradd extends StatelessWidget {
  Supplier_And_Customeradd(
      {super.key, this.mod = SupplierPageMode.add, this.data});

  SupplierPageMode mod; // Sayfa modu değişkeni

  SuplierCustomerModel? data; // Veri değişkeni

  final DataBaseService _databaseService =
      DataBaseService(); // Veritabanı servisi örneği

  late TextEditingController username;

  late TextEditingController tel;

  late TextEditingController adres;

  CurrentType? currentType; // Geçerli tür değişkeni

  // Geçerli türü ayarlayan metod
  void currentTypeSetter(CurrentType type) {
    currentType = type;
  }

  @override
  Widget build(BuildContext context) {
    username = TextEditingController(text: data?.username);
    tel = TextEditingController(text: data?.tel.toString());
    adres = TextEditingController(text: data?.adress);
    currentType = data?.currentType;
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
                initialValue: currentType,
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
                    // Veri girişi kontrolü
                    if (username.text.isNotEmpty &&
                        tel.text.isNotEmpty &&
                        adres.text.isNotEmpty &&
                        currentType != null) {
                      if (mod == SupplierPageMode.add) {
                        // Yeni tedarikçi/müşteri ekleme işlemi
                        data = SuplierCustomerModel();
                        data!.tel = int.tryParse(tel.text) ?? 0;
                        data!.username = username.text;
                        data!.adress = adres.text;
                        data!.currentType = currentType!;

                        _databaseService
                            .addSupplierOrCustomer(
                                userId: AuthService().getCurrentUser()!.uid,
                                data: data!)
                            .then((value) {
                          if (value) {
                            // Kullanıcıya başarılı ekleme mesajını göster
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Başarıyla  Eklendi")));
                            // Giriş alanlarını temizle

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      supplier_and_customer(),
                                ));
                          }
                        });
                      } else {
                        // Tedarikçi/müşteri düzenleme işlemi
                        data!.tel = int.tryParse(tel.text) ?? 0;
                        data!.username = username.text;
                        data!.adress = adres.text;
                        data!.currentType = currentType!;
                        _databaseService
                            .editSuplierOrCustomer(
                                userId: AuthService().getCurrentUser()!.uid,
                                newData: data!)
                            .then((value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Başarıyla  değiştirildi")));

                            Navigator.pop(context);
                          }
                        });
                      }
                    }
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
            Navigator.pop(context);
          }),
      title: Text(
        " TEDARİKÇİ VE MÜŞTERİ ${mod == SupplierPageMode.add ? "EKLE" : "DÜZENLE"}", // Başlık metni
        style:
            TextStyle(fontSize: 20, color: Colors.white), // Başlık metni stili
      ),
    );
  }
}

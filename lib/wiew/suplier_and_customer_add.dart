/*
tedarıkcı ve musterı ekleme sayfası
*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/supliercustomer_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/supplier_and_customer.dart';

enum SupplierPageMode { add, edit }

class SupplierAndCustomerAdd extends StatefulWidget {
  SupplierAndCustomerAdd(
      {super.key, this.mod = SupplierPageMode.add, this.data});

  final SupplierPageMode mod; // Sayfa modu değişkeni

  SuplierCustomerModel? data;

  @override
  State<SupplierAndCustomerAdd> createState() => _SupplierAndCustomerAddState();
}

class _SupplierAndCustomerAddState extends State<SupplierAndCustomerAdd> {
  final DataBaseService _databaseService = DataBaseService();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController username;

  late TextEditingController tel;

  late TextEditingController adres;

  CurrentType? currentType;

  final List<String> list = <String>[
    'Müşteri',
    'Tedarikçi',
  ];

  @override
  void initState() {
    // Eğer widget.data null değilse ve içinde username değeri varsa, o değer alınır; aksi halde varsayılan olarak boş bir değer atanır.
    username = TextEditingController(text: widget.data?.username ?? '');
    // Eğer widget.data null değilse ve içinde tel değeri varsa, bu değer string'e dönüştürülür; aksi halde varsayılan olarak boş bir değer atanır.
    tel = TextEditingController(text: widget.data?.tel?.toString() ?? '');
    // Eğer widget.data null değilse ve içinde adress değeri varsa, o değer alınır; aksi halde varsayılan olarak boş bir değer atanır.
    adres = TextEditingController(text: widget.data?.adress ?? '');
    // Eğer widget.data null değilse, widget.data'nın currentType değeri alınır; aksi halde null atanır.
    currentType = widget.data?.currentType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context), // Üst çubuk olarak kullanılacak özel AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            //autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constants.sizedbox,
                const CustomTextWidget(
                  text: "Cari Tipi", // Seçim metni
                ),
                Container(
                  // color: const Color(0xFF44576D),
                  child: DropdownButtonFormField<String>(
                    value: currentType == null
                        ? null
                        : currentType == CurrentType.musteri
                            ? list[0]
                            : list[1],
                    hint: currentType == null
                        ? const Text("Cari Tipi Seç")
                        : null,
                    iconEnabledColor: Colors.white,
                    isExpanded: true,

                    ////carı tıpı secımı
                    validator: (value) =>
                        value == null ? " Cari tipi Seçiniz" : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        currentType = newValue == list[0]
                            ? CurrentType.musteri
                            : CurrentType.tedarikci;
                      });
                    },
                    //dropdownıtem
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .black), // Hata durumunda çizgi rengini kırmızı olarak ayarla
                      ),
                    ),
                  ),
                ),

                Constants.sizedbox, // Sabit boyutlu bir boşluk
                /////////////
                const CustomTextWidget(
                  text: "Ad-Soyad", // Telefon metni
                ),
                customOutlinedTextField(
                    controller: username), // Özel metin giriş alanı
                Constants.sizedbox, // Sabit boyutlu bir boşluk
                ///////////
                const CustomTextWidget(
                  text: "Telefon", // Adres metni
                ),
                customOutlinedTextField(
                    controller: tel, isNumber: true), // Özel metin giriş alanı
                Constants.sizedbox, // Sabit boyutlu bir boşluk
                const CustomTextWidget(
                  text: "Adres", // Adres metni
                ),
                customOutlinedTextField(controller: adres),
                Constants.sizedbox,
                Center(
                  child: CustomButton(
                    text: "ONAYLA", // Onayla metni
                    toDo: () {
                      // Veri girişi kontrolü
                      _formKey.currentState!.validate();
                      if (username.text.isNotEmpty &&
                          tel.text.isNotEmpty &&
                          adres.text.isNotEmpty &&
                          currentType != null) {
                        // Yeni tedarikçi/müşteri ekleme işlemi
                        if (widget.mod == SupplierPageMode.add) {
                          // Yeni bir SuplierCustomerModel nesnesi oluşturuyoruz.
                          widget.data = SuplierCustomerModel();
                          // Eğer dönüşüm başarısız olursa, varsayılan olarak 0 değerini atıyoruz.
                          widget.data!.tel = int.tryParse(tel.text) ?? 0;
                          // Kullanıcıdan alınan kullanıcı adını SuplierCustomerModel içindeki 'username' alanına atıyoruz.
                          widget.data!.username = username.text;
                          // Kullanıcıdan alınan adres bilgisini SuplierCustomerModel içindeki 'adress' alanına atıyoruz.

                          widget.data!.adress = adres.text;
                          // Burada currentType değişkeninin null olmadığını varsayıyoruz
                          widget.data!.currentType = currentType!;

                          widget.data!.date = DateTime.now();
                          _databaseService
                              .addSupplierOrCustomer(
                                  userId: AuthService().getCurrentUser()!.uid,
                                  data: widget.data!)
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
                                        const SupplierAndCustomer(),
                                  ));
                            }
                          });
                        } else {
                          // Tedarikçi/müşteri düzenleme işlemi
                          widget.data!.tel = int.tryParse(tel.text) ?? 0;
                          widget.data!.username = username.text;
                          widget.data!.adress = adres.text;
                          widget.data!.currentType = currentType!;
                          _databaseService
                              .editSuplierOrCustomer(
                                  userId: AuthService().getCurrentUser()!.uid,
                                  newData: widget.data!)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Başarıyla  değiştirildi")));

                              Navigator.pop(context);
                            }
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customOutlinedTextField({
    TextEditingController? controller,
    bool isNumber = false,
  }) {
    return Container(
      width: 372,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Dış kenarlık
        borderRadius: BorderRadius.circular(8), // Kenarlık köşeleri
      ),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) => value!.isEmpty ? "Boş bırakmayınız" : null,
        decoration: InputDecoration(
          border: InputBorder.none, // İç kenarlık
          contentPadding: EdgeInsets.symmetric(horizontal: 12), // İç boşluk
          errorStyle: TextStyle(color: Colors.white), // Hata rengi
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
  // Widget customTextField(
  //     {TextEditingController? controller, bool isNumber = false}) {
  //   return Container(
  //     width: 372,
  //     height: 42,
  //     decoration: const BoxDecoration(
  //       color: Color(0xFF5D5353),
  //     ),
  //     child: TextFormField(
  //         keyboardType: isNumber ? TextInputType.number : null,
  //         validator: (value) => value!.isEmpty ? " Boş bırakmayınız" : null,
  //         controller: controller,
  //         decoration: const InputDecoration(
  //             border: InputBorder.none,
  //             errorStyle: TextStyle(color: Colors.black)),
  //         style: const TextStyle(color: Colors.white)),
  //   );
  // }

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
        " TEDARİKÇİ VE MÜŞTERİ ${widget.mod == SupplierPageMode.add ? "EKLE" : "DÜZENLE"}", // Başlık metni
        style: const TextStyle(
            fontSize: 20, color: Colors.white), // Başlık metni stili
      ),
    );
  }
}

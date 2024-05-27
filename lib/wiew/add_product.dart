import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/photo.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/overview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../Services/storageService.dart';

enum AddProductMod { add, edit }

class AddProduct extends StatefulWidget {
  AddProductMod mod;

  ProductModel? data;

  AddProduct({super.key, this.mod = AddProductMod.add, this.data});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? yuklenecekDosya;

  FirebaseAuth auth = FirebaseAuth.instance;
  String? indirmeBaglantisi;
  XFile? selectedImage;
  @override
  void initState() {
    super.initState();
  }

 

  DataBaseService databaseService = DataBaseService();

  late TextEditingController productName;

  late TextEditingController buyPrice;

  late TextEditingController sellPrice;

  late TextEditingController productAmount;

  @override
  Widget build(BuildContext context) {
    productName = TextEditingController(text: widget.data?.productName);
    buyPrice = TextEditingController(text: widget.data?.buyPrice.toString());
    sellPrice = TextEditingController(text: widget.data?.sellPrice.toString());
    productAmount =
        TextEditingController(text: widget.data?.productAmount.toString());

    return Scaffold(
      appBar: _appbar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.sizedbox,
                  // Ürün adı giriş alanı
                  const CustomTextWidget(text: "Ürün Adı"),
                  // Ürün adı metin giriş alanı
                  // Ürün adı metin giriş alanı
                  customOutlinedTextField(
                    controller: productName,
                  ),

                  // Boşluk
                  Constants.sizedbox,
                  ///////////////
                  // Ürün alış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Alış Fiyatı"),
                  // Ürün alış fiyatı metin giriş alanı
                  customOutlinedTextField(controller: buyPrice, isNumber: true),
                  // Boşluk
                  Constants.sizedbox,

                  // Ürün satış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Satış Fiyatı"),
                  // Ürün satış fiyatı metin giriş alanı
                  customOutlinedTextField(
                      controller: sellPrice, isNumber: true),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  // Adet giriş alanı
                  const CustomTextWidget(text: "Adet"),
                  // Adet metin giriş alanı
                  customOutlinedTextField(
                      controller: productAmount, isNumber: true),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  ///ürün fotografı
                  const CustomTextWidget(text: "Ürün Fotografı"),

                  ProductPhoto(
                    onPhotoSelected: (resim) async {
                      final picker = ImagePicker();
                      selectedImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      log("Resim seçildi: ${selectedImage!.path}");

                      debugPrint("Seçilen resim: ${resim.path}");
                      // bir resim seç yeniden seç
                      // buada zaten resim seçildiğinde dönüyor
                      yuklenecekDosya = resim;
                      // resim seçildiğinde b otomatik doldurlacak.
                      // onayla butonuna bsatığında bu "yuklenecekDosya" değişkeninin dolu olduğunu kontrol et
                      // dolu ise storageye kaydet
                      var secilenResim = resim;
                    },
                  ), //
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      // Onayla butonu
                      text: "ONAYLA",
                      // Ürün sayfasına yönlendir
                      toDo: () async {
                        // Eğer ürün adı, alış fiyatı, satış fiyatı ve ürün miktarı alanları boş değilse devam et

                        if (productName.text.isNotEmpty &&
                            buyPrice.text.isNotEmpty &&
                            sellPrice.text.isNotEmpty &&
                            productAmount.text.isNotEmpty) {
                          //
                          // Eğer işlem ekleme modunda ise
                          final photoUrl = await StorageService()
                              .uploadProductImage(
                                  imagePath: selectedImage); // resmi yükle
                          if (widget.mod == AddProductMod.add) {
                            // Yeni bir ürün modeli oluştur
                            ProductModel product = ProductModel();
                            // urun adı yazınca  urun alıs fıyatını yazınca ondan oncekı yazdıklarım kayboluyor boyle oljmuyordu normalde
                            // Alış fiyatını doğrudan double'a dönüştür ve ürün nesnesine ata, dönüşüm başarısız olursa 0.0 olarak ata
                            product.buyPrice =
                                double.tryParse(buyPrice.text) ?? 0.0;

                            // Satış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                            product.sellPrice =
                                double.tryParse(sellPrice.text) ?? 0.0;

                            // Ürün adını ata
                            product.productName = productName.text;

                            // Ürün miktarını al, int'e dönüştür, dönüşüm başarısız olursa 0 olarak ata
                            product.productAmount =
                                int.tryParse(productAmount.text) ?? 0;

                            product.photoURL = photoUrl ?? "";
                            product.photoURL =
                                product.photoURL.split('token').first;

                            // Yeni ürünü veritabanına eklemek için databaseService kullanarak işlemi gerçekleştir
                            databaseService
                                .addNewProduct(
                              AuthService().getCurrentUser()!.uid,
                              product,
                              File(selectedImage!.path),
                            ) //yolu nasıl vereceg
                                .then((value) {
                              // Eğer işlem başarılı olduysa (değer null değilse)
                              if (value == true) {
                                // Kullanıcıya başarılı ekleme mesajını göster
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Ürün Başarıyla  Eklendi")));
                                // Giriş alanlarını temizle
                                productName.clear();
                                buyPrice.clear();
                                sellPrice.clear();
                                productAmount.clear();
                              }
                            });
                          } else {
                            // Eğer işlem güncelleme modunda ise
                            // Alış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                            widget.data!.buyPrice =
                                double.tryParse(buyPrice.text.trim()) ?? 0.0;

                            // Satış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                            widget.data!.sellPrice =
                                double.tryParse(sellPrice.text) ?? 0.0;

                            // Ürün adını ata
                            widget.data!.productName = productName.text;

                            // Ürün miktarını al, int'e dönüştür, dönüşüm başarısız olursa 0 olarak ata
                            widget.data!.productAmount =
                                int.tryParse(productAmount.text.trim()) ?? 0;

                            widget.data!.photoURL = photoUrl ?? "";
                            // İşlemi güncellemek için databaseService kullanarak işlemi gerçekleştir
                            databaseService
                                .updateProduct(
                              userID: AuthService().getCurrentUser()!.uid,
                              newData: widget.data!,
                            )
                                .then((value) {
                              // Eğer işlem başarılı olduysa (değer null değilse)
                              if (value == true) {
                                // Kullanıcıya başarılı güncelleme mesajını göster
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Ürün Başarıyla  Güncellendi")));

                                // Sayfayı kapat
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
          errorStyle: TextStyle(color: Colors.black), // Hata rengi
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Uygulama çubuğunda "Ürün Ekle" başlığı
  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // Sol üst köşede geri butonu, gri renkte olsun
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        // Geri butonuna basıldığında önceki sayfaya yönlendir
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Overview()),
          );
        },
      ),
      title: Text(
        widget.mod == AddProductMod.add ? "Ürün Ekle" : "Ürün Düzenle",
        style: Constants.textStyle,
      ),
    );
  }
}

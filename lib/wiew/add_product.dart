import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
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

// resmi nerede seçtiriyorsun?
enum AddProductMod { add, edit }

class AddProduct extends StatefulWidget {
  AddProductMod mod;

  ProductModel? data;

  AddProduct({Key? key, this.mod = AddProductMod.add, this.data})
      : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File?
      yuklenecekDosya; // burada image için bir dosya oluşturmuşsun zaten bunu eşitlemelisin seçilen resim ile.
  // onayla butonuna basıldığında buradaki resim kontrol edilir boş mu değil mi diye. dolu ise storageye yukelem işlemini yaparsın

  FirebaseAuth auth = FirebaseAuth.instance;
  String? indirmeBaglantisi;
  File? selectedImage;
  @override
  void initState() {
    super.initState();
  }

 Future galeridenYukle() async {
    // bu fonksiyonu başka bir yerden çağırmamışsın. çalışmaz
    var alinanDosya = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() async {
      yuklenecekDosya = File(alinanDosya!.path);
   
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("productphoto")
          .child("${const Uuid().v1()}.png");
  
      UploadTask yuklemeGorevi = storageRef.putFile(yuklenecekDosya!);
      TaskSnapshot snapshot = await yuklemeGorevi;
      String url = await snapshot.ref.getDownloadURL();
      setState(() {
        indirmeBaglantisi = url;
      });
    });
  }

  kameradanYukle() async {
    // kameradan resim ya da galeriden resim seçildiğinde storageye yukleme yapmamalısın. ??
    // resim seçildiğinde image dosyasını ayarlamalısın. diğer bilgilerle beraber kullanıcı doldurudğunda onayla butonunda storageye yukleme yapman gerek. resimm yuklemeeyle beraber diğer bilgileri de veri tabanına kaydetmelisin

    var alinanDosya = await ImagePicker().getImage(source: ImageSource.camera);

    //burda alınanDosya yı doldurman yeterli ama bu resmin seçilmiş olması ürünün ekleneceği anlamına gelmez
// iptal de edilebilir işlem
    setState(() async {
      yuklenecekDosya = File(alinanDosya!.path);
      String fileName =
          "${const Uuid().v1()}.png"; // Farklı dosya adı oluşturuldu
      Reference referansYol = FirebaseStorage.instance
          .ref()
          .child("urunresimleri")
          .child(auth.currentUser!.uid)
          .child(
              fileName); // Oluşturulan dosya adını kullanarak referans oluşturuldu

      UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya!);
      TaskSnapshot snapshot = await yuklemeGorevi;
      String url = await snapshot.ref.getDownloadURL();
      setState(() {
        indirmeBaglantisi = url;
      });
    });
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
                  customTextField(
                    controller: productName,
                  ),

                  // Boşluk
                  Constants.sizedbox,
                  ///////////////
                  // Ürün alış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Alış Fiyatı"),
                  // Ürün alış fiyatı metin giriş alanı
                  customTextField(controller: buyPrice, isNumber: true),
                  // Boşluk
                  Constants.sizedbox,

                  // Ürün satış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Satış Fiyatı"),
                  // Ürün satış fiyatı metin giriş alanı
                  customTextField(controller: sellPrice, isNumber: true),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  // Adet giriş alanı
                  const CustomTextWidget(text: "Adet"),
                  // Adet metin giriş alanı
                  customTextField(controller: productAmount, isNumber: true),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  ///ürün fotografı
                  const CustomTextWidget(text: "Ürün Fotografı"),
                  ProductPhoto(
                    onPhotoSelected: (resim) {
                      setState(() {
                        debugPrint("Seçilen resim: ${resim.path}");
                        // bir resim seç yeniden seç
                        // buada zaten resim seçildiğinde dönüyor
                        yuklenecekDosya = resim;
                        // resim seçildiğinde b otomatik doldurlacak.
                        // onayla butonuna bsatığında bu "yuklenecekDosya" değişkeninin dolu olduğunu kontrol et
                        // dolu ise storageye kaydet
                        var secilenResim = resim;
                      });
                    },
                  ), //

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

                                

                            // Yeni ürünü veritabanına eklemek için databaseService kullanarak işlemi gerçekleştir
                            databaseService
                                .addNewProduct(
                              AuthService().getCurrentUser()!.uid,
                              product,
                              File("ürün resimleri"),
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

  Widget customTextField(
      {TextEditingController? controller, bool isNumber = false}) {
    return Container(
      width: 372,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFF5D5353),
      ),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : null,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) => value!.isEmpty ? "Boş bırakmayınız" : null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          errorStyle: TextStyle(
              color: Colors
                  .black), // Burada errorStyle kullanarak hata rengini ayarlayın
        ),
        style: const TextStyle(color: Colors.white),
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

/*
 bu sayda urunlerı ekleme sayfası
*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/authService.dart';
import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/textwidget.dart';
import 'package:flutter_application_1/wiew/overview.dart';

enum AddProductMod { add, edit }

class AddProduct extends StatelessWidget {
  AddProductMod mod;

  ProcessModel? data;

  AddProduct({super.key, this.mod = AddProductMod.add, this.data});

  DataBaseService databaseService = DataBaseService();

  late TextEditingController productName;

  late TextEditingController buyPrice;

  late TextEditingController sellPrice;

  late TextEditingController productAmount;

  @override
  Widget build(BuildContext context) {
    productName = TextEditingController(text: data?.product.productName);
    buyPrice = TextEditingController(text: data?.product.buyPrice.toString());
    sellPrice = TextEditingController(text: data?.product.sellPrice.toString());
    productAmount =
        TextEditingController(text: data?.product.productAmount.toString());

    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.sizedbox,
                  // Ürün adı giriş alanı
                  const CustomTextWidget(text: "Ürün Adı"),
                  // Ürün adı metin giriş alanı
                  customTextField(controller: productName),
                  // Boşluk
                  Constants.sizedbox,
                  ///////////////
                  // Ürün alış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Alış Fiyatı"),
                  // Ürün alış fiyatı metin giriş alanı
                  customTextField(controller: buyPrice),
                  // Boşluk
                  Constants.sizedbox,

                  // Ürün satış fiyatı giriş alanı
                  const CustomTextWidget(text: "Ürün Satış Fiyatı"),
                  // Ürün satış fiyatı metin giriş alanı
                  customTextField(controller: sellPrice),
                  // Boşluk ekleyin
                  Constants.sizedbox,

                  // Adet giriş alanı
                  const CustomTextWidget(text: "Adet"),
                  // Adet metin giriş alanı
                  customTextField(controller: productAmount),
                  // Boşluk ekleyin
                  Constants.sizedbox,
                  Center(
                    child: CustomButton(
                        // Onayla butonu
                        text: "ONAYLA",
                        // Ürün sayfasına yönlendir

                        toDo: () {
                          // Eğer ürün adı, alış fiyatı, satış fiyatı ve ürün miktarı alanları boş değilse devam et
                          if (productName.text.isNotEmpty &&
                              buyPrice.text.isNotEmpty &&
                              sellPrice.text.isNotEmpty &&
                              productAmount.text.isNotEmpty) {
                            // Eğer işlem ekleme modunda ise
                            if (mod == AddProductMod.add) {
                              // Yeni bir ürün modeli oluştur
                              ProductModel product = ProductModel();

                              // Alış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                              double? buyPriceValue =
                                  double.tryParse(buyPrice.text);
                              product.buyPrice = buyPriceValue ?? 0.0;

                              // Satış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                              double? sellPriceValue =
                                  double.tryParse(sellPrice.text);
                              product.sellPrice = sellPriceValue ?? 0.0;

                              // Ürün adını ata
                              product.productName = productName.text;

                              // Ürün miktarını al, int'e dönüştür, dönüşüm başarısız olursa 0 olarak ata
                              int? productAmountValue =
                                  int.tryParse(productAmount.text);
                              product.productAmount = productAmountValue ?? 0;

                              // Yeni ürünü veritabanına eklemek için databaseService kullanarak işlemi gerçekleştir
                              databaseService
                                  .addNewProduct(
                                      AuthService().getCurrentUser()!.uid,
                                      product)
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
                              double? buyPriceValue =
                                  double.tryParse(buyPrice.text);
                              data!.product.buyPrice = buyPriceValue ?? 0.0;

                              ////

                            // double? buyPriceValue = double.tryParse(buyPrice.text);
                           // if (buyPriceValue != null) {
                          //   data!.product.buyPrice = buyPriceValue;
                          // } else {
                         //   data!.product.buyPrice = 0.0;
                           // }

                             //////
                              // Satış fiyatını al, double'a dönüştür, dönüşüm başarısız olursa 0.0 olarak ata
                              double? sellPriceValue =
                                  double.tryParse(sellPrice.text);
                              data!.product.sellPrice = sellPriceValue ?? 0.0;

                              // Ürün adını ata
                              data!.product.productName = productName.text;

                              // Ürün miktarını al, int'e dönüştür, dönüşüm başarısız olursa 0 olarak ata
                              int? productAmountValue =
                                  int.tryParse(productAmount.text);
                              data!.product.productAmount =
                                  productAmountValue ?? 0;

                              // İşlemi güncellemek için databaseService kullanarak işlemi gerçekleştir
                              databaseService
                                  .updateProcess(
                                      userID:
                                          AuthService().getCurrentUser()!.uid,
                                      newData: data!)
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
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget customTextField({TextEditingController? controller}) {
  return Container(
    width: 372,
    height: 42,
    decoration: const BoxDecoration(
      color: Color(0xFF5D5353),
    ),
    child:  TextField(
      controller: controller,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(color: Colors.white)),
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Overview()));
          }),
      title: Text(
        mod == AddProductMod.add ? "Ürün Ekle" : "Ürün Düzenle",
        style: Constants.textStyle,
      ),
    );
  }
}

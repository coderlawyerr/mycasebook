import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/process_model.dart';

// Veri kartlarını oluşturan fonksiyon
List<Widget> dataCardList(
    BuildContext context, List<ProcessModel> data, int cardType) {
  return List.generate(data.length, (index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: cardType == 1 && data[index].processType == IslemTipi.satis
            ? heightSize(context, 25)
            : heightSize(context, 18),
        width: widthSize(context, 90),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cardType == 1
                ? ([
                      Row(
                        children: [
                          const Text("İşlem Tipi:  ",
                              style: TextStyle(color: Colors.white)),
                          Text(
                            data[index].processType.name.toUpperCase(),
                            style: TextStyle(
                                color: data[index].processType == IslemTipi.alis
                                    ? Colors.black
                                    : Colors.amber,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Text(
                        "Tarih :${dateFormat(data[index].date, hoursIncluded: true)}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        "Ürün Adı :${data[index].product.productName}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        "Ürun Adeti :${data[index].product.productAmount}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        "Alış fiyatı :${data[index].product.buyPrice}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Visibility(
                        visible: data[index].processType == IslemTipi.alis,
                        child: Text(
                          "Toplam Tutar :${data[index].gelirHesapla()}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ] +
                    (data[index].processType == IslemTipi.satis
                        ? [
                            Text(
                              "Satış fiyatı :${data[index].product.sellPrice}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              "Kar Zarar Durumu :${data[index].profitState != null ? data[index].profitState!.name.toUpperCase() : ""}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              "Toplam Kazanç :${data[index].gelirHesapla()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ]
                        : []))
                : [
                    Text(
                      "Tarih :${dateFormat(data[index].date, hoursIncluded: true)}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Musteri Adı :${data[index].customerName}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Ürün Adı :${data[index].product.productName}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Urun Adeti :${data[index].product.productAmount}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Satış fiyatı :${data[index].product.sellPrice}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Toplam Tutar :${data[index].gelirHesapla()}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
          ),
        ),
      ),
    );
  });
}

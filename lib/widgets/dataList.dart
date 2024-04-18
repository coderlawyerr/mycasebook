import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/const.dart';
import 'package:flutter_application_1/models/table_model.dart';

// Veri kartlarını oluşturan fonksiyon
List<Widget> dataCardList(
    BuildContext context, List<TableDataModel> data, int cardType) {
  return List.generate(data.length, (index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: cardType == 1 && data[index].islemTipi == IslemTipi.satis
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
                      Text(
                        "Tarih :${dateFormat(data[index].tarih!, hoursIncluded: true)}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        "Ürün Adı :${data[index].urun!}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        "Ürun Adeti :${data[index].urunAdet!}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Row(
                        children: [
                          Text("İşlem Tipi:  ",
                              style: TextStyle(color: Colors.white)),
                          Text(
                            data[index].islemTipi!.name,
                            style: TextStyle(
                                color: data[index].islemTipi == IslemTipi.alis
                                    ? Colors.black
                                    : Colors.amber,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Text(
                        "Alış fiyatı :${data[index].urunAlisFiyati!}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Visibility(
                        visible: data[index].islemTipi == IslemTipi.alis,
                        child: Text(
                          "Toplam Tutar :${data[index].toplamTutar()}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ] +
                    (data[index].islemTipi == IslemTipi.satis
                        ? [
                            Text(
                              "Satış fiyatı :${data[index].urunSatisFiyati!}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              "Kar Zarar Durumu :${data[index].urunKarZararDurumu!.name}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              "Toplam Kazanç :${data[index].kazancHesapla()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ]
                        : []))
                : [
                    Text(
                      "Tarih :${dateFormat(data[index].tarih!, hoursIncluded: true)}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Musteri Adı :${data[index].musteriAd!}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Ürün Adı :${data[index].urun!}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Urun Adeti :${data[index].urunAdet!}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Satış fiyatı :${data[index].urunSatisFiyati!}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "Toplam Tutar :${data[index].kazancHesapla()}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
          ),
        ),
      ),
    );
  });
}

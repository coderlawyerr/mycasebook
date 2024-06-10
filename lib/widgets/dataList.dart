// ///////////////orjinal

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/const/const.dart';
// import 'package:flutter_application_1/models/process_model.dart';

// // Veri kartlarını oluşturan fonksiyon
// List<Widget> dataCardList(
//     BuildContext context, List<ProcessModel> data, int cardType) {
//   return List.generate(data.length, (index) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8, bottom: 8),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         height: cardType == 1 && data[index].processType == IslemTipi.satis
//             ? heightSize(context, 30)
//             : heightSize(context, 18),
//         width: widthSize(context, 90),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(
//                 data[index].product.photoURL,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: _buildCardContent(context, data[index], cardType),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   });
// }

// List<Widget> _buildCardContent(
//     BuildContext context, ProcessModel item, int cardType) {
//   List<Widget> baseContent = [
//     Text(
//       "Tarih :${dateFormat(item.date, hoursIncluded: true)}",
//       style: const TextStyle(color: Colors.white, fontSize: 15),
//     ),
//     Text(
//       "Ürün Adı :${item.product.productName}",
//       style: const TextStyle(color: Colors.white, fontSize: 15),
//     ),
//   ];

//   if (cardType == 1) {
//     baseContent.addAll([
//       Row(
//         children: [
//           const Text("İşlem Tipi:  ", style: TextStyle(color: Colors.white)),
//           Text(
//             item.processType.name.toUpperCase(),
//             style: TextStyle(
//               color: item.processType == IslemTipi.alis
//                   ? Colors.black
//                   : Colors.amber,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//       Text(
//         "${item.processType == IslemTipi.alis ? "Alış" : "Satış"} Adeti :${item.product.productAmount}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//       Text(
//         "Alış Birim Fiyatı :${item.product.buyPrice}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//     ]);

//     if (item.processType == IslemTipi.alis) {
//       baseContent.add(Text(
//         "Toplam Tutar : ${item.product.productAmount * item.product.buyPrice}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ));
//     }

//     if (item.processType == IslemTipi.satis) {
//       baseContent.addAll([
//         Text(
//           "Satış Birim fiyatı : ${item.product.sellPrice}",
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),
//         Text(
//           "Kar Zarar Durumu : ${item.profitState != null ? item.profitState!.name.toUpperCase() : ""}",
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),
//         Text(
//           "Satış Toplam Tutarı: ${item.gelirHesapla()}",
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),
//         Text(
//           "Kar Toplam Tutarı: ${item.karHesapla()}",
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),/// tmm sımdı goy goy
//         //simdi se
//       ]);
//     }
//   } else {
//     baseContent.addAll([
//       Text(
//         "Musteri Adı :${item.customerName}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//       Text(
//         "Urun Adeti :${item.product.productAmount}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//       Text(
//         "Satış Birim fiyatı :${item.product.sellPrice}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//       Text(
//         "Toplam Tutar :${item.gelirHesapla()}",
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//       ),
//     ]);
//   }

//   return baseContent;
// }
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
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: cardType == 1 && data[index].processType == IslemTipi.satis
            ? heightSize(context, 30)
            : heightSize(context, 18),
        width: widthSize(context, 90),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                data[index].product.photoURL,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildCardContent(context, data[index], cardType),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

List<Widget> _buildCardContent(
    BuildContext context, ProcessModel item, int cardType) {
  List<Widget> baseContent = [
    Text(
      "Tarih :${dateFormat(item.date, hoursIncluded: true)}",
      style: const TextStyle(color: Colors.white, fontSize: 15),
    ),
    Text(
      "Ürün Adı :${item.product.productName}",
      style: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  ];

  if (cardType == 1) {
    baseContent.addAll([
      Row(
        children: [
          const Text("İşlem Tipi:  ", style: TextStyle(color: Colors.white)),
          Text(
            item.processType.name.toUpperCase(),
            style: TextStyle(
              color: item.processType == IslemTipi.alis
                  ? Colors.black
                  : Colors.amber,
              fontSize: 15,
            ),
          ),
        ],
      ),
      Text(
        "${item.processType == IslemTipi.alis ? "Alış" : "Satış"} Adeti :${item.product.productAmount}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      Text(
        "Alış Birim Fiyatı :${item.product.buyPrice}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    ]);

    if (item.processType == IslemTipi.alis) {
      baseContent.add(Text(
        "Toplam Tutar : ${item.product.productAmount * item.product.buyPrice}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ));
    }

    if (item.processType == IslemTipi.satis) {
      baseContent.addAll([
        Text(
          "Satılan Müşteri : ${item.customerName}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          "Satış Birim fiyatı : ${item.product.sellPrice}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          "Kar Zarar Durumu : ${item.profitState != null ? item.profitState!.name.toUpperCase() : ""}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          "Satış Toplam Tutarı: ${item.gelirHesapla()}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          "Kar Toplam Tutarı: ${item.karHesapla()}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ]);
    }
  } else {
    baseContent.addAll([
      Text(
        "Musteri Adı :${item.customerName}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      Text(
        "Urun Adeti :${item.product.productAmount}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      Text(
        "Satış Birim fiyatı :${item.product.sellPrice}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      Text(
        "Toplam Tutar :${item.gelirHesapla()}",
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    ]);
  }

  return baseContent;
}

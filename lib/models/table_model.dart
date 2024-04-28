// KarZarar enum sınıfı, bir ürünün kar, zarar veya stabil olduğunu belirtir.
import 'package:flutter_application_1/models/process_model.dart';

enum KarZarar { kar, zarar, stabil }

// IslemTipi enum sınıfı, bir işlemin alış mı yoksa satış mı olduğunu belirtir.
enum IslemTipi { alis, satis }

// Tablo Veri Modeli sınıfı, işlem verilerini saklar.
class TableDataModel {
  DateTime? tarih; // İşlem tarihi
  String? urun; // İşlem yapılan ürünün adı
  int? urunAdet; // İşlem yapılan ürünün adedi
  String? musteriAd; // Satış işlemleri için müşteri adı
  double? urunAlisFiyati; // Ürünün alış fiyatı (tedarikçiden alınan fiyat)
  double? urunSatisFiyati; // Ürünün satış fiyatı (müşteriye satılan fiyat)
  KarZarar? urunKarZararDurumu; // Ürünün kar/zarar durumu
  IslemTipi? islemTipi; // İşlem tipi (alış veya satış)


  // Tablo Veri Modeli sınıfının kurucu metodu
  TableDataModel({
    this.tarih,
    this.urun,
    this.urunAdet,
    this.musteriAd,
    this.urunAlisFiyati,
    this.urunSatisFiyati,
    this.urunKarZararDurumu,
    this.islemTipi,
  });

  // İşlem kazancını hesaplayan fonksiyon
  double kazancHesapla() {
    double kazancFiyat = urunAdet!.toDouble() * urunSatisFiyati!;
    return kazancFiyat;
  }

  // İşlem toplam tutarını hesaplayan fonksiyon
  double toplamTutar() {
    return urunAdet!.toDouble() * urunAlisFiyati!;
  }
}

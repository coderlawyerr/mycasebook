import 'dart:io';

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class CustomButtonpdf extends StatelessWidget {
  final String text;

  const CustomButtonpdf({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: generateInvoice,
      child: Container(
        width: 274,
        height: 61,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 212, 164),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateInvoice() async {
    //BİR PDF OLUSTUR
    final PdfDocument document = PdfDocument();
    // PDF'ye bir sayfa ekleyin

    final PdfPage page = document.pages.add();
    // Sayfa istemci boyutunu al
    final Size pageSize = page.getClientSize();
    // Dikdörtgen çiz
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    // PDF ızgarası oluştur.
    final PdfGrid grid = getGrid();
    //// Metin öğelerinin başlık bölümleri çizin
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Izgara çiz
    drawGrid(page, grid, result);
    //Fatura altbilgisi ekle
    drawFooter(page, pageSize);
    //PDF belgesini kaydedin
    final List<int> bytes = document.saveSync();
    //Belgeyi atın.
    document.dispose();
    //Dosyayı kaydedin ve başlatın.
    await saveAndLaunchFile(bytes, 'KasaTakip.pdf');
  }

  //Fatura başlığını çizer
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Dikdörtgen çiz
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Dize çiz
    page.graphics.drawString(
        'KASATAKİP', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString(r'$' + getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Dize çiz
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Veri formatı oluşturun ve onu metne dönüştürün.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'KASATAKİP: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Bill To: \r\n\r\nAbraham Swearegin, 
        \r\n\r\nUnited States, California, San Mateo, 
        \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Izgarayı çizer
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //beginCellLayout olayını çağırın.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //PDF ızgarasını çizin ve sonucu alın.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Genel toplam çizin.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  //Fatura altbilgi verilerini çizin.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Çizgi çiz
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        // ignore: leading_newlines_in_multiline_strings
        '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? betulsensoy00@gmail.com''';

    // Düzen için kenar boşluğu olarak 30 eklendi
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //PDF ızgarası oluştur ve geri dön
  PdfGrid getGrid() {
    //Bir PDF ızgarası oluştur
    final PdfGrid grid = PdfGrid();
    //Sütun sayısını ızgaraya göre belirtin.
    grid.columns.add(count: 5);
    // Izgaranın başlık satırını oluşturun.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Stil ayarla
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'CariTipi';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Urun';
    headerRow.cells[2].value = 'SatisFiyati';
    headerRow.cells[3].value = 'UrunAdeti';
    headerRow.cells[4].value = 'Toplamtutar';
    //Satırları ekle
    addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    //Tablonun yerleşik stilini uygula
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Gird sütunlarının genişliğini ayarla
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  // Izgarayı oluşturun ve sıralayın.
  void addProducts(String CariTipi, String Urun, double SatisFiyati,
      int UrunAdeti, double Toplamtutar, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = CariTipi;
    row.cells[1].value = Urun;
    row.cells[2].value = SatisFiyati.toString();
    row.cells[3].value = UrunAdeti.toString();
    row.cells[4].value = Toplamtutar.toString();
  }

  //Toplam tutarı alıyoruz.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    //path_provider paketini kullanarak depolama klasörü konumunu alın.
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Dosyayı başlat (open_file paketi kullanıldı)
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }
}

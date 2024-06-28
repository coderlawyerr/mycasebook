import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/process_model.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;

class Salesbuttonpdf extends StatelessWidget {
  final String text;
  final List<ProcessModel> products; // Tek bir ürün yerine ürün listesi
  const Salesbuttonpdf({Key? key, required this.text, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: generateInvoice,
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
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    // Daha açık gri renk seçimi
    final PdfColor lightGrayColor = PdfColor(220, 220, 220);

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        brush: PdfSolidBrush(lightGrayColor), // Gri arka plan rengi
        pen: PdfPen(PdfColor(41, 53, 60)));
    final PdfGrid grid = getGrid();
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    drawGrid(page, grid, result);
    await drawFooter(page, pageSize);
    final List<int> bytes = document.saveSync();
    document.dispose();
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(41, 53, 60)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString(
        'KASA TAKIP', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(41, 53, 60)));

    page.graphics.drawString(r'TL' + getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = contentFont.measureString(invoiceNumber);

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

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

  Future<void> drawFooter(PdfPage page, Size pageSize) async {
    final PdfPen linePen =
        PdfPen(PdfColor(41, 53, 60), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent = '''iletisim : betulsensoy@gmail.com''';

    page.graphics.drawString(footerContent,
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds:
            Rect.fromLTWH(pageSize.width - 350, pageSize.height - 70, 0, 0));
    try {
      final ByteData imageData = await rootBundle.load('assets/ss.png');
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final PdfBitmap image = PdfBitmap(imageBytes);
      page.graphics.drawImage(image,
          Rect.fromLTWH(pageSize.width - 95, pageSize.height - 95, 90, 85));
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  PdfGrid getGrid() {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 6);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Product Name';
    headerRow.cells[3].value = 'Price';
    headerRow.cells[4].value = 'Quantity';
    headerRow.cells[5].value = 'Total';
    headerRow.cells[1].value = "Customer Name";

    // products listesi üzerinden dönerek her bir ürünü ekle
    for (var product in products) {
      addProducts(
        product.processType.name,
        product.product.productName,
        product.product.sellPrice,
        product.product.productAmount,
        product.product.productAmount * product.product.sellPrice,
        grid,
        product.customerName ?? '',
      );
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
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

  void addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid, String customerName) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[2].value = productName;
    row.cells[3].value = price.toString();
    row.cells[4].value = quantity.toString();
    row.cells[5].value = total.toString();
    row.cells[1].value = customerName;
  }

  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}

///kaydet ve acar
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //Get the storage folder location using path_provider package.
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
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}

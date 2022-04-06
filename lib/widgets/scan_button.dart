import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/utils/utils.dart';

import '../providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.qr_code),
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
        // String barcodeScanRes = "geo:28.466284123029705,-16.253856252380743";
        if (barcodeScanRes.contains('?')) {
          barcodeScanRes = barcodeScanRes.replaceRange(barcodeScanRes.indexOf('?'), null, '');
        }
        if (barcodeScanRes != '-1') {
          final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
          final newScan = await scanListProvider.newScan(barcodeScanRes);
          launchURL(context, newScan);
        }
      },
    );
  }
}

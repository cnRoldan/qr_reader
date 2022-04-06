import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel>? _scans = [];
  String tipoSeleccionado = 'http';

  set scans(List<ScanModel>? value) {
    scans = value;
  }

  List<ScanModel>? get scans {
    return _scans;
  }

  loadScans() async {
    _scans = await DBProvider.db.getAllScans();
    notifyListeners();
  }

  loadScansByTipo(String tipo) async {
    _scans = await DBProvider.db.getScansByTipo(tipo);
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteAllScans();
    _scans = [];
    notifyListeners();
  }

  deleteById(int id) async {
    _scans!.removeWhere((scan) =>
        scan.id == id); //Fix para remover del array, ya que la vista es demasiado rápida y no le da tiempo a la bd
    await DBProvider.db.deleteScan(id);
  }

  Future<ScanModel> newScan(String value) async {
    final newScan = ScanModel(valor: value);
    final id = await DBProvider.db.newScan(newScan);
    //Asignar el ID de la bd al nuevo Scan
    newScan.id = id;

    if (tipoSeleccionado == newScan.tipo) {
      _scans!.add(newScan);
      notifyListeners();
    }
    return newScan;
  }
}

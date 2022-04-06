import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  //Constructor privado, la clase se instancia desde aquí adentro.
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
    //Path de donde almacenaremos la base de datos.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print('Path: $path');
    //Crar db
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Scans (
          id INTEGER PRIMARY KEY,
          tipo TEXT,
          valor TEXT
        )
        ''');
      //Triple apóstrofe para Strings multilineas.
    });
  }

  newScanRaw(ScanModel newScan) async {
    final id = newScan.id;
    final tipo = newScan.tipo;
    final valor = newScan.valor;

    //Verificar la base de datos.
    final db = await database;

    final int res = await db!.rawInsert(''' 

      INSERT INTO Scans (id, tipo, valor) 
      VALUES  ( $id, '$tipo', '$valor' )   
    
    ''');

    return res;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.insert('Scans', newScan.toJson());
    print('Inserción realizada a db: $res');
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getAllScans() async {
    final db = await database;
    final res = await db!.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : null;
  }

  Future<List<ScanModel>?> getScansByTipo(String tipo) async {
    final db = await database;
    final res = await db!.rawQuery(''' 

        SELECT * FROM Scans WHERE tipo ='$tipo'

    ''');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  Future<int> updateScanModel(ScanModel newScan) async {
    final db = await database;
    final res = await db!.update('Scans', newScan.toJson(), where: 'id = ? ', whereArgs: [newScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.delete('Scans');
    return res;
  }
}

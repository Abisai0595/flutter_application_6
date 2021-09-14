import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Models/Notas.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
//Columnas de la base de datosw
  String notasTable = 'notas_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
//Instanciamos la base de datos
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
//Funcion asincrona que obtiene la bd
  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

//Funcion asincrona que inicializa la bd
  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notas.db';

    var notasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notasDatabase;
  }

  void _createDb(Database db, int newversion) async {
    await db.execute(
        'CREATE TABLE $notasTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colDate TEXT)');
  }

  //consultar datos
  Future<List<Map<String, dynamic>>> getNotasMapList() async {
    Database db = await this.database;
    var result = await db.query(notasTable, orderBy: '$colTitle ASC');
    return result;
  }

  // insertar datos
  Future<int> insertNotas(Notas notas) async {
    Database db = await this.database;
    debugPrint(notas.title);
    debugPrint(notas.description);
    var result = await db.insert(notasTable, notas.toMap());
    return result;
  }

  //actualizar datos
  Future<int> updateNotas(Notas notas) async {
    var db = await this.database;
    var result = await db.update(notasTable, notas.toMap(),
        where: '$colId = ?', whereArgs: [notas.id]);
    return result;
  }

  // Borrar datos

  Future<int> deleteNotas(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $notasTable WHERE $colId = $id');
    return result;
  }

  //cuenta registros
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $notasTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //lista registros
  Future<List<Notas>> getNotasList() async {
    var notasMapList = await getNotasMapList();
    int count = notasMapList.length;

    List<Notas> notasList;
    for (int i = 0; i < count; i++) {
      notasList.add(Notas.fromMapObjects(notasMapList[i]));
    }
    return notasList;
  }
}

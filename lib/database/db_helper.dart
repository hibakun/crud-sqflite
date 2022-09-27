import 'dart:io';
import 'package:crud_sqflite/model/makanan.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // database properties
  static const _dbName = 'food.db';
  static const _dbVersion = 1;

  // database table
  static const _tableName = 'food';

  // database column
  static const _cId = 'id';
  static const _cName = 'name';
  static const _cCategory = 'category';

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDatabase();
    }

    return _db!;
  }

  Future _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreateDatabase);
  }

  Future _onCreateDatabase(Database db, int version) async {
    print('create database');
    db.execute(
        'CREATE TABLE $_tableName ($_cId INTEGER PRIMARY KEY AUTOINCREMENT, $_cName TEXT NOT NULL, $_cCategory TEXT NOT NULL)');
  }

  Future<List<Makanan>> queryAll() async {
    Database db = await instance.database;
    final data = await db.query(_tableName);
    List<Makanan> result = data.map((e) => Makanan.fromMap(e)).toList();

    return result;
  }

  Future<int> insert(Makanan makanan) async {
    Database db = await instance.database;
    final query = await db.insert(_tableName, makanan.toMap());

    return query;
  }

  Future<int> update(int idFood, Makanan makanan) async {
    Database db = await instance.database;
    final query = await db.update(_tableName, makanan.toMap(),
        where: '$_cId = ?', whereArgs: [idFood]);

    return query;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;

    return await db.delete(_tableName, where: '$_cId = ?', whereArgs: [id]);
  }
}

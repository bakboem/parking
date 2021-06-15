import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parking/utile/textUtile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  factory DbService() => _sharedInstance();
  static DbService? _instance;
  DbService._();
  static DbService _sharedInstance() {
    if (_instance == null) {
      _instance = DbService._();
    }
    return _instance!;
  }

  TextUtile textUtile = TextUtile();
  getBaseDbPath() async => await getDatabasesPath();
  Future<String> getDbPath(String dbName) async =>
      join(await getBaseDbPath(), dbName);

  Future<Database> createDB(String dbName, String sql) async {
    var path = await getDbPath(dbName);
    late Database db;
    if (!await Directory(path).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      db.execute(sql);
    });
    return db;
  }

  Future<String> makeSql(Map<String, dynamic> tableMap) async {
    RegExp primaryKey = RegExp(r'primary|');
    RegExp table = RegExp(r'table');
    RegExp column = RegExp(r'column');
    StringBuffer sql = StringBuffer();
    tableMap.forEach((key, value) {
      if (textUtile.isMatch(key, table))
        sql.writeAll({'create', 'table', '$value', '('}, ' ');
      if (textUtile.isMatch(key, primaryKey))
        sql.writeAll(
            {'$value', 'integer', 'primary', 'key', 'autoincrement,'}, ' ');
      if (textUtile.isMatch(key, column))
        sql.writeAll(
            {'$value', 'integer', 'primary', 'key', 'autoincrement,'}, ' ');
    });
    return '';
  }

  Future<bool> deleteDB(String dbName) async =>
      deleteDatabase(await getDbPath(dbName))
          .then((_) => true)
          .catchError((e) => false);
}

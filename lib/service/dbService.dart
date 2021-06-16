import 'dart:io';
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

// mast Table Primary ColumnText or ColumnInt or ColumnTextNotNull ColumnIntNotNull
  Future<String> makeSql(Map<String, dynamic> tableMap) async {
    RegExp table = RegExp(r'Table');
    RegExp primaryKey = RegExp(r'Primary');
    RegExp textColumn = RegExp(r'(Column\B)+Text$');
    RegExp intColumn = RegExp(r'(Column\B)+Int$');
    RegExp textColumnNotNull = RegExp(r'(Column\B)+(Text\B)+(Not\B)+');
    RegExp intColumnNotNull = RegExp(r'(Column\B)+(Int\B)+(Not\B)+');

    StringBuffer strBuff = StringBuffer();
    tableMap.forEach((key, value) {
      bool last = tableMap.keys.last == key;
      if (textUtile.isMatch(key, table)) {
        strBuff.writeAll({'create', 'table', '$value', '('}, ' ');
      }

      if (textUtile.isMatch(key, primaryKey)) {
        strBuff.writeAll({
          '$value',
          'integer',
          'primary',
          'key',
          last ? 'autoincrement)' : 'autoincrement,'
        }, ' ');
      }

      if (textUtile.isMatch(key, intColumn)) {
        strBuff.writeAll({'$value', last ? 'integer)' : 'integer,'}, ' ');
      }

      if (textUtile.isMatch(key, textColumn)) {
        strBuff.writeAll({'$value', last ? 'text)' : 'text,'}, ' ');
      }
      if (textUtile.isMatch(key, intColumnNotNull)) {
        strBuff.writeAll(
            {'$value', 'integer', last ? 'not null)' : 'not null,'}, ' ');
      }

      if (textUtile.isMatch(key, textColumnNotNull)) {
        strBuff.writeAll(
            {'$value', 'text', last ? 'not null)' : 'not null,'}, ' ');
      }
    });
    var sql = '''${strBuff.toString()}''';
    print(sql);
    return sql;
  }

  Future<bool> deleteDB(String dbName) async =>
      deleteDatabase(await getDbPath(dbName))
          .then((_) => true)
          .catchError((e) => false);
}

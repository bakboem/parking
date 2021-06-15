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

  test() {
    RegExp text = RegExp(r'(77\B)'); //包含77
    RegExp text1 = RegExp(r'^(77)'); //以 77开头
    RegExp text2 = RegExp(
        r'(77\B$)'); //以 77结尾  这个公式不合理的地方在于， \B是非单词边界，' a77r ok ' 而$必须要求在末尾。

    // 结果，把不等于 77 的全部转换成 ok 。
    var result = text.hasMatch('77aR');
    var result2 = text1.hasMatch('7aR');
    var result3 = text2.hasMatch(' 77');

    print('######$result');
    print('######$result2');
    print('######$result3');
  }

  Future<String> makeSql(Map<String, dynamic> tableMap) async {
    RegExp primaryKey = RegExp(r'Primary');
    RegExp table = RegExp(r'Table');
    RegExp textColumn = RegExp(r'[^77]');

    StringBuffer strBuff = StringBuffer();
    tableMap.forEach((key, value) {
      bool last = tableMap.keys.last == key;

      // if (textUtile.isMatch(key, table))
      //   strBuff.writeAll({'create', 'table', '$value', '('}, ' ');
      // if (textUtile.isMatch(key, primaryKey))
      //   strBuff.writeAll({
      //     '$value',
      //     'integer',
      //     'primary',
      //     'key',
      //     last ? 'autoincrement)' : 'autoincrement,'
      //   }, ' ');

      // if (textUtile.isMatch(key, intColumnNotNull)) {
      //   strBuff.writeAll(
      //       {'$value', 'integer', last ? 'not null)' : 'not null,'}, ' ');
      // }

      if (textUtile.isMatch(key, textColumn)) {
        strBuff.writeAll(
            {'$value', 'text', last ? 'not null)' : 'not null,'}, ' ');
      }
    });
    var sql = '''${strBuff.toString()}''';
    print(sql);
    print(sql);
    return sql;
  }

  Future<bool> deleteDB(String dbName) async =>
      deleteDatabase(await getDbPath(dbName))
          .then((_) => true)
          .catchError((e) => false);
}

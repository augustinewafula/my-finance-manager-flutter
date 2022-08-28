import 'package:my_finance_manager/models/sms.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "my-finance-manager.db";
  static const _databaseVersion = 1;

  static const table = 'sms';

  static const columnId = 'id';
  static const columnBody = 'body';
  static const columnSynced = 'synced';

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnBody TEXT NOT NULL,
            $columnSynced INTEGER DEFAULT 0
          )
          ''');
  }

  Future<int> insertSms(Sms sms) async {
    Database db = await _initDatabase();
    return await db.insert(table, sms.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Sms>> getSms() async {
    Database db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Sms(
        id: maps[i][columnId],
        body: maps[i][columnBody],
        synced: maps[i][columnSynced],
      );
    });
  }

  Future<List<Sms>> searchSms(
      {required String column, required String value}) async {
    Database db = await _initDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: '$column = ?', whereArgs: [value]);
    return List.generate(maps.length, (i) {
      return Sms(
        id: maps[i][columnId],
        body: maps[i][columnBody],
        synced: maps[i][columnSynced],
      );
    });
  }

  Future<int> updateSms(Sms sms) async {
    Database db = await _initDatabase();
    return await db.update(table, sms.toMap(),
        where: '$columnId = ?', whereArgs: [sms.id]);
  }

  Future<int> deleteSms(int id) async {
    Database db = await _initDatabase();
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAllSms() async {
    Database db = await _initDatabase();
    return await db.delete(table);
  }
}

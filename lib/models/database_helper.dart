import 'package:sqflite/sqflite.dart';
import 'package:tugogram/models/bpm_record.dart';
import 'package:tugogram/models/schema.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'bpm_records.db';
  static const _databaseVersion = 1;
  static const String columnId = 'id';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(createBpmRecordsTable);
  }

  Future<int> insertBpmRecord(BpmRecord bpmRecord) async {
    final db = await database;
    return db.insert(
      bpmRecordsTable,
      bpmRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BpmRecord>> getBpmRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      bpmRecordsTable,
      orderBy: '${BpmRecordFields.time} DESC',
    );
    return List.generate(maps.length, (i) {
      return BpmRecord.fromMap(maps[i]);
    });
  }

  Future<void> deleteBpmRecord(int id) async {
    final db = await database;
    await db.delete(
      bpmRecordsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'sensorData.db';
  static final _databaseVersion = 1;

  static final table = 'sensorData';

  static final columnId = '_id';
  static final columnTemperature = 'temperature';
  static final columnCurrent = 'current';
  static final columnVibration = 'vibration';
  static final columnTimestamp = 'timestamp';

  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTemperature REAL NOT NULL,
            $columnCurrent REAL NOT NULL,
            $columnVibration REAL NOT NULL,
            $columnTimestamp INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insertSensorData(double temperature, double current,
      double vibration, DateTime timestamp) async {
    final db = await database;
    var res = await db.insert(table, {
      columnTemperature: temperature,
      columnCurrent: current,
      columnVibration: vibration,
      columnTimestamp: timestamp.millisecondsSinceEpoch
    });
    return res;
  }

  Future<List<Map<String, dynamic>>> getLastFiveSensorData() async {
    final db = await database;
    var res = await db.rawQuery('''
      SELECT * FROM $table ORDER BY $columnId DESC LIMIT 5
    ''');
    return res;
  }

  Future<List<Map<String, dynamic>>> querySensorData() async {
    Database db = await instance.database;
    return await db.query(table, orderBy: '$columnId DESC', limit: 5);
  }
}

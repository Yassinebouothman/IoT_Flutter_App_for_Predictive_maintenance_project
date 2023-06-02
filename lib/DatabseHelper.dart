import 'dart:async';
//import 'dart:ffi';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/sensordata.dart';

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

  Future deleteDatabase(String path) async {
    await deleteDatabase(path);
  }

  Future<int> insertSensorData(double temperature, double current,
      double vibration, int timestamp) async {
    // String dbPath = await getDatabasesPath();
    // String path = join(dbPath, 'sensorData.db');
    // await DatabaseHelper.instance.deleteDatabase(path);
    final db = await database;
    var res = await db.insert(table, {
      columnTemperature: temperature,
      columnCurrent: current,
      columnVibration: vibration,
      columnTimestamp: timestamp
    });
    return res;
  }

// in your DatabaseHelper class
  Future<List<SensorData>> getLastFiveSensorData() async {
    final db = await database;
    var res = await db.rawQuery('''
    SELECT $columnTemperature, $columnCurrent, $columnVibration, $columnTimestamp 
    FROM $table 
    ORDER BY $columnId DESC 
    LIMIT 5
  ''');
    return res
        .map((data) => SensorData(
            data[columnTemperature] as double,
            data[columnVibration] as double,
            data[columnCurrent] as double,
            DateTime.fromMillisecondsSinceEpoch(data[columnTimestamp] as int)
                .add(Duration(hours: 1))))
        .toList();
  }

//   Future<List<SensorData>> getLastSensorValue() async {
//     final db = await database;
//     var res = await db.rawQuery('''
//     SELECT $columnTemperature, $columnCurrent, $columnVibration,
//     FROM $table
//     ORDER BY $columnId DESC
//     LIMIT 1
//   ''');
//     return res.map((data) => SensorData(
//             data[columnTemperature] as double,
//             data[columnVibration] as double,
//             data[columnCurrent] as double,
//             DateTime.fromMillisecondsSinceEpoch(data[columnTimestamp] as int)
//                 .add(Duration(hours: 1))))
//         .toList();
//   }
}

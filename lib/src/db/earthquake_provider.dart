import 'package:quake/src/model/earthquake.dart';
import 'package:sqflite/sqflite.dart';

const String dbPath = "cache.db";
const String table_name = "cache";
const List<String> columns = [
  "eventID",
  "time",
  "latitude",
  "longitude",
  "depth",
  "magnitude",
  "eventLocationName"
];

/// Db helper (singleton) to store and get earthquakes
///
/// Columns:
/// eventID, time, latitude, longitude, depth, magnitude, eventLocationName
class EarthquakeProvider {
  static final EarthquakeProvider _instance = EarthquakeProvider._();
  factory EarthquakeProvider() => _instance;
  EarthquakeProvider._();

  Database db;

  /// this function should be called one time
  /// time must be stored in ms since epoch
  Future open() async {
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $table_name (
            ${columns[0]} INTEGER PRIMARY KEY,
            ${columns[1]} INTEGER NOT NULL,
            ${columns[2]} REAL NOT NULL,
            ${columns[3]} REAL NOT NULL,
            ${columns[4]} REAL NOT NULL,
            ${columns[5]} REAL NOT NULL,
            ${columns[6]} TEXT NOT NULL)
        ''');
      },
    );
  }

  /// returns an earthquake instance from a given ID
  ///
  /// This will be useful when opening earthquake detail page
  Future<Earthquake> getEarthquakeById(int eventID) async {
    List results = await db.query(
      "cache",
      columns: columns,
      where: "${columns[0]} = ?",
      whereArgs: [eventID],
    );
    return results.length > 0 ? Earthquake.fromMap(results.first) : null;
  }

  /// returns all earthquakes saved in the db
  Future<List<Earthquake>> getAllEarthquakes() async {
    List results = await db.query("cache", columns: columns);

    return results.length > 0
        ? results
            .map((earthquakeMap) => Earthquake.fromMap(earthquakeMap))
            .toList()
        : null;
  }

  /// correctly close connection to the database to avoid memory leaks
  Future<Null> dispose() async {
    if (db != null) await db.close();
  }
}

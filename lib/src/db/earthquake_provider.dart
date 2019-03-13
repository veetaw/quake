import 'dart:async';

import 'package:meta/meta.dart';

import 'package:quake/src/model/earthquake.dart';
import 'package:sqflite/sqflite.dart';

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

/// Db helper (singleton) to store and get earthquakes (persistent cache)
///
/// Columns:
/// eventID, time, latitude, longitude, depth, magnitude, eventLocationName
class EarthquakePersistentCacheProvider {
  static final EarthquakePersistentCacheProvider _instance =
      EarthquakePersistentCacheProvider._();
  factory EarthquakePersistentCacheProvider() => _instance;
  EarthquakePersistentCacheProvider._();

  Database db;
  String dbPath;

  /// this function should be called one time
  /// time must be stored in ms since epoch
  Future open(String dbPath) async {
    this.dbPath = dbPath;
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
  Future<Earthquake> getEarthquakeById({@required int eventID}) async {
    if (eventID == null) throw Exception('null_id');
    List results = await db.query(
      table_name,
      columns: columns,
      where: "${columns[0]} = ?",
      whereArgs: [eventID],
    );
    return results.length > 0 ? Earthquake.fromMap(results.first) : null;
  }

  /// returns all earthquakes saved in the db
  Future<List<Earthquake>> getAllEarthquakes() async {
    List results = await db.query(table_name, columns: columns);

    return results.length > 0
        ? results
            .map((earthquakeMap) => Earthquake.fromMap(earthquakeMap))
            .toList()
        : null;
  }

  /// Add earthquake to the cache
  Future<Null> addEarthquake({@required Earthquake earthquake}) async {
    if (earthquake == null) throw Exception('null_earthquake');
    await db.insert(table_name, earthquake.toDBMap());
  }

  /// Add a list of earthquakes to the cache
  /// (Just a wrapper over [addEarthquakes()])
  Future<Null> addEarthquakes({@required List<Earthquake> earthquakes}) async {
    if (earthquakes == null || earthquakes.isEmpty)
      throw Exception('null_earthquake');
    earthquakes.map((earthquake) async =>
        (await db.insert(table_name, earthquake.toDBMap())));
  }

  /// Delete earthquake by eventID
  Future<Null> deleteEarthquake({@required int eventID}) async {
    if (eventID == null) throw Exception('null_id');
    try {
      await db
          .delete(table_name, where: "${columns[0]} = ?", whereArgs: [eventID]);
    } catch (_) {
      throw Exception('delete_earthquake_error');
    }
  }

  /// Delete every earthquake in db
  Future<Null> dropCache() async {
    try {
      (await getAllEarthquakes()).map((earthquake) async =>
          await deleteEarthquake(eventID: earthquake.eventID));
    } catch (_) {
      throw Exception('drop_cache_error');
    }
  }

  /// Delete the whole database.
  Future<Null> dropDatabase() async {
    try {
      await deleteDatabase(dbPath ?? "");
    } catch (_) {
      throw Exception('db_delete_error');
    }
  }

  /// correctly close connection to the database to avoid memory leaks
  Future<Null> dispose() async {
    if (db != null) await db.close();
  }
}

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

  Database _db;
  String dbPath;

  /// this function should be called one time
  /// time must be stored in ms since epoch
  Future open(String dbPath) async {
    this.dbPath = dbPath;
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $table_name (
            ${columns[0]} TEXT PRIMARY KEY,
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
  Future<Earthquake> getEarthquakeById({@required String eventID}) async {
    if (eventID == null) throw Exception('null_id');
    List results = await _db.query(
      table_name,
      columns: columns,
      where: "${columns[0]} = ?",
      whereArgs: [eventID],
    );
    return results.length > 0 ? Earthquake.fromMap(results.first) : null;
  }

  /// returns all earthquakes saved in the db
  Future<List<Earthquake>> getAllEarthquakes() async {
    List results = await _db.query(table_name, columns: columns);

    return results.length > 0
        ? results
            .map((earthquakeMap) => Earthquake.fromMap(earthquakeMap))
            .toList()
        : null;
  }

  /// Add earthquake to the cache
  Future<void> addEarthquake({@required Earthquake earthquake}) async {
    if (earthquake == null) throw Exception('null_earthquake');

    if (await getEarthquakeById(eventID: earthquake.eventID) == null)
      await _db.insert(table_name, earthquake.toDBMap());
  }

  /// Add a list of earthquakes to the cache
  /// (Just a wrapper over [addEarthquakes()])
  void addEarthquakes({@required List<Earthquake> earthquakes}) {
    if (earthquakes == null || earthquakes.isEmpty)
      // throw Exception('null_earthquake');
      return;

    earthquakes.forEach((e) async => await addEarthquake(earthquake: e));
  }

  /// Delete earthquake by eventID
  Future<void> deleteEarthquake({@required String eventID}) async {
    if (eventID == null) throw Exception('null_id');
    try {
      await _db
          .delete(table_name, where: "${columns[0]} = ?", whereArgs: [eventID]);
    } catch (_) {
      throw Exception('delete_earthquake_error');
    }
  }

  /// Delete every earthquake in db
  Future<void> dropCache() async {
    try {
      (await getAllEarthquakes() ?? []).map((earthquake) async =>
          await deleteEarthquake(eventID: earthquake.eventID));
    } catch (_) {
      throw Exception('drop_cache_error');
    }
  }

  /// Delete the whole database.
  Future<void> dropDatabase() async {
    try {
      await deleteDatabase(dbPath ?? "");
    } catch (_) {
      throw Exception('db_delete_error');
    }
  }

  /// correctly close connection to the database to avoid memory leaks
  Future<void> dispose() async {
    if (_db != null) await _db.close();
  }
}

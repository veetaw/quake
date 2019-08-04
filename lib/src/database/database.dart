import 'package:moor_flutter/moor_flutter.dart';

import 'package:quake/src/database/dao/earthquake_dao.dart';
import 'package:quake/src/database/entity/earthquakes.dart';

part 'database.g.dart';

@UseMoor(tables: [Earthquakes], daos: [EarthquakeDao])
class Database extends _$Database {
  Database(String dbPath)
      : super(FlutterQueryExecutor.inDatabaseFolder(path: dbPath));

  @override
  int get schemaVersion => 1;
}

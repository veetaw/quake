import 'package:moor/moor.dart';

import 'package:quake/src/database/database.dart';
import 'package:quake/src/database/entity/earthquakes.dart';

part 'earthquake_dao.g.dart';

/// TODO
@UseDao(tables: [Earthquakes])
class EarthquakeDao extends DatabaseAccessor<Database>
    with _$EarthquakeDaoMixin {
  EarthquakeDao(Database db) : super(db);

  /// Returns all the cached earthquakes
  Future<List<EarthquakeEntity>> get allEarthquakes =>
      select(earthquakes).get();
}

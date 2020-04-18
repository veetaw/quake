import 'package:moor/moor.dart';

/// Every field is documented at lib\src\api\model\earthquake.dart
@DataClassName("Earthquake")
class Earthquakes extends Table {
  TextColumn get author => text().nullable()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();

  DateTimeColumn get creationTime => dateTime().named("creation_time")();

  RealColumn get depth => real()();

  RealColumn get depthUncertainity =>
      real().nullable().named("depth_uncertainity")();

  TextColumn get eventName => text().named("event_name")();

  RealColumn get magnitude => real()();

  RealColumn get magnitudeUncertainity =>
      real().nullable().named("magnitude_uncertainity")();

  IntColumn get stationCount => integer().nullable().named("station_count")();

  DateTimeColumn get time => dateTime()();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class EarthquakeEntity extends DataClass
    implements Insertable<EarthquakeEntity> {
  final String author;
  final double latitude;
  final double longitude;
  final DateTime creationTime;
  final double depth;
  final double depthUncertainity;
  final String eventName;
  final double magnitude;
  final double magnitudeUncertainity;
  final int stationCount;
  final DateTime time;
  final int type;
  EarthquakeEntity(
      {this.author,
      @required this.latitude,
      @required this.longitude,
      @required this.creationTime,
      @required this.depth,
      this.depthUncertainity,
      @required this.eventName,
      @required this.magnitude,
      this.magnitudeUncertainity,
      this.stationCount,
      @required this.time,
      @required this.type});
  factory EarthquakeEntity.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return EarthquakeEntity(
      author:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}author']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      creationTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_time']),
      depth:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}depth']),
      depthUncertainity: doubleType.mapFromDatabaseResponse(
          data['${effectivePrefix}depth_uncertainity']),
      eventName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_name']),
      magnitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}magnitude']),
      magnitudeUncertainity: doubleType.mapFromDatabaseResponse(
          data['${effectivePrefix}magnitude_uncertainity']),
      stationCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}station_count']),
      time:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}time']),
      type: intType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
    );
  }
  factory EarthquakeEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return EarthquakeEntity(
      author: serializer.fromJson<String>(json['author']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      depth: serializer.fromJson<double>(json['depth']),
      depthUncertainity: serializer.fromJson<double>(json['depthUncertainity']),
      eventName: serializer.fromJson<String>(json['eventName']),
      magnitude: serializer.fromJson<double>(json['magnitude']),
      magnitudeUncertainity:
          serializer.fromJson<double>(json['magnitudeUncertainity']),
      stationCount: serializer.fromJson<int>(json['stationCount']),
      time: serializer.fromJson<DateTime>(json['time']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'author': serializer.toJson<String>(author),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'depth': serializer.toJson<double>(depth),
      'depthUncertainity': serializer.toJson<double>(depthUncertainity),
      'eventName': serializer.toJson<String>(eventName),
      'magnitude': serializer.toJson<double>(magnitude),
      'magnitudeUncertainity': serializer.toJson<double>(magnitudeUncertainity),
      'stationCount': serializer.toJson<int>(stationCount),
      'time': serializer.toJson<DateTime>(time),
      'type': serializer.toJson<int>(type),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<EarthquakeEntity>>(
      bool nullToAbsent) {
    return EarthquakesCompanion(
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      creationTime: creationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(creationTime),
      depth:
          depth == null && nullToAbsent ? const Value.absent() : Value(depth),
      depthUncertainity: depthUncertainity == null && nullToAbsent
          ? const Value.absent()
          : Value(depthUncertainity),
      eventName: eventName == null && nullToAbsent
          ? const Value.absent()
          : Value(eventName),
      magnitude: magnitude == null && nullToAbsent
          ? const Value.absent()
          : Value(magnitude),
      magnitudeUncertainity: magnitudeUncertainity == null && nullToAbsent
          ? const Value.absent()
          : Value(magnitudeUncertainity),
      stationCount: stationCount == null && nullToAbsent
          ? const Value.absent()
          : Value(stationCount),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    ) as T;
  }

  EarthquakeEntity copyWith(
          {String author,
          double latitude,
          double longitude,
          DateTime creationTime,
          double depth,
          double depthUncertainity,
          String eventName,
          double magnitude,
          double magnitudeUncertainity,
          int stationCount,
          DateTime time,
          int type}) =>
      EarthquakeEntity(
        author: author ?? this.author,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        creationTime: creationTime ?? this.creationTime,
        depth: depth ?? this.depth,
        depthUncertainity: depthUncertainity ?? this.depthUncertainity,
        eventName: eventName ?? this.eventName,
        magnitude: magnitude ?? this.magnitude,
        magnitudeUncertainity:
            magnitudeUncertainity ?? this.magnitudeUncertainity,
        stationCount: stationCount ?? this.stationCount,
        time: time ?? this.time,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('EarthquakeEntity(')
          ..write('author: $author, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('creationTime: $creationTime, ')
          ..write('depth: $depth, ')
          ..write('depthUncertainity: $depthUncertainity, ')
          ..write('eventName: $eventName, ')
          ..write('magnitude: $magnitude, ')
          ..write('magnitudeUncertainity: $magnitudeUncertainity, ')
          ..write('stationCount: $stationCount, ')
          ..write('time: $time, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc(
                              $mrjc(
                                  $mrjc(
                                      $mrjc(
                                          $mrjc($mrjc(0, author.hashCode),
                                              latitude.hashCode),
                                          longitude.hashCode),
                                      creationTime.hashCode),
                                  depth.hashCode),
                              depthUncertainity.hashCode),
                          eventName.hashCode),
                      magnitude.hashCode),
                  magnitudeUncertainity.hashCode),
              stationCount.hashCode),
          time.hashCode),
      type.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is EarthquakeEntity &&
          other.author == author &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.creationTime == creationTime &&
          other.depth == depth &&
          other.depthUncertainity == depthUncertainity &&
          other.eventName == eventName &&
          other.magnitude == magnitude &&
          other.magnitudeUncertainity == magnitudeUncertainity &&
          other.stationCount == stationCount &&
          other.time == time &&
          other.type == type);
}

class EarthquakesCompanion extends UpdateCompanion<EarthquakeEntity> {
  final Value<String> author;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> creationTime;
  final Value<double> depth;
  final Value<double> depthUncertainity;
  final Value<String> eventName;
  final Value<double> magnitude;
  final Value<double> magnitudeUncertainity;
  final Value<int> stationCount;
  final Value<DateTime> time;
  final Value<int> type;
  const EarthquakesCompanion({
    this.author = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.depth = const Value.absent(),
    this.depthUncertainity = const Value.absent(),
    this.eventName = const Value.absent(),
    this.magnitude = const Value.absent(),
    this.magnitudeUncertainity = const Value.absent(),
    this.stationCount = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
  });
}

class $EarthquakesTable extends Earthquakes
    with TableInfo<$EarthquakesTable, EarthquakeEntity> {
  final GeneratedDatabase _db;
  final String _alias;
  $EarthquakesTable(this._db, [this._alias]);
  final VerificationMeta _authorMeta = const VerificationMeta('author');
  GeneratedTextColumn _author;
  @override
  GeneratedTextColumn get author => _author ??= _constructAuthor();
  GeneratedTextColumn _constructAuthor() {
    return GeneratedTextColumn(
      'author',
      $tableName,
      true,
    );
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  @override
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  @override
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  GeneratedDateTimeColumn _creationTime;
  @override
  GeneratedDateTimeColumn get creationTime =>
      _creationTime ??= _constructCreationTime();
  GeneratedDateTimeColumn _constructCreationTime() {
    return GeneratedDateTimeColumn(
      'creation_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _depthMeta = const VerificationMeta('depth');
  GeneratedRealColumn _depth;
  @override
  GeneratedRealColumn get depth => _depth ??= _constructDepth();
  GeneratedRealColumn _constructDepth() {
    return GeneratedRealColumn(
      'depth',
      $tableName,
      false,
    );
  }

  final VerificationMeta _depthUncertainityMeta =
      const VerificationMeta('depthUncertainity');
  GeneratedRealColumn _depthUncertainity;
  @override
  GeneratedRealColumn get depthUncertainity =>
      _depthUncertainity ??= _constructDepthUncertainity();
  GeneratedRealColumn _constructDepthUncertainity() {
    return GeneratedRealColumn(
      'depth_uncertainity',
      $tableName,
      true,
    );
  }

  final VerificationMeta _eventNameMeta = const VerificationMeta('eventName');
  GeneratedTextColumn _eventName;
  @override
  GeneratedTextColumn get eventName => _eventName ??= _constructEventName();
  GeneratedTextColumn _constructEventName() {
    return GeneratedTextColumn(
      'event_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _magnitudeMeta = const VerificationMeta('magnitude');
  GeneratedRealColumn _magnitude;
  @override
  GeneratedRealColumn get magnitude => _magnitude ??= _constructMagnitude();
  GeneratedRealColumn _constructMagnitude() {
    return GeneratedRealColumn(
      'magnitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _magnitudeUncertainityMeta =
      const VerificationMeta('magnitudeUncertainity');
  GeneratedRealColumn _magnitudeUncertainity;
  @override
  GeneratedRealColumn get magnitudeUncertainity =>
      _magnitudeUncertainity ??= _constructMagnitudeUncertainity();
  GeneratedRealColumn _constructMagnitudeUncertainity() {
    return GeneratedRealColumn(
      'magnitude_uncertainity',
      $tableName,
      true,
    );
  }

  final VerificationMeta _stationCountMeta =
      const VerificationMeta('stationCount');
  GeneratedIntColumn _stationCount;
  @override
  GeneratedIntColumn get stationCount =>
      _stationCount ??= _constructStationCount();
  GeneratedIntColumn _constructStationCount() {
    return GeneratedIntColumn(
      'station_count',
      $tableName,
      true,
    );
  }

  final VerificationMeta _timeMeta = const VerificationMeta('time');
  GeneratedDateTimeColumn _time;
  @override
  GeneratedDateTimeColumn get time => _time ??= _constructTime();
  GeneratedDateTimeColumn _constructTime() {
    return GeneratedDateTimeColumn(
      'time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedIntColumn _type;
  @override
  GeneratedIntColumn get type => _type ??= _constructType();
  GeneratedIntColumn _constructType() {
    return GeneratedIntColumn(
      'type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        author,
        latitude,
        longitude,
        creationTime,
        depth,
        depthUncertainity,
        eventName,
        magnitude,
        magnitudeUncertainity,
        stationCount,
        time,
        type
      ];
  @override
  $EarthquakesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'earthquakes';
  @override
  final String actualTableName = 'earthquakes';
  @override
  VerificationContext validateIntegrity(EarthquakesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.author.present) {
      context.handle(
          _authorMeta, author.isAcceptableValue(d.author.value, _authorMeta));
    } else if (author.isRequired && isInserting) {
      context.missing(_authorMeta);
    }
    if (d.latitude.present) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableValue(d.latitude.value, _latitudeMeta));
    } else if (latitude.isRequired && isInserting) {
      context.missing(_latitudeMeta);
    }
    if (d.longitude.present) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableValue(d.longitude.value, _longitudeMeta));
    } else if (longitude.isRequired && isInserting) {
      context.missing(_longitudeMeta);
    }
    if (d.creationTime.present) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableValue(
              d.creationTime.value, _creationTimeMeta));
    } else if (creationTime.isRequired && isInserting) {
      context.missing(_creationTimeMeta);
    }
    if (d.depth.present) {
      context.handle(
          _depthMeta, depth.isAcceptableValue(d.depth.value, _depthMeta));
    } else if (depth.isRequired && isInserting) {
      context.missing(_depthMeta);
    }
    if (d.depthUncertainity.present) {
      context.handle(
          _depthUncertainityMeta,
          depthUncertainity.isAcceptableValue(
              d.depthUncertainity.value, _depthUncertainityMeta));
    } else if (depthUncertainity.isRequired && isInserting) {
      context.missing(_depthUncertainityMeta);
    }
    if (d.eventName.present) {
      context.handle(_eventNameMeta,
          eventName.isAcceptableValue(d.eventName.value, _eventNameMeta));
    } else if (eventName.isRequired && isInserting) {
      context.missing(_eventNameMeta);
    }
    if (d.magnitude.present) {
      context.handle(_magnitudeMeta,
          magnitude.isAcceptableValue(d.magnitude.value, _magnitudeMeta));
    } else if (magnitude.isRequired && isInserting) {
      context.missing(_magnitudeMeta);
    }
    if (d.magnitudeUncertainity.present) {
      context.handle(
          _magnitudeUncertainityMeta,
          magnitudeUncertainity.isAcceptableValue(
              d.magnitudeUncertainity.value, _magnitudeUncertainityMeta));
    } else if (magnitudeUncertainity.isRequired && isInserting) {
      context.missing(_magnitudeUncertainityMeta);
    }
    if (d.stationCount.present) {
      context.handle(
          _stationCountMeta,
          stationCount.isAcceptableValue(
              d.stationCount.value, _stationCountMeta));
    } else if (stationCount.isRequired && isInserting) {
      context.missing(_stationCountMeta);
    }
    if (d.time.present) {
      context.handle(
          _timeMeta, time.isAcceptableValue(d.time.value, _timeMeta));
    } else if (time.isRequired && isInserting) {
      context.missing(_timeMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (type.isRequired && isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  EarthquakeEntity map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return EarthquakeEntity.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(EarthquakesCompanion d) {
    final map = <String, Variable>{};
    if (d.author.present) {
      map['author'] = Variable<String, StringType>(d.author.value);
    }
    if (d.latitude.present) {
      map['latitude'] = Variable<double, RealType>(d.latitude.value);
    }
    if (d.longitude.present) {
      map['longitude'] = Variable<double, RealType>(d.longitude.value);
    }
    if (d.creationTime.present) {
      map['creation_time'] =
          Variable<DateTime, DateTimeType>(d.creationTime.value);
    }
    if (d.depth.present) {
      map['depth'] = Variable<double, RealType>(d.depth.value);
    }
    if (d.depthUncertainity.present) {
      map['depth_uncertainity'] =
          Variable<double, RealType>(d.depthUncertainity.value);
    }
    if (d.eventName.present) {
      map['event_name'] = Variable<String, StringType>(d.eventName.value);
    }
    if (d.magnitude.present) {
      map['magnitude'] = Variable<double, RealType>(d.magnitude.value);
    }
    if (d.magnitudeUncertainity.present) {
      map['magnitude_uncertainity'] =
          Variable<double, RealType>(d.magnitudeUncertainity.value);
    }
    if (d.stationCount.present) {
      map['station_count'] = Variable<int, IntType>(d.stationCount.value);
    }
    if (d.time.present) {
      map['time'] = Variable<DateTime, DateTimeType>(d.time.value);
    }
    if (d.type.present) {
      map['type'] = Variable<int, IntType>(d.type.value);
    }
    return map;
  }

  @override
  $EarthquakesTable createAlias(String alias) {
    return $EarthquakesTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $EarthquakesTable _earthquakes;
  $EarthquakesTable get earthquakes => _earthquakes ??= $EarthquakesTable(this);
  EarthquakeDao _earthquakeDao;
  EarthquakeDao get earthquakeDao =>
      _earthquakeDao ??= EarthquakeDao(this as Database);
  @override
  List<TableInfo> get allTables => [earthquakes];
}

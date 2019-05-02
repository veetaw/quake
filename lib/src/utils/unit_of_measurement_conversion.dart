import 'package:meta/meta.dart';

class UnitOfMeasurementConversion {
  static const List<UnitOfMeasurement> supportedUnitOfMeasurement = [
    UnitOfMeasurement.kilometers,
    UnitOfMeasurement.meters
  ];

  static double convertTo({
    @required double kmValue,
    @required UnitOfMeasurement unit,
  }) {
    switch (unit) {
      case UnitOfMeasurement.meters:
        return _round(kmValue * 1000);
      case UnitOfMeasurement.miles:
        return _round(kmValue / 1.609);
      default:
        return _round(kmValue);
    }
  }

  static UnitOfMeasurement unitOfMeasurementFromString(String s) =>
      UnitOfMeasurement.values.firstWhere((u) => u.toString() == s);
}

double _round(double value) => (value * 10e1).truncate() / 10e1;

enum UnitOfMeasurement { kilometers, meters, miles }

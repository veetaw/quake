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
        return kmValue * 1000;
      case UnitOfMeasurement.miles:
        return kmValue / 1.609;
      default:
        return kmValue;
    }
  }

  static UnitOfMeasurement unitOfMeasurementFromString(String s) =>
      UnitOfMeasurement.values.firstWhere((u) => u.toString() == s);
}

enum UnitOfMeasurement { kilometers, meters, miles }

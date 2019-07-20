import 'package:quake/src/api/fsdnews_common.dart';
import 'package:test/test.dart';

void main() {
  FSDNewsOptions _circleOptions;
  FSDNewsOptions _bBoxOptions;

  setUp(() {
    _circleOptions = FSDNewsOptions.fromCircleConstraints(
      start: DateTime.now().subtract(Duration(days: 4)),
      end: DateTime.now(),
      latitude: 41.89,
      longitude: 12.49,
      minRadius: 0,
      maxRadius: 1,
      minDepth: 0,
      maxDepth: 100,
      minMagnitude: 0,
      maxMagnitude: 12,
    );

    _bBoxOptions = FSDNewsOptions.fromBoxConstraints(
      start: DateTime.now().subtract(Duration(days: 4)),
      end: DateTime.now(),
      minLatitude: 40.89,
      maxLatitude: 41.89,
      minLongitude: 11.49,
      maxLongitude: 12.49,
      minDepth: 0,
      maxDepth: 100,
      minMagnitude: 0,
      maxMagnitude: 12,
    );
  });

  test(
      'isValid should return true on a instance created '
      'with fromCircleConstraints even if some parameters '
      'are missing', () {
    expect(_circleOptions.isValid(), isTrue);
  });

  test(
      'isValid should return true on a instance created '
      'with fromBoxConstraints even if some parameters '
      'are missing', () {
    expect(_bBoxOptions.isValid(), isTrue);
  });

  test(
      'fromCircleConstraints: isValid should return false if '
      'a required parameter is null', () {
    _circleOptions.latitude = null;
    expect(_circleOptions.isValid(), isFalse);
  });

  test(
      'fromBoxConstraints: isValid should return false if '
      'a required parameter is null', () {
    _bBoxOptions.minLatitude = null;
    expect(_bBoxOptions.isValid(), isFalse);
  });

  test('Try to build a query map of _circleOptions and '
  'check that it doesn\'t contain bounding box fields', (){
    expect(_circleOptions.toQueryMap().containsKey("minlatitude"), isFalse);
    expect(_circleOptions.toQueryMap().containsKey("minlongitude"), isFalse);
    expect(_circleOptions.toQueryMap().containsKey("maxlatitude"), isFalse);
    expect(_circleOptions.toQueryMap().containsKey("maxlongitude"), isFalse);
  });

  test('Try to build a query map of _bBoxOptions and '
  'check that it doesn\'t contain circle box fields', (){
    expect(_bBoxOptions.toQueryMap().containsKey("latitude"), isFalse);
    expect(_bBoxOptions.toQueryMap().containsKey("longitude"), isFalse);
    expect(_bBoxOptions.toQueryMap().containsKey("minradius"), isFalse);
    expect(_bBoxOptions.toQueryMap().containsKey("maxradius"), isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/units.dart';

void main() {
  group('milesToKm / kmToMiles', () {
    test('round-trips', () {
      expect(kmToMiles(milesToKm(50)), closeTo(50, 1e-9));
    });

    test('a 50 mile radius is ~80km, not ~31km (the pre-fix bug)', () {
      final km = milesToKm(50);
      expect(km, closeTo(80.47, 0.1));
      expect((km - 31).abs() > 1, true);
    });
  });
}

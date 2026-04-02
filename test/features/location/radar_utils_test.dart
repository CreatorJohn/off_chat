import 'package:flutter_test/flutter_test.dart';
import 'package:off_chat/src/features/location/domain/radar_utils.dart';

void main() {
  group('RadarUtils Math Tests', () {
    test('calculateDistance should return correct distance in meters', () {
      // Coordinates for two points in Prague
      const lat1 = 50.0755;
      const lon1 = 14.4378;
      const lat2 = 50.0878;
      const lon2 = 14.4205;

      final distance = RadarUtils.calculateDistance(lat1, lon1, lat2, lon2);
      
      // Expected distance is approximately 1800-1900 meters
      expect(distance, closeTo(1850, 100));
    });

    test('calculateBearing should return 0 for North', () {
      const lat1 = 50.0;
      const lon1 = 14.0;
      const lat2 = 51.0;
      const lon2 = 14.0;

      final bearing = RadarUtils.calculateBearing(lat1, lon1, lat2, lon2);
      expect(bearing, closeTo(0, 1));
    });

    test('calculateBearing should return 90 for East', () {
      const lat1 = 50.0;
      const lon1 = 14.0;
      const lat2 = 50.0;
      const lon2 = 15.0;

      final bearing = RadarUtils.calculateBearing(lat1, lon1, lat2, lon2);
      expect(bearing, closeTo(90, 1));
    });

    test('calculateBearing should return 180 for South', () {
      const lat1 = 50.0;
      const lon1 = 14.0;
      const lat2 = 49.0;
      const lon2 = 14.0;

      final bearing = RadarUtils.calculateBearing(lat1, lon1, lat2, lon2);
      expect(bearing, closeTo(180, 1));
    });

    test('calculateBearing should return 270 for West', () {
      const lat1 = 50.0;
      const lon1 = 14.0;
      const lat2 = 50.0;
      const lon2 = 13.0;

      final bearing = RadarUtils.calculateBearing(lat1, lon1, lat2, lon2);
      expect(bearing, closeTo(270, 1));
    });
  });
}

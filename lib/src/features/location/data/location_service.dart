import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

final _log = Logger('LocationService');

class LocationData {
  final double latitude;
  final double longitude;
  final double heading;
  final double speed;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.speed,
  });
}

@Riverpod(keepAlive: true)
class LocationService extends _$LocationService {
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  double _currentLat = 0;
  double _currentLng = 0;
  double _currentHeading = 0;
  double _currentSpeed = 0;

  @override
  Stream<LocationData> build() async* {
    // Await permission and service check before yielding any data
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      // You could yield a default value or throw an error
      return;
    }

    final controller = StreamController<LocationData>.broadcast();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen(
      (position) {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
        _currentSpeed = position.speed;
        controller.add(LocationData(
          latitude: _currentLat,
          longitude: _currentLng,
          heading: _currentHeading,
          speed: _currentSpeed,
        ));
      },
      onError: (error) {
        // Handle stream errors
        _log.severe('Location stream error: $error');
      },
    );

    _compassSubscription = FlutterCompass.events?.listen(
      (event) {
        _currentHeading = event.heading ?? 0;
        controller.add(LocationData(
          latitude: _currentLat,
          longitude: _currentLng,
          heading: _currentHeading,
          speed: _currentSpeed,
        ));
      },
      onError: (error) {
        _log.severe('Compass stream error: $error');
      },
    );

    ref.onDispose(() {
      _positionSubscription?.cancel();
      _compassSubscription?.cancel();
      controller.close();
    });

    yield* controller.stream;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}

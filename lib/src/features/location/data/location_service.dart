import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final double heading;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.heading,
  });
}

@Riverpod(keepAlive: true)
class LocationService extends _$LocationService {
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  double _currentLat = 0;
  double _currentLng = 0;
  double _currentHeading = 0;

  @override
  Stream<LocationData> build() {
    _init();
    
    // Combine both streams
    final controller = StreamController<LocationData>.broadcast();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((position) {
      _currentLat = position.latitude;
      _currentLng = position.longitude;
      controller.add(LocationData(
        latitude: _currentLat,
        longitude: _currentLng,
        heading: _currentHeading,
      ));
    });

    _compassSubscription = FlutterCompass.events?.listen((event) {
      _currentHeading = event.heading ?? 0;
      controller.add(LocationData(
        latitude: _currentLat,
        longitude: _currentLng,
        heading: _currentHeading,
      ));
    });

    ref.onDispose(() {
      _positionSubscription?.cancel();
      _compassSubscription?.cancel();
      controller.close();
    });

    return controller.stream;
  }

  Future<void> _init() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
  }
}

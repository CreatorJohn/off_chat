import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/location/data/location_service.dart';
import 'package:off_chat/src/features/discovery/presentation/discovery_controller.dart';
import 'package:off_chat/src/features/discovery/domain/discovered_device_model.dart';
import 'package:off_chat/src/features/location/domain/radar_utils.dart';

part 'radar_controller.g.dart';

class RadarDevice {
  final DiscoveredDeviceModel model;
  final double distance; // in meters
  final double bearing;  // in degrees (0-360)

  RadarDevice({
    required this.model,
    required this.distance,
    required this.bearing,
  });
}

class RadarState {
  final LocationData? userLocation;
  final List<RadarDevice> nearbyDevices;

  RadarState({this.userLocation, this.nearbyDevices = const []});
}

@riverpod
class RadarController extends _$RadarController {
  @override
  RadarState build() {
    final locationAsync = ref.watch(locationServiceProvider);
    final devicesAsync = ref.watch(discoveryControllerProvider);

    final userLocation = locationAsync.value;
    final devices = devicesAsync.value ?? [];

    if (userLocation == null) {
      return RadarState();
    }

    final radarDevices = devices
        .where((d) => d.latitude != null && d.longitude != null)
        .map((d) {
          final distance = RadarUtils.calculateDistance(
            userLocation.latitude,
            userLocation.longitude,
            d.latitude!,
            d.longitude!,
          );
          final bearing = RadarUtils.calculateBearing(
            userLocation.latitude,
            userLocation.longitude,
            d.latitude!,
            d.longitude!,
          );
          return RadarDevice(model: d, distance: distance, bearing: bearing);
        })
        .toList();

    return RadarState(userLocation: userLocation, nearbyDevices: radarDevices);
  }
}

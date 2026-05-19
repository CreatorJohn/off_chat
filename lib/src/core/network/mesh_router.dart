import 'package:off_chat/src/core/database/models/found_device.dart';
import 'package:off_chat/src/core/database/models/relay_task.dart';
import 'package:off_chat/src/core/utils/geo_utils.dart';

abstract class MeshRouter {
  /// Returns a list of stableIds that should receive this task.
  /// This doesn't actually send the data, it just selects candidates.
  bool shouldRelayToPeer({
    required RelayTask task,
    required FoundDevice peer,
    required int myId,
    FoundDevice? targetDevice,
    FoundDevice? ourDevice,
  });
}

class DirectedBeamRouter extends MeshRouter {
  static const double angleWeight = 0.6;
  static const double rssiWeight = 0.4;
  static const double scoreThreshold = 0.5;

  @override
  bool shouldRelayToPeer({
    required RelayTask task,
    required FoundDevice peer,
    required int myId,
    FoundDevice? targetDevice,
    FoundDevice? ourDevice,
  }) {
    if (targetDevice == null || targetDevice.latitude == null) return true;
    if (peer.latitude == null || ourDevice?.latitude == null) return false;

    final score = calculateScore(
      ourDevice: ourDevice!,
      peer: peer,
      target: targetDevice,
    );

    return score >= scoreThreshold;
  }

  double calculateScore({
    required FoundDevice ourDevice,
    required FoundDevice peer,
    required FoundDevice target,
  }) {
    // 1. Angular Deviation Score
    final bearingToTarget = GeoUtils.calculateBearing(
      ourDevice.latitude!,
      ourDevice.longitude!,
      target.latitude!,
      target.longitude!,
    );
    final bearingToPeer = GeoUtils.calculateBearing(
      ourDevice.latitude!,
      ourDevice.longitude!,
      peer.latitude!,
      peer.longitude!,
    );

    double angleDiff = (bearingToTarget - bearingToPeer).abs();
    if (angleDiff > 180) angleDiff = 360 - angleDiff;
    
    final angleScore = (180 - angleDiff) / 180;

    // 2. RSSI Score (Normalized -100 to -30 range)
    final double normalizedRssi = (peer.rssi + 100).clamp(0, 70) / 70;

    // 3. Distance improvement (Optional but good: is peer closer than us?)
    final ourDist = GeoUtils.calculateDistance(
      ourDevice.latitude!,
      ourDevice.longitude!,
      target.latitude!,
      target.longitude!,
    );
    final peerDist = GeoUtils.calculateDistance(
      peer.latitude!,
      peer.longitude!,
      target.latitude!,
      target.longitude!,
    );
    
    final distanceMultiplier = peerDist < ourDist ? 1.0 : 0.5;

    return ((angleScore * angleWeight) + (normalizedRssi * rssiWeight)) *
        distanceMultiplier;
  }
}

class StarburstRouter extends MeshRouter {
  @override
  bool shouldRelayToPeer({
    required RelayTask task,
    required FoundDevice peer,
    required int myId,
    FoundDevice? targetDevice,
    FoundDevice? ourDevice,
  }) {
    // Starburst is simple: everyone is a candidate as long as they haven't received it yet.
    // (Filtering of previous recipients is handled in pushQueuedDataToPeer)
    return true;
  }
}

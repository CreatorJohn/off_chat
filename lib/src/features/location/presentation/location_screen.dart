import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/features/location/presentation/radar_controller.dart';
import 'package:off_chat/src/features/location/presentation/radar_painter.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radarState = ref.watch(radarControllerProvider);
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'OFFCHAT',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.primaryGold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppTheme.primaryGold.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Radar Canvas
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedBuilder(
                  animation: _sweepController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RadarPainter(
                        sweepAngle: _sweepController.value * pi * 2,
                        userHeading: radarState.userLocation?.heading ?? 0,
                        devices: radarState.nearbyDevices,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Distance Labels
                          _buildDistanceLabel("50M", 0.125),
                          _buildDistanceLabel("25M", 0.25),
                          _buildDistanceLabel("10M", 0.375),

                          // My Device (Center)
                          _buildCenterAnchor(profileAsync),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceLabel(String text, double topFactor) {
    return Positioned(
      top: MediaQuery.of(context).size.width * topFactor,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.primaryGold.withValues(alpha: 0.3),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCenterAnchor(AsyncValue profileAsync) {
    return profileAsync.when(
      data: (user) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                )
              ],
              border: Border.all(color: AppTheme.primaryGold, width: 2),
            ),
            child: ClipOval(
              child: user?.profilePicturePath != null
                  ? Image.file(File(user!.profilePicturePath!), fit: BoxFit.cover)
                  : const Icon(Icons.person, color: AppTheme.primaryGold),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'MY DEVICE',
              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Icon(Icons.error),
    );
  }
}

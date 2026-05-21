import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/core/database/models/found_device.dart';
import 'package:off_chat/src/features/discovery/data/ble_discoverer.dart';
import 'package:off_chat/src/features/discovery/presentation/widgets/log_viewer.dart';
import 'package:off_chat/src/features/discovery/presentation/discovery_controller.dart';
import 'package:off_chat/src/features/discovery/presentation/advertising_state.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  void _showDebugTerminal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => const LogViewer(),
    );
  }

  void _showProfileDialog(BuildContext context, FoundDevice device) {
    final dateFormat = DateFormat('HH:mm:ss dd.MM.yyyy');
    final lastSeenStr = dateFormat.format(device.lastSeen);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: AppTheme.primaryGold.withValues(alpha: 0.1)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryGold, width: 2),
              ),
              child: ClipOval(
                child: device.profilePicture != null
                    ? Image.memory(Uint8List.fromList(device.profilePicture!), fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 64, color: AppTheme.primaryGold),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              device.name ?? 'Unknown Node',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'STABLE ID: ${device.stableId}',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.1)),
            const SizedBox(height: 16),
            _buildProfileInfo(Icons.history, 'LAST SEEN', lastSeenStr),
            if (device.latitude != null) ...[
              const SizedBox(height: 12),
              _buildProfileInfo(
                Icons.location_on,
                'LOCATION',
                '${device.latitude!.toStringAsFixed(4)}, ${device.longitude!.toStringAsFixed(4)}',
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CLOSE'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/chat/${device.stableId}');
                    },
                    child: const Text('MESSAGE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryGold),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(discoveryControllerProvider);
    final isAdvertising = ref.watch(isAdvertisingProvider);
    final scanProgress = ref.watch(scanProgressProvider).value ?? 0.0;
    final discoverer = BLEDiscoverer();

    return Scaffold(
      backgroundColor: AppTheme.surfaceBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceBlack.withValues(alpha: 0.8),
        elevation: 0,
        bottom: scanProgress > 0 && scanProgress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  value: scanProgress,
                  backgroundColor: Colors.transparent,
                  color: AppTheme.primaryGold.withValues(alpha: 0.5),
                  minHeight: 2,
                ),
              )
            : null,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            _StatusIndicator(
              isActive: isAdvertising,
              activeColor: Colors.green,
              icon: Icons.visibility,
              tooltip: isAdvertising
                  ? 'Visible to others'
                  : 'Invisible (Advertising Off)',
            ),
          ],
        ),
        leadingWidth: 56,
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () => _showDebugTerminal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'OFFCHAT',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.primaryGold,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearby Devices',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppTheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scanning for active pulses...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: devicesAsync.when(
              data: (devices) {
                if (devices.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No devices found yet.',
                          style: TextStyle(color: AppTheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final device = devices[index];
                    // Consider "online" if seen in the last 2 minutes
                    final isOnline =
                        DateTime.now().difference(device.lastSeen).inMinutes < 2;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          _showProfileDialog(context, device);
                        },
                        child: _buildDeviceCard(
                          context: context,
                          device: device,
                          isOnline: isOnline,
                        ),
                      ),
                    );
                  }, childCount: devices.length),
                );
              },
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryGold),
                ),
              ),
              error: (err, stack) {
                // Log the error
                Logger('DiscoveryScreen').severe('Database error: $err', err, stack);
                
                // Show snackbar on next frame
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading devices: $err'),
                      backgroundColor: Colors.red.withValues(alpha: 0.8),
                    ),
                  );
                });

                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Database offline.',
                        style: TextStyle(color: AppTheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard({
    required BuildContext context,
    required FoundDevice device,
    required bool isOnline,
  }) {
    final scanStatusAsync = ref.watch(scanStatusProvider);
    String? granularStatus;
    if (scanStatusAsync.hasValue) {
      final data = scanStatusAsync.value!;
      if (data['syncingStableId'] == device.stableId) {
        granularStatus = data['deviceStatus'] as String?;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: device.profilePicture != null
                      ? Image.memory(Uint8List.fromList(device.profilePicture!), fit: BoxFit.cover)
                      : const Icon(Icons.person, color: AppTheme.primaryGold),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.surfaceBlack,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device.name ?? 'Unknown Node',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    if (device.publicKey != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 16, color: AppTheme.primaryGold),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (granularStatus != null)
                  Text(
                    granularStatus,
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 14,
                        color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Seen ${timeago.format(device.lastSeen)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.message, color: AppTheme.primaryGold),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.isActive,
    required this.activeColor,
    required this.icon,
    required this.tooltip,
  });

  final bool isActive;
  final Color activeColor;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Tooltip(
        message: tooltip,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive) _PulseAnimation(color: activeColor),
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? activeColor
                  : AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  const _PulseAnimation({required this.color});
  final Color color;

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 24 + (16 * _controller.value),
          height: 24 + (16 * _controller.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(
              alpha: 0.2 * (1 - _controller.value),
            ),
          ),
        );
      },
    );
  }
}

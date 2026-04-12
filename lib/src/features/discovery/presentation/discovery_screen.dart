import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/core/utils/log_service.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';
import 'package:off_chat/src/features/discovery/presentation/discovery_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  void _showDebugTerminal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final logs = ref.watch(logServiceProvider);
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SYSTEM LOGS', 
                      style: TextStyle(color: AppTheme.primaryGold, fontWeight: FontWeight.bold, letterSpacing: 2)
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                      onPressed: () => ref.read(logServiceProvider.notifier).clearLogs(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    Color color = Colors.white70;
                    if (log.contains('[SEVERE]')) color = Colors.redAccent;
                    if (log.contains('[WARNING]')) color = Colors.orangeAccent;
                    if (log.contains('[INFO]')) color = Colors.blueAccent;
                    
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          log,
                          style: TextStyle(
                            color: color,
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(discoveryControllerProvider);
    final bleServiceInstance = ref.watch(bleServiceProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceBlack.withValues(alpha: 0.8),
        elevation: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            StreamBuilder<bool>(
              stream: bleServiceInstance.isScanning,
              initialData: false,
              builder: (context, snapshot) {
                final isScanning = snapshot.data ?? false;
                return _StatusIndicator(
                  isActive: isScanning,
                  activeColor: Colors.blue,
                  icon: Icons.radar,
                  tooltip: isScanning ? 'Scanning Active' : 'Scanning Inactive',
                );
              },
            ),
            const SizedBox(width: 8),
            StreamBuilder<bool>(
              stream: bleServiceInstance.isAdvertising,
              initialData: false,
              builder: (context, snapshot) {
                final isAdvertising = snapshot.data ?? false;
                return _StatusIndicator(
                  isActive: isAdvertising,
                  activeColor: Colors.green,
                  icon: Icons.broadcast_on_personal,
                  tooltip: isAdvertising ? 'Advertising Active' : 'Advertising Inactive',
                );
              },
            ),
          ],
        ),
        leadingWidth: kDebugMode ? 100 : 60,
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () => _showDebugTerminal(context, ref),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryGold),
            onPressed: () {
              ref.read(discoveryControllerProvider.notifier).manualRefresh();
            },
          ),
        ],
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scanning for active pulses...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final device = devices[index];
                      final timeAgoStr = device.lastDiscovered != null 
                          ? 'Discovered ${timeago.format(device.lastDiscovered!)}'
                          : 'Unknown';
                      // Consider "online" if seen in the last 5 minutes
                      final isOnline = device.lastDiscovered != null && 
                          DateTime.now().difference(device.lastDiscovered!).inMinutes < 5;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildDeviceCard(
                          context: context,
                          name: device.username ?? 'Unknown Node',
                          timeAgo: timeAgoStr,
                          isOnline: isOnline,
                          profilePicturePath: device.profilePicturePath,
                        ),
                      );
                    },
                    childCount: devices.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGold)),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard({
    required BuildContext context,
    required String name,
    required String timeAgo,
    required bool isOnline,
    String? profilePicturePath,
  }) {
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
                  child: profilePicturePath != null
                      ? Image.file(File(profilePicturePath), fit: BoxFit.cover)
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
                      border: Border.all(color: AppTheme.surfaceBlack, width: 2),
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
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.history, size: 14, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
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
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, color: AppTheme.primaryGold),
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
            if (isActive)
              _PulseAnimation(color: activeColor),
            Icon(
              icon,
              size: 18,
              color: isActive ? activeColor : Colors.grey.withValues(alpha: 0.3),
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

class _PulseAnimationState extends State<_PulseAnimation> with SingleTickerProviderStateMixin {
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
            color: widget.color.withValues(alpha: 0.2 * (1 - _controller.value)),
          ),
        );
      },
    );
  }
}

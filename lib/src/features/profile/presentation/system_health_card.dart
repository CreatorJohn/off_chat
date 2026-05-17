import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/core/utils/system_health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';

class SystemHealthCard extends ConsumerWidget {
  const SystemHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(systemHealthProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: health.isOptimal
              ? Colors.green.withValues(alpha: 0.2)
              : AppTheme.primaryGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYSTEM HEALTH',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: health.isOptimal ? Colors.green : AppTheme.primaryGold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),
              if (health.isChecking)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryGold),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () =>
                      ref.read(systemHealthProvider.notifier).checkHealth(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _HealthItem(
            label: 'Bluetooth Adapter',
            isOk: health.isBluetoothOn,
            onFix: () {}, // Handled by OS usually
          ),
          _HealthItem(
            label: 'Location Services',
            isOk: health.isLocationEnabled,
            onFix: () {}, 
          ),
          _HealthItem(
            label: 'Location "Always" Permission',
            isOk: health.hasLocationAlways,
            onFix: () => Permission.locationAlways.request(),
          ),
          _HealthItem(
            label: 'Notification Permission',
            isOk: health.hasNotificationPermission,
            onFix: () => Permission.notification.request(),
          ),
          _HealthItem(
            label: 'Battery Optimization',
            isOk: !health.isBatteryOptimized,
            onFix: () => DisableBatteryOptimization.showDisableBatteryOptimizationSettings(),
          ),
          _HealthItem(
            label: 'Battery Saver Mode',
            isOk: !health.isBatterySaverOn,
            onFix: null, // User must toggle manually
            warning: true,
          ),
        ],
      ),
    );
  }
}

class _HealthItem extends StatelessWidget {
  final String label;
  final bool isOk;
  final VoidCallback? onFix;
  final bool warning;

  const _HealthItem({
    required this.label,
    required this.isOk,
    this.onFix,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle : (warning ? Icons.warning : Icons.error),
            size: 16,
            color: isOk
                ? Colors.green
                : (warning ? Colors.orange : Colors.redAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isOk
                    ? AppTheme.onSurfaceVariant.withValues(alpha: 0.8)
                    : AppTheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
          if (!isOk && onFix != null)
            TextButton(
              onPressed: onFix,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'FIX',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/features/profile/data/profile_manager.dart';
import 'package:off_chat/src/features/profile/presentation/system_health_card.dart';
import 'package:off_chat/src/features/discovery/presentation/advertising_state.dart';
import 'package:off_chat/src/features/discovery/data/ble_advertiser.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current advertising name
    Future.microtask(() async {
      final currentName = await ref.read(advertisingNameProvider.future);
      _nameController.text = currentName;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    await ProfileManager.pickAndSaveProfilePicture();
    ref.invalidate(profileControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);
    final isAdvertising = ref.watch(isAdvertisingProvider);

    return Scaffold(
      body: profileAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('No User Found'));
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                backgroundColor: AppTheme.surfaceBlack.withValues(alpha: 0.8),
                title: Text(
                  'OFFCHAT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.primaryGold,
                    letterSpacing: 4,
                  ),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Profile Hero
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 144,
                              height: 144,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [AppTheme.primaryGold, Color(0xFF554411)],
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: user.profilePicturePath != null
                                    ? Image.file(
                                        File(user.profilePicturePath!),
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: AppTheme.surfaceContainerHighest,
                                        child: const Icon(Icons.person, size: 64, color: AppTheme.primaryGold),
                                      ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.edit, size: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ID: ${user.deviceId ?? "UNKNOWN"}",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                          fontFamily: "monospace",
                        ),
                      ),
                      const SizedBox(height: 40),

                      const SystemHealthCard(),
                      const SizedBox(height: 24),

                      // Mesh Identity Card
                      _buildIdentityCard(context, isAdvertising),
                      const SizedBox(height: 24),
                      
                      // Settings Bento Grid
                      _buildSettingCard(
                        context: context,
                        icon: Icons.notifications_active,
                        title: 'Master Toggle',
                        subtitle: 'Enable or disable all alerts',
                        trailing: Switch(
                          value: user.isNotificationsEnabled,
                          activeTrackColor: AppTheme.primaryGold,
                          onChanged: (val) => ref.read(profileControllerProvider.notifier).toggleNotifications(val),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (user.isNotificationsEnabled) ...[
                        _buildSubSettingCard(
                          context: context,
                          title: 'New User Discovered',
                          subtitle: 'Notify when a new node is identified',
                          value: user.notifyNewUserIdentified,
                          onChanged: (val) => ref
                              .read(profileControllerProvider.notifier)
                              .toggleNotifyNewUserIdentified(val),
                        ),
                        const SizedBox(height: 8),
                        _buildSubSettingCard(
                          context: context,
                          title: 'First Contact',
                          subtitle: 'Alert on first message from a user',
                          value: user.notifyFirstMessage,
                          onChanged: (val) => ref
                              .read(profileControllerProvider.notifier)
                              .toggleNotifyFirstMessage(val),
                        ),
                        const SizedBox(height: 8),
                        _buildSubSettingCard(
                          context: context,
                          title: 'New Messages',
                          subtitle: 'Alert on all incoming chat data',
                          value: user.notifySubsequentMessages,
                          onChanged: (val) => ref
                              .read(profileControllerProvider.notifier)
                              .toggleNotifySubsequentMessages(val),
                        ),
                      ],
                      const SizedBox(height: 48),
                      
                      // Footer
                      Container(
                        height: 1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryGold.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          final version = snapshot.data?.version ?? '1.0.0';
                          final buildNumber = snapshot.data?.buildNumber ?? '1';
                          return Text(
                            'SECURITY LEVEL 4 // V$version+$buildNumber',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primaryGold.withValues(alpha: 0.4),
                              letterSpacing: 2,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context, bool isAdvertising) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MESH IDENTITY',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.primaryGold,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            maxLength: BLEAdvertiser.maxNameLength,
            style: const TextStyle(color: AppTheme.onSurfaceVariant),
            decoration: InputDecoration(
              labelText: 'Display Alias',
              labelStyle: TextStyle(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.38)),
              hintText: 'Enter mesh name...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryGold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newName = _nameController.text.trim();
                    if (newName.isNotEmpty) {
                      ref.read(advertisingNameProvider.notifier).change(newName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Identity synchronized with mesh')),
                      );
                    }
                  },
                  icon: const Icon(Icons.sync, size: 18),
                  label: const Text('SYNC NAME'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (isAdvertising) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    BLEAdvertiser().stopAdvertising();
                  },
                  icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                  tooltip: 'Stop Broadcast',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubSettingCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              activeTrackColor: AppTheme.primaryGold,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: AppTheme.primaryGold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

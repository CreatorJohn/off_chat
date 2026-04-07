import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndCompressImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 70,
      minWidth: 256,
      minHeight: 256,
    );

    if (compressedFile != null) {
      await ref.read(profileControllerProvider.notifier).updateProfilePicture(compressedFile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

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
                        onTap: () => _pickAndCompressImage(ref),
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
                      const SizedBox(height: 40),
                      
                      // Settings Bento Grid (using Column for simplicity in prototype)
                      _buildSettingCard(
                        context: context,
                        icon: Icons.radar,
                        title: 'Location Visibility',
                        subtitle: 'Broadcast device presence on active radar',
                        trailing: Switch(
                          value: user.isLocationVisible,
                          activeTrackColor: AppTheme.primaryGold,
                          onChanged: (val) => ref.read(profileControllerProvider.notifier).toggleLocationVisibility(val),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingCard(
                        context: context,
                        icon: Icons.notifications_active,
                        title: 'Notifications',
                        subtitle: 'Configure message alerts',
                        trailing: Switch(
                          value: user.isNotificationsEnabled,
                          activeTrackColor: AppTheme.primaryGold,
                          onChanged: (val) => ref.read(profileControllerProvider.notifier).toggleNotifications(val),
                        ),
                      ),
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

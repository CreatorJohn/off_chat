import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:off_chat/src/features/profile/data/profile_manager.dart';
import 'package:off_chat/src/features/discovery/presentation/widgets/log_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  String? _profilePicturePath;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    await ProfileManager.pickAndSaveProfilePicture();
    final bytes = await ProfileManager.getProfilePicture();
    if (bytes != null) {
      setState(() {
        _profilePicturePath = "STUB"; // Trigger UI update
      });
    }
  }

  void _nextPage() async {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 5) {
      // About to enter Identity screen (index 6)
      // Request all required permissions
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.location,
        Permission.notification,
      ].request();

      if (await Permission.location.isGranted) {
        await Permission.locationAlways.request();
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final localPath = "${dir.path}/profile_pic.webp";
    final file = File(localPath);
    
    try {
      await ref.read(onboardingControllerProvider.notifier).completeOnboarding(
        username: _nameController.text.trim(),
        profilePicturePath: await file.exists() ? localPath : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete onboarding: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final isLoading = onboardingState.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.surfaceBlack,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            physics: isLoading ? const NeverScrollableScrollPhysics() : null,
            children: [
              _buildSplashStep(),
              _buildStep(
                icon: Icons.radar,
                title: "Discover Nearby",
                description: "Identify and connect with devices in your immediate surroundings instantly.",
                stepIndex: 1,
              ),
              _buildStep(
                icon: Icons.forum,
                title: "Offline Messaging",
                description: "Send and receive messages without internet or cellular connectivity.",
                stepIndex: 2,
              ),
              _buildStep(
                icon: Icons.image,
                title: "Image Sharing",
                description: "Seamlessly exchange high-quality media across the local mesh network.",
                stepIndex: 3,
              ),
              _buildStep(
                icon: Icons.location_on,
                title: "Location Discovery",
                description: "Find your peers on a real-time relative radar visualization.",
                stepIndex: 4,
              ),
              _buildStep(
                icon: Icons.person_pin,
                title: "Profile Management",
                description: "Control your identity and visibility in the anonymous void.",
                stepIndex: 5,
              ),
              _buildFinalStep(),
            ],
          ),
          if (_currentPage > 0) _buildFooter(isLoading),
        ],
      ),
    );
  }

  Widget _buildSplashStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 120, color: AppTheme.primaryGold),
          const SizedBox(height: 24),
          GestureDetector(
            onDoubleTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black87,
                builder: (context) => const LogViewer(),
              );
            },
            child: Text(
              'OFFCHAT',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryGold,
                    letterSpacing: 8,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'THE DIGITAL CONCIERGE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 64),
          ElevatedButton(
            onPressed: _nextPage,
            child: const Text('BEGIN PROTOCOL'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required int stepIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.1)),
            ),
            child: Center(
              child: Icon(icon, size: 80, color: AppTheme.primaryGold),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 80, 40, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IDENTITY.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalize how you appear to others.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceContainerHigh,
                      border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.2), width: 4),
                    ),
                    child: ClipOval(
                      child: _profilePicturePath != null
                          ? FutureBuilder<Uint8List?>(
                              future: ProfileManager.getProfilePicture(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                                }
                                return const Icon(Icons.person, size: 80, color: Colors.white24);
                              },
                            )
                          : const Icon(Icons.person, size: 80, color: Colors.white24),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryGold,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.black, size: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'DISPLAY NAME',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.primaryGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter your alias...',
              hintStyle: TextStyle(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.2)),
              filled: true,
              fillColor: AppTheme.surfaceContainerHigh.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isLoading) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppTheme.surfaceBlack.withValues(alpha: 0.9)],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) => _buildPageIndicator(index)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : Text(_currentPage == 6 ? 'FINISH' : 'CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool active = index == _currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 24 : 8,
      height: 4,
      decoration: BoxDecoration(
        color: active ? AppTheme.primaryGold : AppTheme.onSurfaceVariant.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

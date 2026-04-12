# Graph Report - .  (2026-04-12)

## Corpus Check
- 90 files · ~131,538 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 191 nodes · 178 edges · 48 communities detected
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 27 edges (avg confidence: 0.89)
- Token cost: 0 input · 0 output

## God Nodes (most connected - your core abstractions)
1. `AppDelegate` - 7 edges
2. `Create()` - 6 edges
3. `Destroy()` - 6 edges
4. `Message Screen UI` - 6 edges
5. `MessageHandler()` - 5 edges
6. `Off Chat Project` - 5 edges
7. `Onboarding Step 5: Profile Management` - 5 edges
8. `Profile Screen (Identity)` - 5 edges
9. `Onboarding Splash Screen` - 5 edges
10. `Onboarding Step 1: User Discovery Screen` - 5 edges

## Surprising Connections (you probably didn't know these)
- `iOS App Icon (Flutter Default)` --semantically_similar_to--> `macOS App Icon (Flutter Default)`  [INFERRED] [semantically similar]
  ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png → macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png
- `Web App Icon (Flutter Default)` --semantically_similar_to--> `iOS App Icon (Flutter Default)`  [INFERRED] [semantically similar]
  web/icons/Icon-512.png → ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png
- `macOS App Icon (Flutter Default)` --semantically_similar_to--> `Web App Icon (Flutter Default)`  [INFERRED] [semantically similar]
  macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png → web/icons/Icon-512.png
- `Off Chat Implementation Plan` --references--> `Off Chat Project`  [INFERRED]
  developer/off-chat-plan.md → README.md
- `Onboarding Step 4: Location Discovery Screen` --conceptually_related_to--> `User Onboarding Flow (7 Steps)`  [INFERRED]
  docs/ui_prototype/onboarding_step_4_location_discovery/screen.png → docs/ui_prototype/onboarding_step_3_image_sharing/code.html

## Hyperedges (group relationships)
- **Off Chat Core Tech Stack** — filestem_tech_isar, filestem_tech_riverpod, filestem_tech_gorouter [EXTRACTED 1.00]
- **Hybrid BLE Discovery Components** — filestem_protocol_hybrid_discovery, filestem_protocol_13byte_payload, filestem_feature_radar [EXTRACTED 0.95]
- **Bottom Navigation Tabs** — screen_discovery_tab, screen_location_tab, screen_messages_tab, screen_profile_tab [EXTRACTED 1.00]
- **Privacy and Visibility Controls** — feature_stealth_mode, feature_alias_management, feature_proximity_fencing [INFERRED 0.90]
- **Onboarding Step 7 UI Components** — ui_profile_picture_picker, ui_display_name_input, ui_finish_button [EXTRACTED 1.00]
- **Profile View UI Components** — screen_user_profile, screen_location_visibility, screen_theme_mode, screen_system_alerts, screen_bottom_nav [INFERRED 0.90]
- **Android App Icons** — ic_launcher_hdpi, ic_launcher_mdpi, ic_launcher_xhdpi, ic_launcher_xxhdpi, ic_launcher_xxxhdpi [EXTRACTED 1.00]
- **iOS App Icons** — icon_app_1024, icon_app_20_1x, icon_app_20_2x, icon_app_20_3x, icon_app_29_1x, icon_app_29_2x, icon_app_29_3x, icon_app_40_1x, icon_app_40_2x, icon_app_40_3x, icon_app_60_2x, icon_app_60_3x, icon_app_76_1x [EXTRACTED 1.00]
- **Default Flutter Branding Assets** — ios_app_icon, macos_app_icon, web_app_icon, ios_launch_image [INFERRED 0.95]
- **Radar Visualization Components** — screen_radar_visualization, screen_my_device_node, screen_nearby_user_node, screen_distance_rings [EXTRACTED 1.00]
- **Proximity Messaging Features** — message_screen_ui, radar_connection_status, proximity_alert, peer_to_peer_file_transfer [INFERRED 0.85]
- **Message UI Elements** — message_screen_ui, image_message_bubble, message_input_area [EXTRACTED 1.00]
- **Logo Composition** — logo_central_smartphone, logo_speech_bubbles, logo_airplanes [EXTRACTED 1.00]
- **App Branding Core Elements** — logo_travel_communication, app_title_offchat, app_tagline_digital_concierge [INFERRED 0.85]
- **Offline Mesh Networking Architecture** — concept_offline_messaging, concept_p2p_mesh_network, protocol_mesh_grid [INFERRED 0.85]
- **Onboarding UI Sequence** — onboarding_step_3_image_sharing, onboarding_flow, image_sharing_feature [EXTRACTED 1.00]
- **Spatial Discovery UI Components** — spatial_awareness_feature, discovery_engine, radar_visualization [INFERRED 0.80]

## Communities

### Community 0 - "Windows Window Management"
Cohesion: 0.16
Nodes (16): Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle(), GetWindowClass(), MessageHandler(), OnCreate() (+8 more)

### Community 1 - "C++ Main Entry Points"
Cohesion: 0.14
Nodes (2): GetCommandLineArguments(), Utf8FromUtf16()

### Community 2 - "Core UI Components"
Cohesion: 0.14
Nodes (14): Active Status Indicator, App Header (Offchat), Bottom Navigation, Connect Action, Dark Mode Theme, Device Card, Discovery Screen, Distance Indicator Rings (25M, 50M) (+6 more)

### Community 3 - "Onboarding & Security Concepts"
Cohesion: 0.24
Nodes (11): Aurelian Noir Theme, Aurelian Security Protocol, Total Control Privacy Concept, Alias Management Feature, Discover Nearby Feature, Proximity Fencing Feature, Stealth Mode Feature, 7-Step Onboarding Flow (+3 more)

### Community 4 - "Discovery & Image Sharing"
Cohesion: 0.22
Nodes (11): Aurelian Noir Design System, Aurelian Security Protocol, Discovery Engine, 94 MB/s Status Badge, High-Quality Image Sharing, User Onboarding Flow (7 Steps), Onboarding Step 3: Image Sharing, Onboarding Step 4: Location Discovery Screen (+3 more)

### Community 5 - "macOS/iOS App Delegate"
Cohesion: 0.25
Nodes (3): AppDelegate, FlutterAppDelegate, FlutterImplicitEngineDelegate

### Community 6 - "Flutter Windows Integration"
Cohesion: 0.32
Nodes (0): 

### Community 7 - "Project Philosophy & Architecture"
Cohesion: 0.25
Nodes (8): Feature-First Architecture, The Digital Concierge Philosophy, Aurelian Noir Design System, CTU FEE, Prague, Off Chat Implementation Plan, 13-Byte Payload Structure, Hybrid Discovery Strategy, Off Chat Project

### Community 8 - "Profile & Identity UI"
Cohesion: 0.25
Nodes (8): Bottom Navigation Bar, Location Visibility Settings, Profile Screen (Identity), System Alerts Settings, Theme Mode Settings, User Profile (Avatar, Alex Sterling), Deep Noir Theme, Gilded Light Theme

### Community 9 - "Messaging & File Transfer"
Cohesion: 0.29
Nodes (7): message_screen_gold_v2/screen.png, Image Message Bubble, Message Input Area, Message Screen UI, Peer-to-peer File Transfer, Proximity Alert, Radar Connection Status

### Community 10 - "Branding & Splash Screen"
Cohesion: 0.33
Nodes (6): The Digital Concierge Tagline, OFFCHAT Application Title, Dark & Gold Color Palette, Travel & Communication Logo, Onboarding Splash Screen, Linear Loading Progress Bar

### Community 11 - "Plugin Registration"
Cohesion: 0.5
Nodes (2): GeneratedPluginRegistrant, -registerWithRegistry

### Community 12 - "Final Identity Setup"
Cohesion: 0.4
Nodes (5): Anonymous Identity Profile, Onboarding Step 7: Final Setup (Identity), Display Name Input Component, Finish Onboarding Button, Profile Picture Picker Component

### Community 13 - "Logo Design Concepts"
Cohesion: 0.6
Nodes (5): Airplanes, Central Smartphone Icon, Speech Bubbles, Off Chat Logo, Off-Grid Travel Communication Concept

### Community 14 - "Mesh Networking & Offline Messaging"
Cohesion: 0.6
Nodes (5): Offline Messaging, Peer-to-Peer Mesh Network, Onboarding Step 2: Offline Messaging Screen, Mesh-Grid Protocol, Step Indicator (Step 2 of 7)

### Community 15 - "Debugger Utilities"
Cohesion: 0.5
Nodes (2): handle_new_rx_page(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.

### Community 16 - "iOS Runner Tests"
Cohesion: 0.5
Nodes (2): RunnerTests, XCTestCase

### Community 17 - "macOS Window Management"
Cohesion: 0.5
Nodes (2): MainFlutterWindow, NSWindow

### Community 18 - "App Icons & Launcher"
Cohesion: 0.5
Nodes (3): Flutter Logo, ic_launcher.png (hdpi), ic_launcher.png (xxxhdpi)

### Community 19 - "iOS Scene Delegate"
Cohesion: 0.67
Nodes (2): FlutterSceneDelegate, SceneDelegate

### Community 20 - "Cross-platform App Icons"
Cohesion: 1.0
Nodes (3): iOS App Icon (Flutter Default), macOS App Icon (Flutter Default), Web App Icon (Flutter Default)

### Community 21 - "Android Main Activity"
Cohesion: 1.0
Nodes (1): MainActivity

### Community 22 - "Database & State Management"
Cohesion: 1.0
Nodes (2): Isar Database, Riverpod State Management

### Community 23 - "Android Build Config"
Cohesion: 1.0
Nodes (0): 

### Community 24 - "Project Settings"
Cohesion: 1.0
Nodes (0): 

### Community 25 - "iOS Bridging Header"
Cohesion: 1.0
Nodes (0): 

### Community 26 - "Radar Visualization"
Cohesion: 1.0
Nodes (1): Radar Location Visualization

### Community 27 - "Routing"
Cohesion: 1.0
Nodes (1): GoRouter

### Community 28 - "Discovery Tab"
Cohesion: 1.0
Nodes (1): Discovery Tab

### Community 29 - "Location Tab"
Cohesion: 1.0
Nodes (1): Location Tab

### Community 30 - "Messages Tab"
Cohesion: 1.0
Nodes (1): Messages Tab

### Community 31 - "Profile Tab"
Cohesion: 1.0
Nodes (1): Profile Tab

### Community 32 - "Android Launcher Icons (MDPI)"
Cohesion: 1.0
Nodes (1): ic_launcher.png (mdpi)

### Community 33 - "Android Launcher Icons (XHDPI)"
Cohesion: 1.0
Nodes (1): ic_launcher.png (xhdpi)

### Community 34 - "Android Launcher Icons (XXHDPI)"
Cohesion: 1.0
Nodes (1): ic_launcher.png (xxhdpi)

### Community 35 - "iOS App Icons (20x20 1x)"
Cohesion: 1.0
Nodes (0): 

### Community 36 - "iOS App Icons (20x20 2x)"
Cohesion: 1.0
Nodes (0): 

### Community 37 - "iOS App Icons (20x20 3x)"
Cohesion: 1.0
Nodes (0): 

### Community 38 - "iOS App Icons (29x29 1x)"
Cohesion: 1.0
Nodes (0): 

### Community 39 - "iOS App Icons (29x29 2x)"
Cohesion: 1.0
Nodes (0): 

### Community 40 - "iOS App Icons (29x29 3x)"
Cohesion: 1.0
Nodes (0): 

### Community 41 - "iOS App Icons (40x40 1x)"
Cohesion: 1.0
Nodes (0): 

### Community 42 - "iOS App Icons (40x40 2x)"
Cohesion: 1.0
Nodes (0): 

### Community 43 - "iOS App Icons (40x40 3x)"
Cohesion: 1.0
Nodes (0): 

### Community 44 - "iOS App Icons (60x60 2x)"
Cohesion: 1.0
Nodes (0): 

### Community 45 - "iOS App Icons (60x60 3x)"
Cohesion: 1.0
Nodes (0): 

### Community 46 - "iOS App Icons (76x76 1x)"
Cohesion: 1.0
Nodes (0): 

### Community 47 - "iOS Launch Images"
Cohesion: 1.0
Nodes (1): iOS Launch Image (Blank)

## Knowledge Gaps
- **60 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `Feature-First Architecture`, `Radar Location Visualization` (+55 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Android Main Activity`** (2 nodes): `MainActivity.kt`, `MainActivity`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database & State Management`** (2 nodes): `Isar Database`, `Riverpod State Management`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Android Build Config`** (1 nodes): `build.gradle.kts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Project Settings`** (1 nodes): `settings.gradle.kts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS Bridging Header`** (1 nodes): `Runner-Bridging-Header.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Radar Visualization`** (1 nodes): `Radar Location Visualization`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Routing`** (1 nodes): `GoRouter`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Discovery Tab`** (1 nodes): `Discovery Tab`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Location Tab`** (1 nodes): `Location Tab`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Messages Tab`** (1 nodes): `Messages Tab`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Profile Tab`** (1 nodes): `Profile Tab`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Android Launcher Icons (MDPI)`** (1 nodes): `ic_launcher.png (mdpi)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Android Launcher Icons (XHDPI)`** (1 nodes): `ic_launcher.png (xhdpi)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Android Launcher Icons (XXHDPI)`** (1 nodes): `ic_launcher.png (xxhdpi)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (20x20 1x)`** (1 nodes): `Icon-App-20x20@1x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (20x20 2x)`** (1 nodes): `Icon-App-20x20@2x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (20x20 3x)`** (1 nodes): `Icon-App-20x20@3x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (29x29 1x)`** (1 nodes): `Icon-App-29x29@1x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (29x29 2x)`** (1 nodes): `Icon-App-29x29@2x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (29x29 3x)`** (1 nodes): `Icon-App-29x29@3x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (40x40 1x)`** (1 nodes): `Icon-App-40x40@1x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (40x40 2x)`** (1 nodes): `Icon-App-40x40@2x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (40x40 3x)`** (1 nodes): `Icon-App-40x40@3x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (60x60 2x)`** (1 nodes): `Icon-App-60x60@2x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (60x60 3x)`** (1 nodes): `Icon-App-60x60@3x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS App Icons (76x76 1x)`** (1 nodes): `Icon-App-76x76@1x.png`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS Launch Images`** (1 nodes): `iOS Launch Image (Blank)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _60 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `C++ Main Entry Points` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._
- **Should `Core UI Components` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._
# Off Chat: A Decentralized Digital Concierge
### Bachelor Thesis Project | CTU FEE, Prague

**Off Chat** is an offline-first, peer-to-peer communication platform built with Flutter. It utilizes Bluetooth Low Energy (BLE) to enable device discovery, relative location tracking (Radar), and secure messaging without any reliance on internet or cellular connectivity.

This project was developed as part of a Bachelor Thesis at the **Czech Technical University in Prague (CTU), Faculty of Electrical Engineering (FEE)**.

---

## 🌟 Key Features

- **The Nodes (Discovery):** Real-time scanning of nearby active devices. Displays user profiles (avatar, alias) and proximity metadata.
- **The Radar (Location):** A custom-painted visualization showing the relative bearing and distance of peers using a combination of GPS coordinates and device compass data.
- **Off-Grid Messaging:** Reliable text and media exchange (images up to 512x512) over BLE GATT characteristics.
- **Identity Protocol:** Secure local profile management with automated image compression and background synchronization.
- **Aurelian Noir Aesthetic:** A premium "Digital Concierge" design system featuring deep black surfaces, gold primary accents, and fluid geometry.

---

## 🏗 Architecture

The project follows a **Feature-First Architecture**, ensuring high cohesion and low coupling between modules. Each feature is self-contained with its own Presentation, Domain, and Data layers.

```text
lib/src/
├── features/
│   ├── onboarding/   # Multi-step security & setup protocol
│   ├── discovery/    # BLE Scanning & Peer management
│   ├── location/     # Radar math, Compass, & UI Canvas
│   ├── profile/      # Local identity & Settings
│   └── chat/         # Messaging logic & Media chunking
├── core/
│   ├── routing/      # Reactive GoRouter with Onboarding protection
│   ├── theme/        # Centralized Aurelian Noir ThemeData
│   ├── database/     # Isar local persistence layer
│   └── notifications/# Local background alerts
└── app.dart          # Root Material application
```

---

## 🛰 The Off-Chat Protocol

To overcome standard BLE advertisement limits (31 bytes) and iOS background restrictions, this project implements a **Hybrid Discovery Strategy**:

### 1. The 13-Byte Payload
We pack essential metadata into a byte-level structure to fit within Manufacturer Data:
- **Byte 0:** Flags (Platform: Android/iOS, Visibility: Enabled/Disabled).
- **Bytes 1-4:** Profile Hash (Deterministic CRC32 of username/avatar).
- **Bytes 5-8:** Latitude (Float32).
- **Bytes 9-12:** Longitude (Float32).

### 2. Hybrid Strategy
- **Primary Advertisement:** Broadcasts only the Service UUID and essential flags to minimize packet size and maximize discovery reliability (especially for iOS background).
- **Scan Response:** The 13-byte custom metadata is moved to the Scan Response packet.
- **Local Name:** Disabled to free up primary advertisement bandwidth.
- **Background (iOS):** When Scan Response data is stripped by the OS, the app initiates a **silent GATT connection** to read the "Identity Characteristic," fetching the 13-byte payload before disconnecting.

---

## 🛠 Tech Stack & Dependencies

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (Generator & Annotation)
- **Navigation:** GoRouter
- **Database:** Isar (NoSQL)
- **Communication:** `flutter_blue_plus` (Client) & `ble_peripheral` (Server)
- **Permissions:** `permission_handler` (Runtime Android 12+ BLE/Location support)
- **Logging:** `logging` (Structured output for debugging)
- **Sensors:** `geolocator` (GPS) & `flutter_compass`
- **Design:** Google Fonts (Plus Jakarta Sans)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Two physical devices **OR** Android Emulators with **Netsim** enabled.
- Android 12+ (API 31) for full BLE Advertising/Scanning support.

### Installation
1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation (required for Riverpod and Isar):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Deploy to a device:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

### Multi-Emulator Testing (Netsim)
You can test BLE discovery and GATT sync locally using **Netsim** (Android Network Simulator):
1. Launch two Android emulators (API 31+).
2. Ensure Netsim is enabled in emulator settings.
3. Open the Netsim GUI: `http://localhost:7681/gui` to manage device proximity and signal strength.

### Continuous Integration
A GitHub Action is configured to build release artifacts on every push to `master`.
- **APK:** `off-chat-release.apk`
- **App Bundle:** `off-chat-release.aab`
Builds are pushed automatically to the `android` branch for deployment.

### Automated Checks
The project strictly follows Dart style guidelines (lowerCamelCase constants, no `print` in production).
Verify code quality and run tests:
```bash
flutter analyze
flutter test
```

---
**Author:** Student at CTU FEE, Prague
**Academic Year:** 2025/2026

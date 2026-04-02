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
- **Foreground:** Data is broadcasted via **Scan Response** packets. Peers read this instantly without connecting.
- **Background:** On iOS, when packets are stripped by the OS, the app detects the Service UUID and performs a **silent GATT connection** to read the "Identity Characteristic," fetching the 13-byte payload before disconnecting.
- **Media Transfer:** Images are compressed and transmitted in chunks sized to the negotiated MTU (Maximum Transmission Unit) to ensure integrity over low-bandwidth links.

---

## 🛠 Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (Generator & Annotation)
- **Navigation:** GoRouter
- **Database:** Isar (NoSQL)
- **Communication:** `flutter_blue_plus` (Client) & `flutter_ble_peripheral` (Server)
- **Sensors:** `geolocator` (GPS) & `flutter_compass`
- **Design:** Google Fonts (Plus Jakarta Sans)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Two physical devices (BLE cannot be fully tested on emulators)
- Location and Bluetooth permissions enabled

### Installation
1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Deploy to a physical device:
   ```bash
   flutter run
   ```

---

## 🧪 Verification

The project includes unit tests for the core mathematical and deterministic logic:
- **Radar Math:** Validates Haversine distance and bearing calculations.
- **Profile Utils:** Validates deterministic hashing for the BLE payload.

Run tests using:
```bash
flutter test
```

---
**Author:** Student at CTU FEE, Prague
**Academic Year:** 2025/2026

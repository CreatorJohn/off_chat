# Off Chat: A Decentralized Digital Concierge
### Bachelor Thesis Project | CTU FEE, Prague

**Off Chat** is an offline-first, peer-to-peer decentralized communication platform built with Flutter. It utilizes Bluetooth Low Energy (BLE) to enable instant device discovery, relative location tracking (Radar), and secure messaging without any reliance on internet, cellular connectivity, or central infrastructure.

This project was developed as part of a Bachelor Thesis in Open Informatics at the **Czech Technical University in Prague (CTU), Faculty of Electrical Engineering (FEE)**.

---

## 🌟 Key Features

### 📡 Zero-read Identification Protocol
- **Instant Discovery:** Avoids the high overhead of establishing GATT connections for simple identification. Nearby active devices are discovered and verified immediately upon capturing a single advertisement packet.
- **Cache-Hit Proximity:** If a peer's `stableId` is already cached locally and their `versionTag` hasn't changed, they are instantly visualized on the radar without any active radio transmission.

### 🗺️ Custom-Painted Location Radar
- **Relative Proximity Canvas:** A gorgeous, custom-painted radar visualization showing the relative bearing and distance of peers in real-time.
- **Sensor Fusion:** Merges high-precision GPS coordinates from the `geolocator` package with active compass data from `flutter_compass` to correctly rotate and render neighboring nodes relative to the user's orientation.

### ⚡ Dual-role Mesh Topography (Store & Forward)
- **Central + Peripheral:** Each device runs simultaneous BLE Central (scanning/connecting) and BLE Peripheral (advertising/serving) roles using coordinated asynchronous timers.
- **Background Persistence:** Utilizes a dedicated foreground service isolate on Android to ensure continuous mesh operations and location updates, even when the OS is under heavy memory pressure.

### 🛣️ Intelligent Mesh Routing Engines
- **Directed Beam Routing (Geographic LAR):** When geographic locations are available, the app calculates a weighted *Forwarding Score* based on angular deviation (bearing via sférická trigonometrie) and RSSI signal strength. Messages are selectively routed towards the destination, reducing radio traffic by up to 65%.
- **Starburst Routing (Flooding):** Used as a fallback when geographic data is unavailable. Floods the network with a strict 10-hop Time-To-Live (TTL) limit and duplicate message deduplication via local cache.
- **Breadcrumb ACK Tracking:** ACKs travel back along the reversed paths of the messages, updating delivery states deterministically.

### 🛡️ End-to-End Cryptography (Security Level 4)
- **Key Exchange:** Secure, local key exchange using **X25519 Diffie-Hellman** curves during first-contact synchronization.
- **Symmetric Encryption:** All subsequent message payloads are encrypted end-to-end using **ChaCha20-Poly1305 AEAD** to ensure confidentiality, integrity, and authenticity.

### 📦 Chunked Transfer Engine
- **Dynamic MTU Adaptation:** An abstract chunking protocol that dynamically resizes data chunks (from standard 23 bytes up to 512 bytes) based on MTU values negotiated during connection.
- **Profile Synchronization:** Seamlessly streams and reconstructs larger data files, such as custom profile pictures, over BLE GATT characteristics.

### 🎨 Aurelian Noir Aesthetics
- **Digital Concierge Style:** Premium dark UI designed to feel prestigious and elegant.
- **Visual Palette:** Deep obsidian black background surfaces (`#131313`) with subtle textures, radiant gold accents (`#F2CA50`), fluid glassmorphic cards, custom typography (Plus Jakarta Sans/Outfit), and smooth bento-grid layouts.

---

## 🏗 Architecture

The project follows a rigorous **Domain-Driven Design (DDD) Feature-First Architecture**, keeping features modular, highly cohesive, and loosely coupled.

```text
lib/src/
├── features/
│   ├── onboarding/   # Multi-step onboarding, profile setup & key generation
│   ├── discovery/    # BLE Discovery engine, scan loop, and Sync Queue
│   ├── location/     # Radar math, Compass sensors, & CustomPaint Canvas
│   ├── profile/      # Local identity, settings & System Health Bento Grid
│   └── chat/         # Messaging handler, encryption, & ChunkedTransferManager
├── core/
│   ├── routing/      # Reactive GoRouter with state guards
│   ├── theme/        # Centralized Aurelian Noir ThemeData & app tokens
│   ├── database/     # Isar local database collections (FoundDevice, Message, RelayTask)
│   └── notifications/# Background local notification service
└── app.dart          # Root Material application
```

---

## 🛰 The Off-Chat BLE Protocol

To overcome BLE advertisement limits (31 bytes) and iOS background constraints, Off Chat splits data transmission between the primary packet and the scan response.

### 1. Primary Advertisement Packet (Main Packet — Exactly 5 Bytes)
Packs critical identity data tightly at the byte-level:
- **Bytes 0-3:** `Stable Device ID` (32-bit big-endian unsigned integer).
- **Byte 4:** Combined byte consisting of:
  - **Bits 7-2 (6 bits):** `Version Tag` (First 6 bits of the Profile Hash) to detect profile changes instantly.
  - **Bit 1 (1 bit):** Platform Flag (`1` for iOS, `0` for Android).
  - **Bit 0 (1 bit):** Online Status Flag (`1` if acting as an Internet Bridge, `0` if offline).

### 2. Scan Response Packet (12 Bytes)
Dispatched only when requested by active scanners to conserve battery:
- **Bytes 0-2 (24 bits):** `Latitude` compressed to a 24-bit fixed-point integer.
- **Bytes 3-5 (24 bits):** `Longitude` compressed to a 24-bit fixed-point integer.
- **Bytes 6-11 (6 bytes):** `Full Profile Hash` for cryptographically verifying user identity.

### 3. iOS Background Fallback
iOS strips Manufacturer Data from advertisement packets when in the background. Off Chat handles this gracefully:
- When a background node is detected without manufacturer data, the Central node initiates a **silent GATT connection** to read the designated `identityCharUuid` characteristic.
- It extracts the same 5-byte and 12-byte metadata blocks and disconnects immediately, preserving battery.

### 4. Throttled Heartbeat (Energy Conservation)
Continuous scanning and advertising is resource-heavy. Off Chat utilizes **Adaptive Throttling**:
- **Stationary State:** If the user is sitting still, the advertiser sleeps and restarts advertising only every **300 seconds** (Heartbeat) to maintain connection tables.
- **Motion State:** When a change of **111 meters** or movement from physical sensors is detected, advertising rates instantly spike to maximum frequency to facilitate rapid handshake loops.

---

## 🛠 Tech Stack & Dependencies

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (Generator, Annotations, and AsyncNotifiers)
- **Database:** Isar (High-performance, asynchronous NoSQL database)
- **BLE Communication:** `flutter_blue_plus` (Central scanner) & `ble_peripheral` (Peripheral server)
- **Security:** `cryptography` (X25519 for key exchange, ChaCha20-Poly1305 for AEAD encryption)
- **Sensors:** `geolocator` (GPS coordinates) & `flutter_compass` (Compass heading)
- **Aesthetics:** Google Fonts (Outfit & Plus Jakarta Sans)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.11.1 or newer stable)
- Two physical Android/iOS devices (ideal for BLE testing) **OR** Android Emulators with **Netsim** configured.
- Android 12+ (API 31) for required Nearby Devices runtime permissions.

### Installation
1. Clone this repository.
2. Fetch Dart packages:
   ```bash
   flutter pub get
   ```
3. Generate required database schemas and Riverpod annotations:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

### 💻 Developer Console (In-App Terminal)
A hidden debug console is built directly into the UI for real-time mesh monitoring:
1. Navigate to the **Discovery (Home)** screen.
2. **Triple-tap** the `OFFCHAT` logo in the top AppBar.
3. A developer terminal overlay opens, showing the last 200 console logs with color-coded severity levels (Severe, Info, Warning).

### 🌐 Proximity Simulation (Netsim)
Test mesh routing and discovery on a single machine:
1. Launch two Android Emulators (API 31+).
2. Open the **Netsim GUI** in your browser: `http://localhost:7681/gui`
3. Drag the virtual devices closer or further apart to simulate RSSI changes, range limits, and connection handshakes.

### 🧹 Quality Checks & Verification
The project maintains absolute style guidelines. Check for linting issues and run tests:
```bash
flutter analyze
flutter test
```

---
**Author:** Student at CTU FEE, Prague
**Academic Year:** 2025/2026

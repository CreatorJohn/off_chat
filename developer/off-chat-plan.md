# Off Chat - Implementation Plan

## 1. Background & Motivation
"Off Chat" is a Flutter application designed for localized, off-grid communication and discovery using Bluetooth Low Energy (BLE). The app provides a high-end "Digital Concierge" experience featuring a discovery list, relative location radar, profile management, and BLE-based messaging. It operates independently of the internet.

## 2. Scope & Impact
The application will consist of the following core screens:
- **Discovery Screen:** List of nearby available devices (with profile picture, username, last discovered time).
- **Location Screen:** A "radar" view showing the current device in the center, and other devices positioned by their relative direction and distance (based on exchanged GPS coordinates and device compass). Only devices with location visibility enabled will be shown.
- **Profile Screen:** Manage user profile picture and name, toggle location visibility.
- **Messaging (Implicit):** Connect-on-demand messaging with local notifications.
- **Notifications:** Distinguishes between new messages from a first-time sender vs. an existing sender.

## 3. Tech Stack
- **Framework:** Flutter
- **State Management:** Riverpod (via `flutter_riverpod` and `riverpod_annotation`)
- **Routing:** Go Router (`go_router`)
- **Local Database:** Isar (`isar`, `isar_flutter_libs`)
- **BLE Client (Scanning/Connecting):** `flutter_blue_plus`
- **BLE Server (Advertising/Hosting Services):** `flutter_ble_peripheral`
- **Location & Compass:** `geolocator` (for GPS coordinates) and `flutter_compass` (for device bearing).
- **Image Compression:** `image_picker`, `flutter_image_compress` (target size: 128x128 or 256x256).
- **Background Execution:** `flutter_background_service` (for maintaining BLE operations in the background).
- **Notifications:** `flutter_local_notifications`.

## 4. Architecture & Data Flow
### 4.1. Feature-First Architecture
The project will follow a **Feature-First Architecture** to ensure scalability and maintainability. Each feature is self-contained and contains its own presentation, domain, and data layers.

**Directory Structure:**
```text
lib/
├── src/
│   ├── features/
│   │   ├── discovery/
│   │   │   ├── data/            # Repositories, Data Sources, Mappers
│   │   │   ├── domain/          # Models, Entities
│   │   │   └── presentation/    # Screens, Widgets, Controllers (Riverpod)
│   │   ├── location/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── chat/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   ├── core/                  # Common utilities, constants, shared widgets
│   │   ├── routing/           # Go Router configuration
│   │   ├── theme/             # Aurelian Noir theme definitions
│   │   └── database/          # Isar database initialization
│   └── app.dart               # Main MaterialApp.router setup
└── main.dart                  # Entry point (Riverpod ProviderScope)
```

### 4.1. BLE Communication Flow (Hybrid Background & Connect-on-Demand)
Due to BLE 31-byte advertisement limits and iOS background restrictions, the app uses a **Hybrid Discovery Strategy** using Primary and Scan Response packets:

- **Payload Structure (13 bytes):** 
  - `Byte 0`: Flags (Bit 0: Platform, Bit 1: Location Visibility).
  - `Bytes 1-4`: Profile Hash (CRC32 of username and profile picture).
  - `Bytes 5-8`: Latitude (Float32).
  - `Bytes 9-12`: Longitude (Float32).
- **Foreground Advertising:** The primary packet broadcasts the 128-bit Service UUID. The **Scan Response** packet broadcasts the 13-byte custom Manufacturer Data.
- **Background Advertising (iOS Limitation):** Apple strips the Scan Response and custom data. iOS devices in the background will only broadcast a generic Service UUID ping.
- **Discovery & Data Exchange:** 
  - If a device receives the Scan Response (target is in foreground), it updates the radar instantly.
  - If a device receives a "blank" ping (target is in background), it initiates a silent, split-second GATT connection to read an "Identity Characteristic" containing the same 13 bytes, then disconnects. A cooldown timer prevents battery drain from repeated connections.
- **Profile Picture/Messaging Transfer:** Requires a dedicated GATT connection. Images (compressed to 256x256) and text messages are chunked over the BLE MTU and reassembled by the receiver.

### 4.3. Location & Radar Logic
- **Data Acquisition:** Devices exchange their current GPS coordinates (latitude, longitude) over BLE if their "Location Visibility" is enabled.
- **Calculation:** The app calculates distance using the Haversine formula. Direction (bearing) is calculated using the two GPS points.
- **UI Rendering:** The local device's compass heading is combined with the calculated bearing to place the remote device accurately on the radar UI.

### 4.4. Database Schema (Isar)
- **User (Local):** `id`, `username`, `profilePicturePath`, `isLocationVisible`.
- **DiscoveredDevice:** `deviceId` (BLE MAC/UUID), `username`, `profilePicturePath`, `lastDiscovered`, `latitude`, `longitude`, `hasMessagedBefore`.
- **Message:** `id`, `senderId`, `receiverId`, `content`, `timestamp`, `isRead`.

### 4.5. UI/UX Design System (Aurelian Noir)
- Follow the "Gilded Noir" design: Deep black backgrounds (`#131313`), gold primary accents (`#f2ca50`), generous spacing (`spacing-12/16`), and fluid radii (`rounded-xl` / 2rem).
- No hard 1px borders; use surface shifts (e.g., `#1b1b1b` or `#2a2a2a`) to separate content.
- Use `Plus Jakarta Sans` for typography.

## 5. Implementation Phases

### Phase 1: Setup & Core Architecture
- Initialize Flutter project and add dependencies.
- Create feature-first directory structure (`lib/src/features/...`).
- Configure Go Router for Discovery, Location, Profile, and Chat screens.
- Setup Riverpod providers.
- Initialize Isar database and define schemas.
- Implement the "Aurelian Noir" centralized `ThemeData`.

### Phase 2: Profile & Local Settings
- Build Profile Screen UI.
- Implement image selection and compression (`flutter_image_compress` to ~256x256).
- Save profile data to Isar.

### Phase 3: BLE Advertising & Discovery
- Request required permissions (Bluetooth, Location, Background).
- Implement background service for continuous scanning and advertising.
- Setup `flutter_ble_peripheral` to broadcast device presence.
- Setup `flutter_blue_plus` to scan and list devices on the Discovery Screen.
- Implement basic connection and data chunking logic for fetching usernames and profile pictures from newly discovered devices.

### Phase 4: Messaging & Notifications
- Implement GATT characteristics for receiving text messages.
- Build the connect-on-demand logic: connect -> send message chunk -> disconnect.
- Setup `flutter_local_notifications`.
- Differentiate notifications logic (first-time sender vs known sender).
- Build the Chat UI.

### Phase 5: Location Radar
- Integrate `geolocator` and `flutter_compass`.
- Add BLE characteristic for requesting/sharing GPS coordinates.
- Build Location Screen "Radar" UI:
  - Calculate distance and bearing.
  - Apply compass rotation to the radar canvas.
  - Animate blips representing discovered devices.

### Phase 6: Polish & Verification
- Test background reliability and battery impact.
- Test BLE chunking speed for image transfers.
- Verify UI matches the "Gilded Noir" specs.

## 6. Verification & Testing
- **Unit Tests:** Verify distance/bearing mathematical logic.
- **Integration Tests:** Verify Isar database operations and Riverpod state updates.
- **Physical Device Testing:** BLE and Compass features *must* be tested on at least two physical devices (iOS/Android), as they cannot be fully simulated in emulators. Test connection stability during background mode and chunked image transfer integrity.

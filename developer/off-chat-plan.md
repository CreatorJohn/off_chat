# Off Chat - Implementation Plan (Updated 2026-04-18)

## 1. Background
BLE-based off-grid "Digital Concierge" for Flutter. Discovery, Radar, Profile, and Mesh Messaging.

## 2. Tech Stack
Flutter, Riverpod, Isar, GoRouter, `flutter_blue_plus`, `ble_peripheral`, `geolocator`, `flutter_compass`.

## 3. Core Architecture
- **Feature-First**: `features/discovery`, `features/location`, `features/profile`, `features/chat`.
- **Hybrid Discovery**: 13-byte Manufacturer Data (Foreground) + GATT Identity Sync (Background/iOS).
- **Radar**: Haversine/Bearing math + Compass rotation.

## 4. Implementation Status
- [x] Phase 1: Setup & Core (Riverpod, Isar, GoRouter, Theme).
- [x] Phase 2: Profile Screen & Persistence.
- [/] Phase 3: BLE Discovery & Advertising.
  - [x] Background Scanning/Advertising service.
  - [x] GATT Service Stability (addService guard/clearServices).
  - [x] Throttled Heartbeat (5 min / 111m move).
- [ ] Phase 4: Messaging & Notifications (GATT write protocol).
- [ ] Phase 5: Location Radar (Canvas UI + Math).
- [ ] Phase 6: Polish (iOS background sync verification, Battery).

## 5. Critical Constraints
- **BLE GATT**: Do NOT re-add services while advertising. Clear before re-adding if identity changed.
- **Heartbeat**: Restart advertising every 300s or 111m movement.
- **Background**: iOS strips scan response; fallback to silent GATT connection for identity sync.

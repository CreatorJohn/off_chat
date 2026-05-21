# Graph Report - lib  (2026-05-21)

## Corpus Check
- Corpus is ~29,315 words - fits in a single context window. You may not need a graph.

## Summary
- 441 nodes · 565 edges · 29 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Core Services|Core Services]]
- [[_COMMUNITY_Mesh Routing|Mesh Routing]]
- [[_COMMUNITY_App Entry & Lifecycle|App Entry & Lifecycle]]
- [[_COMMUNITY_Mesh Handshake Logic|Mesh Handshake Logic]]
- [[_COMMUNITY_Binary Packet Encoding|Binary Packet Encoding]]
- [[_COMMUNITY_Geo Utils & Radar|Geo Utils & Radar]]
- [[_COMMUNITY_Device Database Generated|Device Database Generated]]
- [[_COMMUNITY_Data Management|Data Management]]
- [[_COMMUNITY_Onboarding UI|Onboarding UI]]
- [[_COMMUNITY_Profile & Identity UI|Profile & Identity UI]]
- [[_COMMUNITY_System Health UI|System Health UI]]
- [[_COMMUNITY_Navigation & Routing|Navigation & Routing]]
- [[_COMMUNITY_Mesh Packet Types|Mesh Packet Types]]
- [[_COMMUNITY_App Providers|App Providers]]
- [[_COMMUNITY_Message Database Generated|Message Database Generated]]
- [[_COMMUNITY_Relay Task Database Generated|Relay Task Database Generated]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Database Providers|Database Providers]]
- [[_COMMUNITY_Profile Utilities|Profile Utilities]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 13 edges
2. `package:logging/logging.dart` - 13 edges
3. `dart:typed_data` - 12 edges
4. `package:riverpod_annotation/riverpod_annotation.dart` - 11 edges
5. `package:off_chat/src/core/theme/app_theme.dart` - 10 edges
6. `_` - 10 edges
7. `dart:async` - 9 edges
8. `package:flutter_riverpod/flutter_riverpod.dart` - 8 edges
9. `package:off_chat/src/core/database/isar_service.dart` - 8 edges
10. `package:isar_community/isar.dart` - 8 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities

### Community 0 - "Core Services"
Cohesion: 0.04
Nodes (61): dart:async, dart:convert, dart:ui, NotificationService, onStart, NotificationService, _addLog, clearLogs (+53 more)

### Community 1 - "Mesh Routing"
Cohesion: 0.05
Nodes (36): calculateScore, DirectedBeamRouter, MeshRouter, shouldRelayToPeer, StarburstRouter, AnimatedBuilder, build, _buildDeviceCard (+28 more)

### Community 2 - "App Entry & Lifecycle"
Cohesion: 0.06
Nodes (29): main, NotificationService, build, didChangeAppLifecycleState, dispose, initState, OffChatApp, _OffChatAppState (+21 more)

### Community 3 - "Mesh Handshake Logic"
Cohesion: 0.07
Nodes (26): FoundDevice, Message, RelayTask, addNeighborToBreadcrumb, clearWaitingForImage, completeSync, completeSyncWithError, dropBreadcrumb (+18 more)

### Community 4 - "Binary Packet Encoding"
Cohesion: 0.07
Nodes (26): dart:typed_data, decodeCoordinate, encodeCoordinate, encodeLocation, encodeMainPacket, encodeScanResponseManufacturerData, MeshPacketEncoder, ChunkedTransferManager (+18 more)

### Community 5 - "Geo Utils & Radar"
Cohesion: 0.08
Nodes (24): dart:math, calculateBearing, calculateDistance, GeoUtils, build, _buildCenterAnchor, _buildDeviceBlip, _buildDistanceLabel (+16 more)

### Community 6 - "Device Database Generated"
Cohesion: 0.09
Nodes (21): deleteAllByIndex, deleteAllByIndexSync, deleteAllByStableIdSync, deleteByIndex, deleteByIndexSync, deleteByStableIdSync, _foundDeviceAttach, _foundDeviceDeserialize (+13 more)

### Community 7 - "Data Management"
Cohesion: 0.1
Nodes (19): dart:io, Duration, Exception, IsarService, ChatController, IsarService, ProfileManager, saveProfilePicture (+11 more)

### Community 8 - "Onboarding UI"
Cohesion: 0.1
Nodes (20): build, _buildFinalStep, _buildFooter, _buildPageIndicator, _buildSplashStep, _buildStep, Center, Container (+12 more)

### Community 9 - "Profile & Identity UI"
Cohesion: 0.11
Nodes (18): build, _buildIdentityCard, _buildSettingCard, _buildSubSettingCard, Container, CustomScrollView, dispose, initState (+10 more)

### Community 10 - "System Health UI"
Cohesion: 0.12
Nodes (16): build, SystemHealth, SystemHealthState, build, Container, _HealthItem, IconButton, Padding (+8 more)

### Community 11 - "Navigation & Routing"
Cohesion: 0.12
Nodes (15): build, _calculateSelectedIndex, ChatScreen, GoRouter, _onItemTapped, router, Scaffold, ScaffoldWithNavBar (+7 more)

### Community 12 - "Mesh Packet Types"
Cohesion: 0.13
Nodes (14): AckPacket, Exception, IdentityPacket, ImagePacket, MeshPacket, NotificationService, PacketContext, parse (+6 more)

### Community 13 - "App Providers"
Cohesion: 0.25
Nodes (9): _, build, create, debugGetCreateSourceHash, isServiceRunning, overrideWithValue, runBuild, scanProgress (+1 more)

### Community 14 - "Message Database Generated"
Cohesion: 0.29
Nodes (6): IsarError, _messageAttach, _messageDeserialize, _messageEstimateSize, _messageGetId, _messageSerialize

### Community 15 - "Relay Task Database Generated"
Cohesion: 0.29
Nodes (6): IsarError, _relayTaskAttach, _relayTaskDeserialize, _relayTaskEstimateSize, _relayTaskGetId, _relayTaskSerialize

### Community 16 - "Community 16"
Cohesion: 0.4
Nodes (6): _, build, create, debugGetCreateSourceHash, overrideWithValue, runBuild

### Community 17 - "Community 17"
Cohesion: 0.4
Nodes (6): _, call, create, debugGetCreateSourceHash, runBuild, toString

### Community 18 - "Community 18"
Cohesion: 0.4
Nodes (6): _, build, create, debugGetCreateSourceHash, overrideWithValue, runBuild

### Community 19 - "Community 19"
Cohesion: 0.4
Nodes (4): create, debugGetCreateSourceHash, notificationService, overrideWithValue

### Community 20 - "Community 20"
Cohesion: 0.4
Nodes (4): create, debugGetCreateSourceHash, overrideWithValue, router

### Community 21 - "Community 21"
Cohesion: 0.67
Nodes (4): _, create, debugGetCreateSourceHash, runBuild

### Community 22 - "Community 22"
Cohesion: 0.67
Nodes (4): _, create, debugGetCreateSourceHash, runBuild

### Community 23 - "Community 23"
Cohesion: 0.67
Nodes (4): _, create, debugGetCreateSourceHash, runBuild

### Community 24 - "Community 24"
Cohesion: 0.67
Nodes (4): _, create, debugGetCreateSourceHash, runBuild

### Community 25 - "Database Providers"
Cohesion: 0.67
Nodes (2): debugGetCreateSourceHash, isarDatabase

### Community 26 - "Profile Utilities"
Cohesion: 0.67
Nodes (2): generateProfileHash, ProfileUtils

### Community 27 - "Community 27"
Cohesion: 1.0
Nodes (1): MeshConstants

### Community 28 - "Community 28"
Cohesion: 1.0
Nodes (1): title

## Knowledge Gaps
- **340 isolated node(s):** `main`, `NotificationService`, `package:off_chat/src/app.dart`, `OffChatApp`, `_OffChatAppState` (+335 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 27`** (2 nodes): `constants.dart`, `MeshConstants`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 28`** (2 nodes): `extensions.dart`, `title`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `dart:typed_data` connect `Binary Packet Encoding` to `Core Services`, `Mesh Routing`, `Mesh Handshake Logic`, `Geo Utils & Radar`, `Data Management`, `Onboarding UI`, `Mesh Packet Types`?**
  _High betweenness centrality (0.105) - this node is a cross-community bridge._
- **Why does `package:flutter/material.dart` connect `App Entry & Lifecycle` to `Mesh Routing`, `Binary Packet Encoding`, `Geo Utils & Radar`, `Data Management`, `Onboarding UI`, `Profile & Identity UI`, `System Health UI`, `Navigation & Routing`?**
  _High betweenness centrality (0.090) - this node is a cross-community bridge._
- **Why does `package:logging/logging.dart` connect `Core Services` to `App Entry & Lifecycle`, `Mesh Handshake Logic`, `Binary Packet Encoding`, `Data Management`, `Navigation & Routing`, `Mesh Packet Types`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **What connects `main`, `NotificationService`, `package:off_chat/src/app.dart` to the rest of the system?**
  _340 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Core Services` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Mesh Routing` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `App Entry & Lifecycle` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
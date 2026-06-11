// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchFoundDevices)
final watchFoundDevicesProvider = WatchFoundDevicesProvider._();

final class WatchFoundDevicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FoundDevice>>,
          List<FoundDevice>,
          Stream<List<FoundDevice>>
        >
    with
        $FutureModifier<List<FoundDevice>>,
        $StreamProvider<List<FoundDevice>> {
  WatchFoundDevicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchFoundDevicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchFoundDevicesHash();

  @$internal
  @override
  $StreamProviderElement<List<FoundDevice>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FoundDevice>> create(Ref ref) {
    return watchFoundDevices(ref);
  }
}

String _$watchFoundDevicesHash() => r'cf2c1ad4bdcc8f7857a90062bd36aef4c6b91bbd';

@ProviderFor(watchDevice)
final watchDeviceProvider = WatchDeviceFamily._();

final class WatchDeviceProvider
    extends
        $FunctionalProvider<
          AsyncValue<FoundDevice?>,
          FoundDevice?,
          Stream<FoundDevice?>
        >
    with $FutureModifier<FoundDevice?>, $StreamProvider<FoundDevice?> {
  WatchDeviceProvider._({
    required WatchDeviceFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchDeviceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchDeviceHash();

  @override
  String toString() {
    return r'watchDeviceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<FoundDevice?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<FoundDevice?> create(Ref ref) {
    final argument = this.argument as int;
    return watchDevice(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchDeviceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchDeviceHash() => r'cd1b35a7f1b7e71f4b67be06623a8ad38dcdabec';

final class WatchDeviceFamily extends $Family
    with $FunctionalFamilyOverride<Stream<FoundDevice?>, int> {
  WatchDeviceFamily._()
    : super(
        retry: null,
        name: r'watchDeviceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchDeviceProvider call(int stableId) =>
      WatchDeviceProvider._(argument: stableId, from: this);

  @override
  String toString() => r'watchDeviceProvider';
}

@ProviderFor(DiscoveryController)
final discoveryControllerProvider = DiscoveryControllerProvider._();

final class DiscoveryControllerProvider
    extends $StreamNotifierProvider<DiscoveryController, List<FoundDevice>> {
  DiscoveryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryControllerHash();

  @$internal
  @override
  DiscoveryController create() => DiscoveryController();
}

String _$discoveryControllerHash() =>
    r'f736fa6eddfbab73561b09427ae4b53e5a088106';

abstract class _$DiscoveryController
    extends $StreamNotifier<List<FoundDevice>> {
  Stream<List<FoundDevice>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FoundDevice>>, List<FoundDevice>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FoundDevice>>, List<FoundDevice>>,
              AsyncValue<List<FoundDevice>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

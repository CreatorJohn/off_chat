// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'ebffedb768b587cd34a387f6fe2dba730b758d97';

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

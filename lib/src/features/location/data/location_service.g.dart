// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends $StreamNotifierProvider<LocationService, LocationData> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  LocationService create() => LocationService();
}

String _$locationServiceHash() => r'0e277dfb016610b68af864ce1f63dade813de13d';

abstract class _$LocationService extends $StreamNotifier<LocationData> {
  Stream<LocationData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LocationData>, LocationData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LocationData>, LocationData>,
              AsyncValue<LocationData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RadarController)
final radarControllerProvider = RadarControllerProvider._();

final class RadarControllerProvider
    extends $NotifierProvider<RadarController, RadarState> {
  RadarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radarControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radarControllerHash();

  @$internal
  @override
  RadarController create() => RadarController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RadarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RadarState>(value),
    );
  }
}

String _$radarControllerHash() => r'f52ac46eee30b0330f15490a4c7ce1f870b7d48f';

abstract class _$RadarController extends $Notifier<RadarState> {
  RadarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RadarState, RadarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RadarState, RadarState>,
              RadarState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

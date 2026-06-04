import 'package:cliceat_app/core/network/models/platform_config_model.dart';
import 'package:cliceat_app/core/network/repositories/platform_repository.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'config_bloc.freezed.dart';

@freezed
class ConfigEvent with _$ConfigEvent {
  const factory ConfigEvent.fetchConfig() = _FetchConfig;
}

@freezed
class ConfigState with _$ConfigState {
  const factory ConfigState.initial() = _Initial;
  const factory ConfigState.loading() = _Loading;
  const factory ConfigState.loaded(PlatformConfigModel config) = _Loaded;
  const factory ConfigState.error(String message) = _Error;
}

@lazySingleton
class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final PlatformRepository _repository;

  ConfigBloc(this._repository) : super(const ConfigState.initial()) {
    on<_FetchConfig>((event, emit) async {
      emit(const ConfigState.loading());
      final result = await _repository.getConfig();
      result.fold(
        (error) => emit(ConfigState.error(error.message)),
        (config) => emit(ConfigState.loaded(config)),
      );
    });
  }

  bool isFeatureEnabled(String featureKey) {
    return state.maybeWhen(
      loaded: (config) => FeatureFlags.isEnabled(config.features, featureKey),
      orElse: () => false,
    );
  }
}

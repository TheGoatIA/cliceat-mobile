import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/banner_model.dart';

part 'banner_state.freezed.dart';

@freezed
class BannerState with _$BannerState {
  const factory BannerState.initial() = _Initial;
  const factory BannerState.loading() = _Loading;
  const factory BannerState.loaded({required List<BannerModel> banners}) = _Loaded;
  const factory BannerState.error(String message) = _Error;
}

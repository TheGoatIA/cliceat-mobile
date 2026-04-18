import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/banner_repository.dart';
import 'banner_state.dart';

@injectable
class BannerCubit extends Cubit<BannerState> {
  final BannerRepository _repository;

  BannerCubit(this._repository) : super(const BannerState.initial());

  Future<void> loadBanners() async {
    emit(const BannerState.loading());
    final res = await _repository.getBanners();
    res.fold(
      (err) => emit(BannerState.error(err.message)),
      (banners) => emit(BannerState.loaded(banners: banners)),
    );
  }
}

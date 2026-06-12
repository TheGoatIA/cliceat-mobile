import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/banner/data/models/banner_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:cliceat_app/features/client/banner/data/repositories/banner_repository.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadData(String city) async {
    await Future.wait([loadRestaurants(city), loadBanners()]);
  }

  Future<void> loadRestaurants(String city) async {
    emit(state.copyWith(loadingRestaurants: true));
    final trace = FirebasePerformance.instance.newTrace('restaurant_list_load');
    await trace.start();
    trace.putAttribute('city', city);
    try {
      final cityResult = await getIt<RestaurantRepository>().getRestaurants(
        city: city,
      );

      List<RestaurantModel> restaurants = [];
      cityResult.fold((_) {}, (list) => restaurants = list);

      if (restaurants.isEmpty) {
        final featuredResult = await getIt<RestaurantRepository>()
            .getFeaturedRestaurants(city);
        featuredResult.fold((_) {}, (list) => restaurants = list);
      }

      emit(state.copyWith(restaurants: restaurants, loadingRestaurants: false));
    } catch (e, s) {
      debugPrint('[HomeCubit] loadRestaurants error: $e\n$s');
      emit(state.copyWith(loadingRestaurants: false));
    } finally {
      await trace.stop();
    }
  }

  Future<void> loadBanners() async {
    emit(state.copyWith(loadingBanners: true));
    try {
      final result = await getIt<BannerRepository>().getBanners();
      result.fold(
        (_) => emit(state.copyWith(loadingBanners: false)),
        (banners) =>
            emit(state.copyWith(banners: banners, loadingBanners: false)),
      );
    } catch (e, s) {
      debugPrint('[HomeCubit] loadBanners error: $e\n$s');
      emit(state.copyWith(loadingBanners: false));
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    emit(state.copyWith(loadingRestaurants: true));
    try {
      final result = await getIt<RestaurantRepository>().search(query.trim());
      result.fold(
        (_) => emit(state.copyWith(loadingRestaurants: false)),
        (restaurants) => emit(
          state.copyWith(restaurants: restaurants, loadingRestaurants: false),
        ),
      );
    } catch (e, s) {
      debugPrint('[HomeCubit] search error: $e\n$s');
      emit(state.copyWith(loadingRestaurants: false));
    }
  }
}

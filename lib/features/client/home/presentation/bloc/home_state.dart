part of 'home_cubit.dart';

class HomeState {
  final List<RestaurantModel> restaurants;
  final List<BannerModel> banners;
  final bool loadingRestaurants;
  final bool loadingBanners;

  const HomeState({
    this.restaurants = const [],
    this.banners = const [],
    this.loadingRestaurants = true,
    this.loadingBanners = true,
  });

  HomeState copyWith({
    List<RestaurantModel>? restaurants,
    List<BannerModel>? banners,
    bool? loadingRestaurants,
    bool? loadingBanners,
  }) {
    return HomeState(
      restaurants: restaurants ?? this.restaurants,
      banners: banners ?? this.banners,
      loadingRestaurants: loadingRestaurants ?? this.loadingRestaurants,
      loadingBanners: loadingBanners ?? this.loadingBanners,
    );
  }
}

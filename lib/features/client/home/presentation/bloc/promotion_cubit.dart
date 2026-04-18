import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/features/client/home/data/repositories/promotion_repository.dart';

part 'promotion_state.dart';
part 'promotion_cubit.freezed.dart';

@injectable
class PromotionCubit extends Cubit<PromotionState> {
  final PromotionRepository _repository;

  PromotionCubit(this._repository) : super(const PromotionState.initial());

  Future<void> loadGlobalPromotions() async {
    emit(const PromotionState.loading());
    final result = await _repository.getActivePromotions();
    result.fold(
      (err) => emit(PromotionState.error(err.message)),
      (promos) => emit(PromotionState.loaded(promos)),
    );
  }

  Future<void> loadRestaurantPromotions(String restaurantId) async {
    emit(const PromotionState.loading());
    final result = await _repository.getRestaurantPromotions(restaurantId);
    result.fold(
      (err) => emit(PromotionState.error(err.message)),
      (promos) => emit(PromotionState.loaded(promos)),
    );
  }
}

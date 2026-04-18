import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/referral_repository.dart';
import 'referral_state.dart';

@injectable
class ReferralCubit extends Cubit<ReferralState> {
  final ReferralRepository _repository;

  ReferralCubit(this._repository) : super(const ReferralState.initial());

  Future<void> loadStats() async {
    emit(const ReferralState.loading());
    final res = await _repository.getStats();
    res.fold(
      (err) => emit(ReferralState.error(err.message)),
      (stats) => emit(ReferralState.loaded(stats: stats)),
    );
  }

  Future<void> applyCode(String code) async {
    emit(const ReferralState.loading());
    final res = await _repository.applyCode(code);
    res.fold(
      (err) {
        emit(ReferralState.error(err.message));
        loadStats(); // reload stats after error
      },
      (_) {
        emit(const ReferralState.codeApplied());
        loadStats();
      },
    );
  }
}

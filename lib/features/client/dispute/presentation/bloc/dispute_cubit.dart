import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/features/client/dispute/data/repositories/dispute_repository.dart';

part 'dispute_state.dart';
part 'dispute_cubit.freezed.dart';

@injectable
class DisputeCubit extends Cubit<DisputeState> {
  final DisputeRepository _repository;

  DisputeCubit(this._repository) : super(const DisputeState.initial());

  Future<void> loadDisputes() async {
    emit(const DisputeState.loading());
    final result = await _repository.getMyDisputes();
    result.fold(
      (err) => emit(DisputeState.error(err.message)),
      (disputes) => emit(DisputeState.loaded(disputes)),
    );
  }

  Future<void> submitDispute({
    required String orderId,
    required String reason,
    required String description,
    List<File>? images,
  }) async {
    emit(const DisputeState.loading());
    final result = await _repository.createDispute(
      orderId: orderId,
      reason: reason,
      description: description,
      images: images,
    );
    result.fold(
      (err) => emit(DisputeState.error(err.message)),
      (_) => emit(const DisputeState.success()),
    );
  }
}

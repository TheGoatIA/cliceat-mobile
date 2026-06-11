import 'dart:io';
import 'package:dartz/dartz.dart' show Either;
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;

  ProfileCubit(this._userRepository) : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());
    final trace = FirebasePerformance.instance.newTrace('profile_load');
    await trace.start();
    try {
      final result = await _userRepository.getProfile();
      result.fold(
        (error) => emit(ProfileState.error(error.message)),
        (user) => emit(ProfileState.loaded(user)),
      );
    } finally {
      await trace.stop();
    }
  }

  Future<Either<AppError, UserModel>> updateProfile(Map<String, dynamic> data) async {
    emit(const ProfileState.loading());
    final result = await _userRepository.updateProfile(data);
    result.fold(
      (error) => emit(ProfileState.error(error.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
    return result;
  }

  void emitLoaded(UserModel user) {
    emit(ProfileState.loaded(user));
  }

  Future<void> updateAvatar(File file) async {
    emit(const ProfileState.loading());
    final result = await _userRepository.updateProfilePhoto(file);
    result.fold(
      (error) => emit(ProfileState.error(error.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  void clear() {
    emit(const ProfileState.initial());
  }
}

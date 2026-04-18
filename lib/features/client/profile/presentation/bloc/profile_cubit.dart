import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;

  ProfileCubit(this._userRepository) : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());
    final result = await _userRepository.getProfile();
    result.fold(
      (error) => emit(ProfileState.error(error.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(const ProfileState.loading());
    final result = await _userRepository.updateProfile(data);
    result.fold(
      (error) => emit(ProfileState.error(error.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }
}

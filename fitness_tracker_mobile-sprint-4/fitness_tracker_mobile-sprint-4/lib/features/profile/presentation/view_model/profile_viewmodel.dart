import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:fitness_tracker/features/profile/domain/usecases/update_my_profile_usecase.dart';
import 'package:fitness_tracker/features/profile/presentation/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetMyProfileUsecase _getMyProfileUsecase;
  late final UpdateMyProfileUsecase _updateMyProfileUsecase;

  @override
  ProfileState build() {
    _getMyProfileUsecase = ref.read(getMyProfileUsecaseProvider);
    _updateMyProfileUsecase = ref.read(updateMyProfileUsecaseProvider);
    return const ProfileState();
  }

  Future<void> getMyProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _getMyProfileUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (profile) => state = state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
      ),
    );
  }

  Future<void> updateMyProfile(ProfileEntity profile) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _updateMyProfileUsecase(profile);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (updatedProfile) => state = state.copyWith(
        status: ProfileStatus.success,
        profile: updatedProfile,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

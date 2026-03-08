import 'package:fitness_tracker/features/workout/domain/usecases/get_my_plans_usecase.dart';
import 'package:fitness_tracker/features/workout/domain/usecases/get_public_plans_usecase.dart';
import 'package:fitness_tracker/features/workout/presentation/state/workout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutViewModelProvider = NotifierProvider<WorkoutViewModel, WorkoutState>(
  WorkoutViewModel.new,
);

class WorkoutViewModel extends Notifier<WorkoutState> {
  late final GetMyPlansUsecase _getMyPlansUsecase;
  late final GetPublicPlansUsecase _getPublicPlansUsecase;

  @override
  WorkoutState build() {
    _getMyPlansUsecase = ref.read(getMyPlansUsecaseProvider);
    _getPublicPlansUsecase = ref.read(getPublicPlansUsecaseProvider);
    return const WorkoutState();
  }

  Future<void> fetchMyPlans() async {
    state = state.copyWith(myPlansStatus: WorkoutStatus.loading);
    final result = await _getMyPlansUsecase();
    result.fold(
      (failure) => state = state.copyWith(myPlansStatus: WorkoutStatus.error, errorMessage: failure.message),
      (plans) => state = state.copyWith(myPlansStatus: WorkoutStatus.success, myPlans: plans),
    );
  }

  Future<void> fetchPublicPlans() async {
    state = state.copyWith(publicPlansStatus: WorkoutStatus.loading);
    final result = await _getPublicPlansUsecase();
    result.fold(
      (failure) => state = state.copyWith(publicPlansStatus: WorkoutStatus.error, errorMessage: failure.message),
      (plans) => state = state.copyWith(publicPlansStatus: WorkoutStatus.success, publicPlans: plans),
    );
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchMyPlans(), fetchPublicPlans()]);
  }
}


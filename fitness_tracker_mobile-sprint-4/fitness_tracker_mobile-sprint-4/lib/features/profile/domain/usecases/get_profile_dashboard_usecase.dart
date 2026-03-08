import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_tracker/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProfileDashboardUsecaseProvider = Provider<GetProfileDashboardUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileDashboardUsecase(repository);
});

class GetProfileDashboardUsecase {
  final IProfileRepository _repository;

  GetProfileDashboardUsecase(this._repository);

  Future<Either<Failure, ProfileDashboardEntity>> call() async {
    return await _repository.getDashboard();
  }
}

import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_tracker/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyProfileUsecaseProvider = Provider<GetMyProfileUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetMyProfileUsecase(repository);
});

class GetMyProfileUsecase {
  final IProfileRepository _repository;

  GetMyProfileUsecase(this._repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await _repository.getMyProfile();
  }
}

import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_tracker/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logBodyMetricUsecaseProvider = Provider<LogBodyMetricUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return LogBodyMetricUsecase(repository);
});

class LogBodyMetricUsecase {
  final IProfileRepository _repository;

  LogBodyMetricUsecase(this._repository);

  Future<Either<Failure, BodyMetricEntity>> call(BodyMetricEntity metric) async {
    return await _repository.logBodyMetric(metric);
  }
}

import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:fitness_tracker/features/analytics/domain/entities/analytics_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getDashboardUsecaseProvider = Provider<GetDashboardUsecase>((ref) {
  final repo = ref.read(analyticsRepositoryProvider);
  return GetDashboardUsecase(repo);
});

class GetDashboardUsecase {
  final IAnalyticsRepository _repository;

  GetDashboardUsecase(this._repository);

  Future<Either<Failure, AnalyticsDashboardEntity>> call() async {
    return await _repository.getDashboard();
  }
}

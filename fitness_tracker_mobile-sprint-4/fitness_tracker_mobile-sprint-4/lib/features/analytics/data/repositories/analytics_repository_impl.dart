import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'package:fitness_tracker/features/analytics/domain/entities/analytics_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAnalyticsRepository {
  Future<Either<Failure, AnalyticsDashboardEntity>> getDashboard();
}

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  final remoteDatasource = ref.read(analyticsRemoteDatasourceProvider);
  return AnalyticsRepositoryImpl(remoteDatasource);
});

class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  final IAnalyticsRemoteDatasource _remoteDatasource;

  AnalyticsRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, AnalyticsDashboardEntity>> getDashboard() async {
    try {
      final dashboard = await _remoteDatasource.getDashboard();
      return Right(dashboard);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> updateMyProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileDashboardEntity>> getDashboard();
  Future<Either<Failure, BodyMetricEntity>> logBodyMetric(BodyMetricEntity metric);
}

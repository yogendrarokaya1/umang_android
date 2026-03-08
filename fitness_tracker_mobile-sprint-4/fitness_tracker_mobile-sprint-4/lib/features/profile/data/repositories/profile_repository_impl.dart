import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:fitness_tracker/features/profile/data/models/profile_model.dart';
import 'package:fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_tracker/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final remoteDatasource = ref.read(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(remoteDatasource);
});

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    try {
      final profile = await _remoteDatasource.getMyProfile();
      return Right(profile);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateMyProfile(ProfileEntity profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      final updatedProfile = await _remoteDatasource.updateMyProfile(model.toJson());
      return Right(updatedProfile);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileDashboardEntity>> getDashboard() async {
    try {
      final dashboard = await _remoteDatasource.getDashboard();
      return Right(dashboard);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BodyMetricEntity>> logBodyMetric(BodyMetricEntity metric) async {
    try {
      final model = BodyMetricModel.fromEntity(metric);
      final loggedMetric = await _remoteDatasource.logBodyMetric(model.toJson());
      return Right(loggedMetric);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}

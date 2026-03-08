import 'package:dartz/dartz.dart';
import 'package:fitness_tracker/core/error/failures.dart';
import 'package:fitness_tracker/features/auth/data/datasources/auth_datasource.dart';
import 'package:fitness_tracker/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:fitness_tracker/features/auth/data/models/auth_hive_model.dart';
import 'package:fitness_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:fitness_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;

  AuthRepository({required IAuthDataSource authDatasource})
    : _authDataSource = authDatasource;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    try {
      final authModel = AuthHiveModel(
        authId: '', // Remote creates this
        fullName: user.fullName,
        email: user.email,
        username: user.username,
        password: user.password,
        profilePicture: user.profilePicture,
      );
      await _authDataSource.register(authModel);
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    try {
      final model = await _authDataSource.login(email, password);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(ApiFailure(message: "Invalid email or password"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authDataSource.getCurrentUser();
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(ApiFailure(message: "No user logged in"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(ApiFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}

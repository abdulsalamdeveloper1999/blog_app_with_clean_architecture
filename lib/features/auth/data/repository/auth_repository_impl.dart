import 'package:blog_clean_architecture/core/constants/app_constants.dart';
import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/core/common/network/connection_checker.dart';
import 'package:blog_clean_architecture/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:blog_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImp({
    required this.connectionChecker,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (!await (connectionChecker.isConnected)) {
      final session = authRemoteDataSource.currentUserSession;
      if (session == null) {
        return left(Failure('User not logged In'));
      }
      return right(
        UserModel(
          id: session.user.id,
          email: session.user.email!,
          name: 'name',
        ),
      );
    }

    try {
      final user = await authRemoteDataSource.getCurrentUser();
      if (user == null) {
        return left(Failure('User not logged In'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signupWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, UserEntity>> _getUser(
    Future<UserEntity> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(AppConstants.noConnectionErrorMessage));
      }

      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}

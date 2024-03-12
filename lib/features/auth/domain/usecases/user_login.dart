import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usercase/usecase.dart';

class UserLogin implements UseCase<UserEntity, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}

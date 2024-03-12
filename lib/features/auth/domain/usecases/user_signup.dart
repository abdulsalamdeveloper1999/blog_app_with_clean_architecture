import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/core/usercase/usecase.dart';
import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<UserEntity, UserSignupParams> {
  final AuthRepository authRepository;

  UserSignUp({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(UserSignupParams params) async {
    return await authRepository.signupWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String password;

  UserSignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

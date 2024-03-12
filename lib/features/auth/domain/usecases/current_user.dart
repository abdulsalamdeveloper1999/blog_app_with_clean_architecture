import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/core/usercase/usecase.dart';
import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}

class NoParams {}

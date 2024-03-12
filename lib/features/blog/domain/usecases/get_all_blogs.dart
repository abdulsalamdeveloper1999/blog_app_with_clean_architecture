import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_clean_architecture/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usercase/usecase.dart';

class GetAllBlogs implements UseCase<List<BlogEntity>, BlogNoParams> {
  final BlogRepository blogRepository;

  GetAllBlogs({required this.blogRepository});

  @override
  Future<Either<Failure, List<BlogEntity>>> call(BlogNoParams params) async {
    return await blogRepository.getBlogs();
  }
}

class BlogNoParams {}

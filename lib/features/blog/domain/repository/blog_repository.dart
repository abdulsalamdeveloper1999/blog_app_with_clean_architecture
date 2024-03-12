import 'dart:io';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File img,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<BlogEntity>>> getBlogs();
}

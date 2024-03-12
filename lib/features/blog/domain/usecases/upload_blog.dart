import 'dart:io';

import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/core/usercase/usecase.dart';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_clean_architecture/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<BlogEntity, BlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});
  @override
  Future<Either<Failure, BlogEntity>> call(BlogParams params) async {
    return await blogRepository.uploadBlog(
      img: params.img,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class BlogParams {
  final File img;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  BlogParams({
    required this.img,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

import 'dart:io';

import 'package:blog_clean_architecture/core/common/network/connection_checker.dart';
import 'package:blog_clean_architecture/core/error/exceptions.dart';
import 'package:blog_clean_architecture/core/error/failures.dart';
import 'package:blog_clean_architecture/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_clean_architecture/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_clean_architecture/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl({
    required this.blogLocalDataSource,
    required this.connectionChecker,
    required this.blogRemoteDataSource,
  });
  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File img,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(AppConstants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imgUrl = await blogRemoteDataSource.uploadBlogImage(
        img: img,
        blogModel: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imgUrl);

      final blogData = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(blogData);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.getBlogs();
        return right(blogs);
      }
      final blogData = await blogRemoteDataSource.getBlogs();
      blogLocalDataSource.uploadBlogs(blogs: blogData);
      // log('${blogData.map((e) => e.title)}');
      return right(blogData);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}

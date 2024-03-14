import 'dart:io';

import 'package:blog_clean_architecture/core/constants/supabase_constants.dart';
import 'package:blog_clean_architecture/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
  Future<String> uploadBlogImage({
    required File img,
    required BlogModel blogModel,
  });
  Future<List<BlogModel>> getBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from(SupabaseConstants.blogsTableName)
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(error: e.message);
    } on ServerException catch (e) {
      throw ServerException(error: e.error);
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File img,
    required BlogModel blogModel,
  }) async {
    try {
      await supabaseClient.storage
          .from(SupabaseConstants.storageTableName)
          .upload(
            blogModel.id,
            img,
          );
      return supabaseClient.storage
          .from(SupabaseConstants.storageTableName)
          .getPublicUrl(
            blogModel.id,
          );
    } on StorageException catch (e) {
      throw ServerException(error: e.message);
    } on ServerException catch (e) {
      throw ServerException(error: e.error);
    }
  }

  @override
  Future<List<BlogModel>> getBlogs() async {
    try {
      final blogs = await supabaseClient
          .from(SupabaseConstants.blogsTableName)
          .select('*,${SupabaseConstants.userTableName}(name)');
      return blogs
          .map((blog) => BlogModel.fromJson(blog)
              .copyWith(posterName: blog['profiles']['name']))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(error: e.message);
    } on ServerException catch (e) {
      throw ServerException(error: e.error);
    }
  }
}

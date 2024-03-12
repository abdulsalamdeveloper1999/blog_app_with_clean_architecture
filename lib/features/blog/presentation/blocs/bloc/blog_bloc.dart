import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_clean_architecture/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_clean_architecture/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_blogUpload);
    on<GetBlogsEvent>(_blogGetAllBlogs);
  }

  Future<void> _blogUpload(
      BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(BlogParams(
      img: event.img,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
    ));

    res.fold(
      (failure) => emit(BlogFailureState(error: failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  Future<void> _blogGetAllBlogs(
    GetBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    try {
      final res = await _getAllBlogs(BlogNoParams());
      res.fold(
        (l) => emit(BlogFailureState(error: l.message)),
        (r) => emit(BlogDisplaySuccess(allBlogs: r)),
      );
    } catch (e) {
      // Handle other types of exceptions here if needed
      emit(BlogFailureState(error: e.toString()));
    }
  }

  @override
  void onChange(Change<BlogState> change) {
    log(change.toString());
    super.onChange(change);
  }
}

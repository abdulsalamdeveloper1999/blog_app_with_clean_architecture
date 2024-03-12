part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogUploadSuccess extends BlogState {}

final class BlogDisplaySuccess extends BlogState {
  final List<BlogEntity> allBlogs;

  BlogDisplaySuccess({required this.allBlogs});
}

final class BlogFailureState extends BlogState {
  final String error;

  BlogFailureState({required this.error});
}

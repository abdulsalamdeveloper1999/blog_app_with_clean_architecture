part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final File img;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  BlogUploadEvent({
    required this.img,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

final class GetBlogsEvent extends BlogEvent {}

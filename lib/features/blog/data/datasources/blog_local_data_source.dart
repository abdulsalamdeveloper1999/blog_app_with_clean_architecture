import 'package:hive/hive.dart';

import '../models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogs({required List<BlogModel> blogs});
  List<BlogModel> getBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl({required this.box});
  @override
  List<BlogModel> getBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (var i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (var i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}

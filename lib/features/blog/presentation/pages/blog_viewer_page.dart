import 'package:blog_clean_architecture/core/utils/fromat_date.dart';
import 'package:blog_clean_architecture/core/utils/reading_time.dart';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route(BlogEntity blogEntity) => MaterialPageRoute(
      builder: (_) => BlogViewerPage(
            blogEntity: blogEntity,
          ));
  final BlogEntity blogEntity;
  const BlogViewerPage({super.key, required this.blogEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blogEntity.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "By ${blogEntity.posterName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${formateDateBydMMYYYY(blogEntity.updatedAt)} ${readingTime(blogEntity.content)} min",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: blogEntity.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: Column(
                        children: [
                          Text('Image is Loading'),
                          SizedBox(height: 20),
                          LinearProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.left,
                  blogEntity.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

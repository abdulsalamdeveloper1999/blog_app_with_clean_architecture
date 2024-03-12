import 'package:blog_clean_architecture/core/utils/reading_time.dart';
import 'package:blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_clean_architecture/features/blog/presentation/pages/blog_viewer_page.dart';

import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blogEntity;
  final Color color;
  const BlogCard({
    super.key,
    required this.blogEntity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blogEntity));
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blogEntity.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Chip(
                              label: Text(e),
                              side: BorderSide.none,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blogEntity.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '${readingTime(blogEntity.content)} min',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

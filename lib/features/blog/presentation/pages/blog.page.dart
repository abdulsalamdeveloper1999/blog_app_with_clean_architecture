import 'dart:developer';

import 'package:blog_clean_architecture/core/common/widgets/loader.dart';
import 'package:blog_clean_architecture/core/theme/app_colors.dart';
import 'package:blog_clean_architecture/core/utils/snackbar.dart';
import 'package:blog_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:blog_clean_architecture/features/blog/presentation/blocs/bloc/blog_bloc.dart';
import 'package:blog_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_clean_architecture/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(GetBlogsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Blog App'),
        leading: IconButton(
          onPressed: () async {
            await supabase.auth.signOut().then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                LoginPage.route(),
                (route) => false,
              );
            });
          },
          icon: const Icon(Icons.logout),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
        if (state is BlogFailureState) {
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        if (state is BlogLoading) {
          return const Center(
            child: Loader(),
          );
        } else if (state is BlogDisplaySuccess) {
          return state.allBlogs.isEmpty
              ? const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'No Blogs Available ',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.allBlogs.length,
                  itemBuilder: (_, index) {
                    log(state.allBlogs.length.toString());
                    final blogs = state.allBlogs[index];
                    return BlogCard(
                        blogEntity: blogs,
                        color: index % 3 == 0
                            ? AppPallete.gradient1
                            : AppPallete.gradient2);
                  });
        } else if (state is BlogFailureState) {
          return Center(child: Text(state.error));
        }
        return const SizedBox();
      }),
    );
  }
}

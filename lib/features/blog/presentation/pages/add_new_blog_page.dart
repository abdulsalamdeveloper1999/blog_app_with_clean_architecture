import 'dart:io';

import 'package:blog_clean_architecture/core/common/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:blog_clean_architecture/core/common/widgets/loader.dart';
import 'package:blog_clean_architecture/core/constants/app_constants.dart';
import 'package:blog_clean_architecture/core/theme/app_colors.dart';
import 'package:blog_clean_architecture/core/utils/image_picker.dart';
import 'package:blog_clean_architecture/features/blog/presentation/blocs/bloc/blog_bloc.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/snackbar.dart';
import '../widgets/blod_editor.dart';
import 'blog.page.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  List<String> topics = [];
  File? img;

  final formKey = GlobalKey<FormState>();

  void getImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        img = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() && topics.isNotEmpty && img != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).userEntity.id;
      context.read<BlogBloc>().add(
            BlogUploadEvent(
              img: img!,
              title: titleController.text,
              content: contentController.text,
              posterId: posterId,
              topics: topics,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailureState) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: Loader());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: img != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                img!,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width: double.maxFinite,
                              child: DottedBorder(
                                padding: const EdgeInsets.all(15),
                                color: AppPallete.borderColor,
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: const Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Select your image',
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AppConstants.topic
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    if (topics.contains(e)) {
                                      topics.remove(e);
                                    } else {
                                      topics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: MaterialStatePropertyAll(
                                        topics.contains(e)
                                            ? AppPallete.gradient1
                                            : null),
                                    side: BorderSide(
                                      color: topics.contains(e)
                                          ? AppPallete.gradient1
                                          : AppPallete.borderColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

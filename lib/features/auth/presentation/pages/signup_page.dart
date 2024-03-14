import 'package:blog_clean_architecture/core/common/widgets/loader.dart';
import 'package:blog_clean_architecture/core/theme/app_colors.dart';
import 'package:blog_clean_architecture/core/utils/snackbar.dart';
import 'package:blog_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:blog_clean_architecture/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog_clean_architecture/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blog/presentation/pages/blog.page.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              return showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: Loader());
            }
            return Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      const Text(
                        'Sign Up.',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(controller: nameController, hintText: 'Name'),
                      const SizedBox(height: 15),
                      AuthField(controller: emailController, hintText: 'Email'),
                      const SizedBox(height: 15),
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      AuthGradBtn(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUpEvent(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          }
                        },
                        text: 'Sign Up',
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, LoginPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account?',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: ' Sign In',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

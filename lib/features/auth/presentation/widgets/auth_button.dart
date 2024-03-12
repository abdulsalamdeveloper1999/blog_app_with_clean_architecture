import 'package:blog_clean_architecture/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthGradBtn extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const AuthGradBtn({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 395,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppPallete.gradient1,
              AppPallete.gradient2,
            ],
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppPallete.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

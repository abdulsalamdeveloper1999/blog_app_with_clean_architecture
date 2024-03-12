import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

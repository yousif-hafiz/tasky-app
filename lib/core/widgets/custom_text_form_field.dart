import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.fontSize = 20,
    this.validator,
    this.maxLines,
    this.height = 20,
  });

  final TextEditingController controller;
  final String title;
  final int? maxLines;
  final String hintText;
  final String? Function(String?)? validator;
  final double fontSize;
  final double height;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          /*validator != null
              ? (String? value) => validator!(value)
              : null,*/
          /*validator: (String? v) {
                              if (v == null || v.trim().isEmpty) {
                                return "please enter your task description";
                              } else {
                                return null;
                              }
                            },*/
          maxLines: maxLines,
          style: Theme.of(context).textTheme.labelMedium,
          decoration: InputDecoration(hintText: hintText),
        ),
        SizedBox(height: height),
      ],
    );
  }
}

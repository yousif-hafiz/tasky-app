import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    required this.colorFilter,
    required this.width,
    required this.height,
    this.withoutColor = true,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
    this.colorFilter,
    required this.width,
    required this.height,
  }) : withoutColor = false;

  final String path;
  final double width;
  final double height;
  final Color? colorFilter;
  final bool withoutColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: colorFilter==null ? null:  ColorFilter.mode(colorFilter!, BlendMode.srcIn),
    );
  }
}

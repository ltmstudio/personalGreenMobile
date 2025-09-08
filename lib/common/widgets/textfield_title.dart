import 'package:flutter/material.dart';

class TextFieldTitle extends StatelessWidget {
  const TextFieldTitle({
    super.key,
    required this.title,
    required this.child,
    this.bottomHeight,
    this.padding,
    this.textStyle,
  });

  final String title;
  final Widget child;
  final double? bottomHeight;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.only(left: 6.0),
          child: Text(
            title,
            style: textStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SizedBox(height: bottomHeight ?? 6),
        child,
      ],
    );
  }
}

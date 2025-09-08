// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// class ShadeWidget extends StatelessWidget {
//   const ShadeWidget({super.key, this.height, this.margin, this.borderRadius, this.width});
//
//   final double? height;
//   final double? width;
//   final EdgeInsetsGeometry? margin;
//   final BorderRadiusGeometry? borderRadius;
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       period: const Duration(milliseconds: 3500),
//       baseColor: Theme.of(context).cardColor,
//       highlightColor: Colors.white,
//       child: Container(
//         height: height ?? 170.0,
//         width: width,
//         decoration: BoxDecoration(borderRadius: borderRadius,color: Colors.white),
//         margin: margin ?? EdgeInsets.zero,
//       ),
//     );
//
//   }
// }
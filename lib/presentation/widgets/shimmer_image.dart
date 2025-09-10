import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/assets_manager.dart';

class ImageWithShimmer extends StatelessWidget {
  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Theme.of(context).cardColor,
        highlightColor: AppColors.gray,
        child: SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            ImageAssets.noImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => SizedBox(
        height: height,
        width: width,
        child: Image.asset(
          ImageAssets.noImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
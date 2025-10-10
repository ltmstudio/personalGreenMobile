import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconHeight,
    this.iconWidth,
    this.color,
    this.padding,
    this.showIndicator,
    this.indicatorValue,
  });

  final String icon;
  final void Function() onTap;
  final double? iconHeight;
  final double? iconWidth;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool? showIndicator;
  final int? indicatorValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              icon,
              height: iconHeight ?? 24,
              width: iconWidth ?? 24,
              colorFilter: ColorFilter.mode(
                color ?? Theme.of(context).appBarTheme.iconTheme!.color!,
                BlendMode.srcIn,
              ),
            ),
            if (showIndicator == true && indicatorValue != null)
              Positioned(
                right: -2,
                top: -0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      indicatorValue.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

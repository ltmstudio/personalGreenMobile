import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.buttonTile,
    this.height,
    this.width,
    required this.onPressed,
    this.isDisable,
    this.hasIcon,
    this.btnColor,
    this.elevation,
    this.titleColor,
    required this.isLoading,
  });

  final bool? isDisable;
  final String buttonTile;
  final double? height;
  final double? width;
  final bool? hasIcon;
  final Color? btnColor;
  final double? elevation;
  final bool isLoading;
  final Color? titleColor;


  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      width:width ?? double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(

          elevation: WidgetStateProperty.all(elevation),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (isDisable == true) {
              return Theme.of(context).disabledColor;
            }
            return btnColor ?? AppColors.primary;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: isDisable == true ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonTile,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (hasIcon != null)
                    Icon(Icons.arrow_forward_sharp, color: AppColors.white),
                ],
              ),
      ),
    );
  }
}

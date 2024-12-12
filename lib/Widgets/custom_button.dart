import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final AlignmentGeometry? alignment;
  final Color? backGroundColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double? borderWidth;
  final double? textSize;
  final Color? borderColor;
  final Gradient? gradient;

  const CustomButton(
      {super.key,
      this.textStyle,
      this.rightPadding,
      this.leftPadding,
      this.bottomPadding,
      this.topPadding,
      this.alignment,
      this.height,
      this.borderRadius,
      this.width,
      required this.title,
      this.backGroundColor,
      this.borderColor,
      this.borderWidth,
      this.boxShadow,
      this.onTap,
      this.textColor,
      this.textSize,
      this.gradient});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? Get.height * 0.055,
        width: width ?? Get.width,
        alignment: alignment ?? Alignment.center,
        padding: EdgeInsets.only(
            top: topPadding ?? 0,
            bottom: bottomPadding ?? 0,
            left: leftPadding ?? 0,
            right: rightPadding ?? 0),
        decoration: BoxDecoration(
          color: backGroundColor ?? ColorConstant.primary,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          gradient: gradient,
          border: Border.all(
            color: borderColor ?? ColorConstant.transparent,
            width: borderWidth ?? 1,
          ),
          boxShadow: boxShadow,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: textStyle ??
              TextStyleConstant.semiBold18(
                  color: textColor ?? ColorConstant.white),
        ),
      ),
    );
  }
}

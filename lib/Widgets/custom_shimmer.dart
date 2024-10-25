import 'package:firesafety/Constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final bool? neeChildWidget;
  final Widget? childWidget;
  final double? height;
  final double? width;
  final double? radius;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;

  const CustomShimmer(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.neeChildWidget,
      this.childWidget,
      this.leftPadding,
      this.rightPadding,
      this.topPadding,
      this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorConstant.grey.withOpacity(0.1),
      highlightColor: ColorConstant.grey.withOpacity(0.3),
      child: (neeChildWidget == true)
          ? childWidget!
          : Padding(
              padding: EdgeInsets.fromLTRB(leftPadding ?? 0, topPadding ?? 0,
                  rightPadding ?? 0, bottomPadding ?? 0),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    color: ColorConstant.black,
                    borderRadius: BorderRadius.circular(radius ?? 10)),
              ),
            ),
    );
  }
}

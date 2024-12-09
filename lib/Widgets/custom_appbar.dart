import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? needChildWidget;
  final Widget? childWidget;
  final List<Widget>? action;
  final Widget? leading;
  final bool? centerTitle;
  final bool? isBack;
  final Color? backGroundColor;
  final Color? textColor;

  const CustomAppBar(
      {super.key,
      this.title,
      this.centerTitle,
      this.isBack,
      this.leading,
      this.action,
      this.backGroundColor,
      this.textColor,
      this.needChildWidget,
      this.childWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: backGroundColor ?? ColorConstant.primary,
        title: (needChildWidget == true)
            ? childWidget
            : Text(
                "$title",
                style: TextStyle(color: textColor ?? ColorConstant.white),
              ),
        leading: (isBack == true)
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_rounded,
                    color: ColorConstant.white))
            : leading,
        actions: action,
        centerTitle: centerTitle ?? true);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTabBox extends StatelessWidget {
  final String title;
  final bool isExpandTab;

  const CustomTabBox(
      {super.key, required this.title, required this.isExpandTab});

  @override
  Widget build(BuildContext context) {
    return (isExpandTab)
        ? SizedBox(
            height: Get.height, width: Get.width, child: Tab(text: title))
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
            child: Tab(text: title),
          );
  }
}

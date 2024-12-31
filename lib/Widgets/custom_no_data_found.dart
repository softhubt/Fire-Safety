import 'package:flutter/material.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';

class CustomNoDataFound extends StatelessWidget {
  final String? message;

  const CustomNoDataFound({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text((message) ?? "No Data Found",
            style: TextStyleConstant.semiBold24(),
            textAlign: TextAlign.center));
  }
}

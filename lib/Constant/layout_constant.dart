import 'package:flutter/material.dart';
import 'package:get/get.dart';

final EdgeInsetsGeometry screenPadding = EdgeInsets.symmetric(
    vertical: responsiveHeight(height: 14),
    horizontal: responsiveWidth(width: 20));
final EdgeInsetsGeometry screenVerticalPadding =
    EdgeInsets.symmetric(vertical: responsiveHeight(height: 14));
final EdgeInsetsGeometry screenHorizontalPadding =
    EdgeInsets.symmetric(horizontal: responsiveWidth(width: 20));

final double screenHeightPadding = responsiveHeight(height: 14);
final double screenWidthPadding = responsiveWidth(width: 20);

final EdgeInsetsGeometry contentPadding = EdgeInsets.symmetric(
    vertical: responsiveHeight(height: 00),
    horizontal: responsiveWidth(width: 12));
final EdgeInsetsGeometry contentVerticalPadding =
    EdgeInsets.symmetric(vertical: responsiveHeight(height: 10));
final EdgeInsetsGeometry contentHorizontalPadding =
    EdgeInsets.symmetric(horizontal: responsiveWidth(width: 12));

final double contentHeightPadding = responsiveHeight(height: 10);
final double contentWidthPadding = responsiveWidth(width: 12);

double responsiveHeight({required double height}) =>
    Get.height * (height / 1000);

double responsiveWidth({required double width}) => Get.width * (width / 1000);

Widget responsiveSizedBoxHeight({required double height}) =>
    SizedBox(height: responsiveHeight(height: height));

Widget responsiveSizedBoxWidth({required double width}) =>
    SizedBox(width: responsiveWidth(width: width));

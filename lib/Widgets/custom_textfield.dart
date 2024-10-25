import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String? hintText;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? isObscureText;
  bool? isExpand = false;
  Color? focuseBorderColor;
  Color? textFieldBackgroundColor;
  int? maxLine;
  List<TextInputFormatter>? textInputFormatter;
  bool? enable;
  TextInputType? textInputType;
  bool? isReadOnly = false;
  String? labelText;
  Function()? onTap;
  FocusNode? focusNode;
  String? Function(String?)? validator;
  int? maxLength;
  Function(String)? onChange;
  Function(String)? onSubmitted;
  Color? fillColor;
  Color? hintColor;
  TextSelectionControls? textSelectionControls;

  CustomTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.onChange,
      this.enable,
      this.fillColor,
      this.focuseBorderColor,
      this.focusNode,
      this.hintColor,
      this.isExpand,
      this.isReadOnly,
      this.labelText,
      this.maxLength,
      this.maxLine,
      this.validator,
      this.isObscureText,
      this.onTap,
      this.onSubmitted,
      this.prefixIcon,
      this.suffixIcon,
      this.textFieldBackgroundColor,
      this.textInputFormatter,
      this.textInputType,
      this.textSelectionControls});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText ?? false,
      inputFormatters: textInputFormatter,
      maxLines: maxLine ?? 1,
      maxLength: maxLength ?? 1000,
      focusNode: focusNode,
      minLines: 1,
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      keyboardType: textInputType ?? TextInputType.text,
      style: TextStyleConstant.medium18(),
      cursorColor: ColorConstant.primary.withOpacity(0.6),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        fillColor: fillColor ?? ColorConstant.white,
        filled: true,
        enabled: enable ?? true,
        counterText: "",
        labelStyle: TextStyleConstant.medium16(color: ColorConstant.grey),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: ColorConstant.primary, width: 2)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConstant.primary)),
        errorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: suffixIcon,
        focusColor: ColorConstant.primary,
        labelText: labelText,
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(
            Get.width * 0.037, Get.height * 0.012, 0, Get.height * 0.012),
        hintStyle:
            TextStyleConstant.medium18(color: hintColor ?? ColorConstant.grey),
      ),
      selectionControls: textSelectionControls,
    );
  }
}

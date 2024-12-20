import 'package:firesafety/Constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isObscureText;
  final bool? isExpand;
  final Color? focuseBorderColor;
  final Color? textFieldBackgroundColor;
  final int? maxLine;
  final List<TextInputFormatter>? textInputFormatter;
  final bool? enable;
  final TextInputType? textInputType;
  final bool? isReadOnly;
  final String? labelText;
  final Function()? onTap;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final Color? fillColor;
  final Color? hintColor;
  final TextSelectionControls? textSelectionControls;

  const CustomTextField({
    super.key,
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
    this.textSelectionControls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? ColorConstant.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText ?? false,
        inputFormatters: textInputFormatter,
        maxLines: isExpand ?? false ? null : (maxLine ?? 1),
        maxLength: maxLength ?? 1000,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChange,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        keyboardType: isExpand ?? false
            ? TextInputType.multiline
            : (textInputType ?? TextInputType.text),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ColorConstant.black,
        ),
        cursorColor: ColorConstant.primary.withOpacity(0.8),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          fillColor: Colors.transparent,
          filled: true,
          enabled: enable ?? true,
          counterText: "",
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorConstant.grey.withOpacity(0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                const BorderSide(color: ColorConstant.primary, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: ColorConstant.grey.withOpacity(0.4),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: ColorConstant.grey.withOpacity(0.4),
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: ColorConstant.red, width: 1),
          ),
          labelText: labelText,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintStyle: TextStyle(
            fontSize: 14,
            color: hintColor ?? ColorConstant.grey.withOpacity(0.6),
            fontWeight: FontWeight.w300,
          ),
        ),
        selectionControls: textSelectionControls,
      ),
    );
  }
}

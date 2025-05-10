import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Color fillColor;
  final Color hintColor;
  final Color iconColor;
  final Color borderColor;
  final Color fontColor;
  final double borderRadius;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool enableInteractiveSelection;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry? contentPadding;

  const TextFormFieldCustom({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.controller,
    this.fillColor = Colors.white,
    this.hintColor = Colors.grey,
    this.iconColor = Colors.blue,
    this.borderColor = Colors.blue,
    this.fontColor = Colors.black,
    this.borderRadius = 16.0,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.enableInteractiveSelection = true,
    this.boxShadow,
    this.gradient,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: TextFormField(
        maxLines: maxLines,
        minLines: minLines,
        textDirection: TextDirection.rtl,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        enableInteractiveSelection: enableInteractiveSelection,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          color: fontColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          hintText: hint.tr,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular((borderRadius * 0.5).r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          suffixIcon: suffixIcon,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: 14.w,
              ),
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'DinarOne',
            color: fontColor.withOpacity(0.8),
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: _buildBorder(borderColor),
          focusedBorder: _buildBorder(theme.primaryColor),
          errorBorder: _buildBorder(Colors.red),
          focusedErrorBorder: _buildBorder(Colors.red),
          errorStyle: TextStyle(
            color: Colors.red[700],
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
      borderSide: BorderSide(
        color: color,
        width: 1.5.w,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    );
  }
}

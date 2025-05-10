import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constant/appcolors.dart';

class PostDetailsField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Color fillColor;
  final Color hintColor;
  final Color borderColor;
  final Color fontColor;
  final double borderRadius;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? prefix;
  final double? width;
  final Widget? suffixIcon;

  const PostDetailsField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.fillColor = Colors.white,
    this.hintColor = Colors.grey,
    this.borderColor = AppColors.TheMain,
    this.fontColor = Colors.black,
    this.borderRadius = 5.0,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.prefix,
    this.width,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w, // استخدام w للعرض المتجاوب
      child: TextFormField(
        scrollPadding: EdgeInsets.only(bottom: 250.h),
        onChanged: (value) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        },
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefix: prefix,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w), // استخدام w للهامش
                  child: prefixIcon,
                )
              : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: fillColor,
          hintText: hint.tr,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 14.sp, // استخدام sp لأحجام الخطوط
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.h, // استخدام h للارتفاع
            horizontal: 10.w,
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'DinarOne',
            color: fontColor,
            fontSize: 16.sp, // استخدام sp للخط
            height: 1.2.h, // استخدام h لارتفاع السطر
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 1.w, // استخدام w لعرض الحدود
            ),
            borderRadius: BorderRadius.circular(borderRadius.r), // استخدام r للزوايا
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width:1.w,
            ),
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        style: TextStyle(
          color: fontColor,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
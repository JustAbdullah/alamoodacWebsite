import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/ThemeController.dart';
import '../core/constant/appcolors.dart';
import '../core/localization/changelanguage.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedItem;
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;
  final Widget? customIcon;
  final Color menuColor;
  final double menuElevation;
  final EdgeInsetsGeometry menuPadding;
  final void Function(String?) onChanged;

  const DropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.selectedItem,
    this.fillColor = Colors.black,
    this.borderColor = AppColors.TheMain,
    this.borderRadius = 12.0,
    this.customIcon,
    this.menuColor = Colors.white,
    this.menuElevation = 8.0,
    this.menuPadding = const EdgeInsets.symmetric(vertical: 5.0),
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isRTL =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    // تحديد حجم القائمة بناءً على الشاشة
    double maxMenuHeight =
        MediaQuery.of(context).size.height * 0.85; // 50% من الشاشة

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h),
        child: DropdownButtonFormField<String>(
          value: selectedItem,
          isExpanded: true,
          items: items.map(_buildMenuItem).toList(),
          onChanged: onChanged,
          iconSize: 30,
          dropdownColor: menuColor,
          elevation: menuElevation.toInt(),
          menuMaxHeight: maxMenuHeight, // استخدام حجم الشاشة لتحديد الارتفاع
          padding: menuPadding,
          decoration: _buildInputDecoration(isRTL, themeController),
          style: TextStyle(
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
          ),
          selectedItemBuilder: (_) => items.map((item) {
            return Align(
              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                item.tr,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontSize: 19.sp),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildMenuItem(String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_box_outline_blank,
              color: borderColor,
              size: 22.sp,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.tr,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.balckColorTypeThree,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      bool isRTL, ThemeController themeController) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.cardColor(themeController.isDarkMode.value),
      labelText: label,
      labelStyle: TextStyle(
          fontFamily: 'DinarOne',
          color: AppColors.textColor(themeController.isDarkMode.value),
          fontSize: 20.sp),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 20.0),
      constraints: BoxConstraints(
        minHeight: 60.h,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors.textColor(themeController.isDarkMode.value),
            width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors.textColor(themeController.isDarkMode.value),
            width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors.textColor(themeController.isDarkMode.value),
            width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

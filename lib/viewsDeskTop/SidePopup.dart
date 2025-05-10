import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/localization/changelanguage.dart';

/// دالة عامة لإظهار نافذة منبثقة جانبية (SidePopup)
void showSidePopup({
  required BuildContext context,
  required Widget child,
  double widthPercent = 0.35, // نسبة العرض من الشاشة، يمكن تعديلها
  bool useSideAlignment = true, // true إذا أردت العرض جانبي حسب اللغة، false للعرض في المنتصف
}) {
  // الحصول على أبعاد الشاشة
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // الحصول على المتحكم الخاص بتغيير اللغة
  final changeLanguageController = Get.find<ChangeLanguageController>();
  bool isArabic = changeLanguageController.currentLocale.value.languageCode == 'ar';

  // حساب عرض النافذة حسب النسبة
  double popupWidth = screenWidth * widthPercent;

  // تحديد المحاذاة والهوامش بناءً على الخيار
  Alignment alignment;
  EdgeInsets insetPadding;

  if (useSideAlignment) {
    // عرض النافذة في الجهة المناسبة بناءً على اللغة
    alignment = isArabic ? Alignment.centerRight : Alignment.centerLeft;
    insetPadding = isArabic
        ? EdgeInsets.only(left: screenWidth - popupWidth)
        : EdgeInsets.only(right: screenWidth - popupWidth);
  } else {
    // العرض في المنتصف
    alignment = Alignment.center;
    insetPadding = EdgeInsets.symmetric(
      horizontal: (screenWidth - popupWidth) / 2,
    );
  }

  // عرض النافذة باستخدام Get.dialog
  Get.dialog(
    Align(
      alignment: alignment,
      child: Dialog(
        elevation: 10,
        backgroundColor: Colors.transparent,
        insetPadding: insetPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          width: popupWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    ),
    barrierColor: Colors.black54,
    barrierDismissible: true,
  );
}

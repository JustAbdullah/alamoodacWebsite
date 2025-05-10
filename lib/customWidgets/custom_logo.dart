import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/ThemeController.dart';
import '../core/constant/images_path.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Image.asset(
        themeController.isDarkMode.value
            ? ImagesPath.logoDark
            : ImagesPath.logo,
        height: 70.h, // زيادة الحجم
        fit: BoxFit.contain,
        key: ValueKey<bool>(themeController.isDarkMode.value),
      ),
    );
  }
}

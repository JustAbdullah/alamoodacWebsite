 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';

class InfoAccount extends StatelessWidget {
  const InfoAccount({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.put(LoadingController());
    final ThemeController themeController = Get.put(ThemeController());
    Searchcontroller searchcontroller = Get.put(Searchcontroller());

    return GetX<HomeController>(
        builder: (controller) => Scaffold(
          body: Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "معلومات الحساب".tr,
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "أسم الحسـاب".tr,
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          loadingController.currentUser?.name ?? "",
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          "رقم الهاتف".tr,
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          loadingController.currentUser?.phone == "0"
                              ? "غير مدخل".tr
                              : loadingController.currentUser?.phone ?? "",
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "حالة الباقة".tr,
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}

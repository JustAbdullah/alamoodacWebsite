
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

class ChoseTrack extends StatelessWidget {
  const ChoseTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    final homeController = Get.find<HomeController>();
    return GetX<Settingscontroller>(
        builder: (controller) => Visibility(
            visible: controller.choseTra.value,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.92,
                color:
                    AppColors.backgroundColor(themeController.isDarkMode.value),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      InkWell(
                        onTap: () {
                          controller.choseTra.value = false;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              ImagesPath.back,
                              width: 20.w,
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "العودة".tr,
                              // ignore: deprecated_member_use
                              style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  color: AppColors.textColor(
                                      themeController.isDarkMode.value),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "إختيار المسار".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "قم رجاءًا بإختيار المسار المراد".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "عندما تقوم بإختيار مسار ما سيتم تخصيص جميع الواجهات بالمسار المختار"
                            .tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      InkWell(
                        onTap: () {
                          homeController.saveSelectedRoute('العراق');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.TheMain,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "على مودك العراق".tr,
                            style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      /*  InkWell(
                        onTap: () {
                          homeController.saveSelectedRoute('تركيا');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.TheMain,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "على مودك تركيا".tr,
                            style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),*/
                      /*    SizedBox(
                        height: 25.h,
                      ),
                      InkWell(
                        onTap: () {
                          homeController.saveSelectedRoute('سوريا');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.TheMain,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "على مودك سوريا".tr,
                            style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),*/
                    ]))))));
  }
}

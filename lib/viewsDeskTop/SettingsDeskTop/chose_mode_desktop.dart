import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/localization/changelanguage.dart';

class ChoseModeDeskTopPage  extends StatefulWidget {
  const ChoseModeDeskTopPage ({super.key});

  @override
  State<ChoseModeDeskTopPage> createState() => _ChoseModeDeskTopPageState();
}

class _ChoseModeDeskTopPageState extends State<ChoseModeDeskTopPage > {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    // تأكد من حصولنا على HomeController و Searchcontroller إذا كانوا بحاجة إلى الاستخدام لاحقاً
    HomeController homeController = Get.put(HomeController());
    Searchcontroller searchcontroller = Get.put(Searchcontroller());
    return GetX<Settingscontroller>(
      builder: (controller) => Visibility(
        visible: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.92,
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors
                                .backgroundColorIconBack(themeController.isDarkMode.value)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            Get.find<ChangeLanguageController>().currentLocale.value.languageCode == "ar"
                                ? ImagesPath.back
                                : ImagesPath.arrowLeft,
                            width: 24.w,
                            height: 24.h,
                            color: AppColors.textColor(themeController.isDarkMode.value),
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "إختيار مظهر التطبيق".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color: AppColors.textColor(themeController.isDarkMode.value),
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "أختر مظهر التطبيق المناسب لك من الخيارات التالية:".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color: AppColors.textColor(themeController.isDarkMode.value),
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 55.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // حالة الوضع العادي (فاتح)
                      InkWell(
                        onTap: () {
                          themeController.enableLightMode();
                          setState(() {});
                        },
                        child: Container(
                          width: 120,
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1), // لون فاتح غير أبيض
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wb_sunny,
                                size: 60,
                                color: Colors.yellow[600],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "الوضع العادي".tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "فاتح".tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 16,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      // حالة الوضع الليلي (مظلم)
                      InkWell(
                        onTap: () {
                          themeController.enableDarkMode();
                          setState(() {});
                        },
                        child: Container(
                          width: 120,
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3A3A), // لون داكن غير أسود
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.nights_stay,
                                size: 60,
                                color: Colors.white70,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "الوضع الليلي".tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "مظلم".tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

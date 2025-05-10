
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/createPusher/create_info_data_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/searchController.dart';
import '../../../controllers/settingsController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../core/localization/changelanguage.dart';
import '../../AuthDeskTop/login_screen_desktop.dart';
import '../../SidePopup.dart';

class ChosePusherDesktop extends StatelessWidget {
  const ChosePusherDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final loadingController = Get.find<LoadingController>();
    final HomeController homeController = Get.put(HomeController());
    final Searchcontroller searchcontroller = Get.put(Searchcontroller());

    return GetX<Settingscontroller>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
                key: const ValueKey('pusher-container'),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor(
                      themeController.isDarkMode.value),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Section
                          _buildHeader(themeController, controller),

                          // Feature Illustration

                          SizedBox(height: 30.h),

                          // Content Section
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFeatureCard(
                                    icon: Icons.business_center_rounded,
                                    title: "ميزة احترافية جديدة".tr,
                                    description:
                                        "عرض معلومات الناشر بشكل مميز مع إمكانيات تخصيص متقدمة"
                                            .tr,
                                    themeController: themeController,
                                  ),
                                  SizedBox(height: 20.h),

                                  _buildFeatureList(
                                    themeController: themeController,
                                    items: [
                                      "إضافة شعار خاص بك".tr,
                                      "وصف تفصيلي عن النشاط".tr,
                                      "وسائل تواصل متعددة".tr,
                                      "عرض الموقع الجغرافي".tr,
                                      "أوقات العمل المخصصة".tr,
                                    ],
                                  ),
                                  SizedBox(height: 40.h),

                                  // Action Button
                                  Center(
                                    child: _buildSetupButton(
                                      loadingController: loadingController,
                                      controller: controller,
                                      themeController: themeController,
                                      context: context
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Create Info Data Overlay
                   
                    ],
                  ),
                ),
              )
           
      ),
    );
  }

  Widget _buildHeader(
      ThemeController themeController, Settingscontroller controller) {
    return Row(
     
      children: [
        InkWell(
          onTap: () =>Get.back(),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundColorIconBack(
                      themeController.isDarkMode.value)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:Image.asset( Get.find<ChangeLanguageController>().currentLocale.value.languageCode=="ar"?          ImagesPath.back:
          ImagesPath.arrowLeft,
                width: 24.w,
                height: 24.h,
                color: AppColors.textColor(themeController.isDarkMode.value)),
          ),
        ), SizedBox(
              width: 15.w,
            ),

         SizedBox(
          width: 
          250.w,
          child:  Text(
            "بطاقة الناشر الاحترافية".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 22.sp,
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),  overflow: TextOverflow.ellipsis,
                        maxLines: 1,
          ),
        ),
       
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required ThemeController themeController,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: AppColors.cardColor(themeController.isDarkMode.value),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Icon(icon,
                size: 40.w,
                color: AppColors.textColor(themeController.isDarkMode.value)),
            SizedBox(height: 15.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor(themeController.isDarkMode.value),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 16.sp,
                color: AppColors.balckColorTypeFour,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList({
    required ThemeController themeController,
    required List<String> items,
  }) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 20.w,
                        color: AppColors.textColor(
                            themeController.isDarkMode.value)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontFamily: AppTextStyles.DinarOne,
                          fontSize: 16.sp,
                          color: AppColors.textColor(
                              themeController.isDarkMode.value),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSetupButton({
    required LoadingController loadingController,
    required Settingscontroller controller,
    required ThemeController themeController,
    required BuildContext context
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12.r),
      elevation: 5,
      child: InkWell(
        onTap: () => _handleSetupAction(loadingController, controller,context),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 220.w,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w),
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              colors: [AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings_rounded, color: Colors.white, size: 24.w),
              SizedBox(width: 10.w),
              Text(
                "بدء الإعداد".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSetupAction(
      LoadingController loadingController, Settingscontroller controller,BuildContext context) {
    if (loadingController.currentUser == null) {
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        titleText: Column(
          children: [
            Icon(Icons.error_outline_rounded, size: 40.w, color: Colors.white),
            Text(
              "يتطلب تسجيل الدخول".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        messageText: Text(
          'يجب تسجيل الدخول لاستخدام هذه الميزة'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        mainButton: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () =>       showDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => const LoginPopup(),
),
          child: Text(
            'تسجيل الدخول'.tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 14.sp,
              color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: const Duration(seconds: 4),
        animationDuration: const Duration(milliseconds: 500),
        margin: EdgeInsets.all(20.w),
        borderRadius: 15.r,
      );
    } else {
       showSidePopup(
  context: context,
  child:  CreateInfoDataDeskTop(),
  widthPercent:1,      
  useSideAlignment: false,
);
    }
  }
}

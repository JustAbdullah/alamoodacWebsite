import 'package:alamoadac_website/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/settingsController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../core/localization/changelanguage.dart';
import '../../SidePopup.dart';
import 'chose_phone_desktop.dart';

class SaveAccountDeskTopPage extends StatelessWidget {
  const SaveAccountDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.find<Settingscontroller>();

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.92,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: Column(
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColorIconBack(
                                themeController.isDarkMode.value)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                          Get.find<ChangeLanguageController>()
                                      .currentLocale
                                      .value
                                      .languageCode ==
                                  "ar"
                              ? ImagesPath.back
                              : ImagesPath.arrowLeft,
                          width: 24.w,
                          height: 24.h,
                          color: AppColors.textColor(
                              themeController.isDarkMode.value)),
                    ),
                  ),
                  Text(
                    'خطوة ١ من ٣'.tr,
                    style: TextStyle(
                      color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value)
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outlined,
                  size: 50.sp,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                ),
              ),

              SizedBox(height: 25.h),

              // Title Section
              Text(
                "آلية تأمين و توثيق الحساب".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15.h),

              // Features List
              _buildSecurityFeature(
                icon: Icons.phone_android_rounded,
                title: "ربط رقم الهاتف".tr,
                subtitle: "استعادة الحساب عند فقدان كلمة المرور".tr,
                themeController: themeController,
              ),
              _buildSecurityFeature(
                icon: Icons.security_rounded,
                title: "أسئلة أمان شخصية".tr,
                subtitle: "طبقة حماية إضافية للعمليات الحساسة".tr,
                themeController: themeController,
              ),

              SizedBox(
                height: 100.h,
              ),

              // Action Button
              InkWell(
                onTap: () => showSidePopup(
                  context: context,
                  child: ChosePhoneDeskTopPage(),
                  widthPercent: 0.30,
                  useSideAlignment: true,
                ),
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.backgroundColorIconBack(
                                Get.find<ThemeController>().isDarkMode.value)
                            .withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_open_rounded, color: Colors.white),
                      SizedBox(width: 10.w),
                      Text(
                        "ابدأ عملية التأمين".tr,
                        style: TextStyle(
                          fontFamily: AppTextStyles.DinarOne,
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeController themeController,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? Colors.white.withOpacity(0.05)
            : AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                size: 24.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value),
                    )),
                Text(subtitle.tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 12.sp,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value)
                              .withOpacity(0.7),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

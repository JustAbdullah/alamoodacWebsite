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

class ChoseLangDeskTopPage extends StatelessWidget {
  const ChoseLangDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final Settingscontroller settingsController = Get.find();

    return Obx(
      () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildLanguageSelectionUI(
              themeController, context, settingsController)),
    );
  }

  Widget _buildLanguageSelectionUI(ThemeController themeController,
      BuildContext context, Settingscontroller controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(themeController, controller),
            SizedBox(height: 30.h),
            _buildLanguageList(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      ThemeController themeController, Settingscontroller controller) {
    return Column(
      children: [
        Row(
          children: [
            _buildCloseIcon(themeController, controller),
            SizedBox(
              width: 15.w,
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                "اختر اللغة المفضلة".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          "سيتم تطبيق اللغة المختارة على جميع عناصر التطبيق".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            color: AppColors.textColor(themeController.isDarkMode.value)
                .withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseIcon(
      ThemeController themeController, Settingscontroller controller) {
    return InkWell(
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
            color: AppColors.textColor(themeController.isDarkMode.value)),
      ),
    );
  }

  Widget _buildLanguageList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemBuilder: (context, index) {
          final languages = [
            {'code': 'ar', 'label': "العربية".tr, 'flag': ImagesPath.flagArLe},
            {'code': 'ku', 'label': "Kurdî", 'flag': ImagesPath.flagKuLe},
            {'code': 'tr', 'label': "Truk", 'flag': ImagesPath.flagTrLe},
            {'code': 'en', 'label': "English", 'flag': ImagesPath.flagEnLe},
          ];
          return _buildLanguageCard(languages[index]);
        },
      ),
    );
  }

  Widget _buildLanguageCard(Map<String, dynamic> lang) {
    final themeController = Get.find<ThemeController>();
    final currentLang =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleLanguageChange(lang['code']),
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                currentLang == lang['code']
                    ? AppColors.backgroundColorIconBack(
                            Get.find<ThemeController>().isDarkMode.value)
                        .withOpacity(0.15)
                    : AppColors.textColor(themeController.isDarkMode.value)
                        .withOpacity(0.03),
                currentLang == lang['code']
                    ? AppColors.backgroundColorIconBack(
                            Get.find<ThemeController>().isDarkMode.value)
                        .withOpacity(0.05)
                    : Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: currentLang == lang['code']
                  ? AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  : AppColors.textColor(themeController.isDarkMode.value)
                      .withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      lang['flag'],
                      width: 40.w,
                      height: 40.w,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      lang['label'],
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor(
                            themeController.isDarkMode.value),
                      ),
                    ),
                    const Spacer(),
                    if (currentLang == lang['code'])
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value),
                          size: 24.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLanguageChange(String code) async {
    try {
      final homeController = Get.find<HomeController>();
      final searchController = Get.find<Searchcontroller>();
      final langController = Get.find<ChangeLanguageController>();

      langController.changeLanguage(code);

      await Future.wait([
        homeController.refreshData(),
        searchController.refreshData(),
      ]);

      Get.find<Settingscontroller>().showChoseLang.value = false;
    } catch (e) {
      Get.snackbar(
        'خطأ'.tr,
        'فشل في تغيير اللغة: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

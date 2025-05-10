import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/ThemeController.dart';
import '../controllers/home_controller.dart';
import '../controllers/searchController.dart';
import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';
import '../core/constant/images_path.dart';
import '../core/localization/changelanguage.dart';

class CustomFlag extends StatelessWidget {
  const CustomFlag({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<ChangeLanguageController>();

    return Obx(() => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.backgroundColorIconBack(
                        themeController.isDarkMode.value)
                    .withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              hoverColor: AppColors.backgroundColorIconBack(
                      themeController.isDarkMode.value)
                  .withOpacity(0.1),
              onTap: () => _showLanguageDialog(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCurrentFlag(
                        langController.currentLocale.value.languageCode),
                    SizedBox(width: 12.w),
                    _buildLanguageText(
                        langController.currentLocale.value.languageCode),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_drop_down_rounded,
                        size: 24.r,
                        color: AppColors.textColor(
                            themeController.isDarkMode.value)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildCurrentFlag(String langCode) {
    final flagPath = _getFlagAsset(langCode);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Image.asset(
        flagPath,
        width: 32.r,
        height: 32.r,
        fit: BoxFit.contain,
        key: ValueKey<String>(langCode),
      ),
    );
  }

  Widget _buildLanguageText(String langCode) {
    final languageName = _getLanguageName(langCode);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        languageName,
        key: ValueKey<String>(langCode),
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          color:
              AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final langController = Get.find<ChangeLanguageController>();
    final themeController = Get.find<ThemeController>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor:
            AppColors.backgroundColor(themeController.isDarkMode.value),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        insetPadding: EdgeInsets.all(30.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500.w),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر اللغة'.tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                  ),
                ),
                SizedBox(height: 20.h),
                _buildLanguageOption('ar', context),
                _buildDivider(),
                _buildLanguageOption('ku', context),
                _buildDivider(),
                _buildLanguageOption('tr', context),
                _buildDivider(),
                _buildLanguageOption('en', context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value)
          .withOpacity(0.1),
      thickness: 1,
    );
  }

  Widget _buildLanguageOption(String code, BuildContext context) {
    final homeController = Get.find<HomeController>();
    final searchController = Get.find<Searchcontroller>();
    final langController = Get.find<ChangeLanguageController>();
    final themeController = Get.find<ThemeController>();
    final isSelected = langController.currentLocale.value.languageCode == code;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        hoverColor:
            AppColors.backgroundColorIconBack(themeController.isDarkMode.value)
                .withOpacity(0.1),
        onTap: () async {
          if (['ar', 'en', 'tr', 'ku'].contains(code)) {
            final changeLangController = Get.find<ChangeLanguageController>();

            Navigator.of(context).pop();

            try {
              changeLangController.changeLanguage(code);

              await Future.wait([
                homeController.refreshData(),
                searchController.refreshData(),
              ]);
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
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.backgroundColorIconBack(
                        themeController.isDarkMode.value)
                    .withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Image.asset(
                _getFlagAsset(code),
                width: 40.r,
                height: 40.r,
              ),
              SizedBox(width: 20.w),
              Text(
                _getLanguageName(code),
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 18.sp,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: AppColors.backgroundColorIconBack(
                      themeController.isDarkMode.value),
                  size: 28.r,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    return {
          'ar': 'العربية',
          'en': 'English',
          'tr': 'Türkçe',
          'ku': 'Kurdî',
        }[code] ??
        'Unknown';
  }

  String _getFlagAsset(String code) {
    return {
          'ar': ImagesPath.flagArLe,
          'en': ImagesPath.flagEnLe,
          'tr': ImagesPath.flagTrLe,
          'ku': ImagesPath.flagKuLe,
        }[code] ??
        ImagesPath.flagEnLe;
  }
}

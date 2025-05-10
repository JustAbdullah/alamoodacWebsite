import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/localization/changelanguage.dart';

class ChoseConis extends StatelessWidget {
  ChoseConis({super.key});

  final List<Map<String, dynamic>> currencies = [
    {
      'code': 'IQD',
      'name': 'الدينار العراقي'.tr,
      'symbol': 'د.ع',
      'flag': ImagesPath.flagArLe,
      'color': [Color(0xFFCE1126), Color(0xFFFFFFFF), Color(0xFF000000)]
    },
    {
      'code': 'USD',
      'name': 'الدولار الأمريكي'.tr,
      'symbol': '\$',
      'flag': ImagesPath.flagEnLe,
      'color': [Color(0xFF3C3B6E), Color(0xFFFFFFFF), Color(0xFFB22234)]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final HomeController homeController = Get.find();

    return GetX<Settingscontroller>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: controller.showCoins.value
            ? Scaffold(
                body: Container(
                  key: const ValueKey('currency-container'),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.92,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor(
                        themeController.isDarkMode.value),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(themeController, controller),
                      SizedBox(height: 30.h),

                      // Current Currency Card
                      _buildCurrentCurrencyCard(
                          homeController, themeController),
                      SizedBox(height: 30.h),

                      // Available Currencies
                      Text(
                        "العملات المتاحة".tr,
                        style: TextStyle(
                          fontFamily: AppTextStyles.DinarOne,
                          fontSize: 20.sp,
                          color: AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),

                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: currencies.length,
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          itemBuilder: (_, index) => _buildCurrencyCard(
                              currencies[index],
                              homeController,
                              themeController),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildHeader(
      ThemeController themeController, Settingscontroller controller) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            controller.showCoins.value = false;
            Get.toNamed(
              '/settings-mobile/', // المسار مع المعلمة الديناميكية
              // إرسال الكائن كامل
            );
          },
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
        ),
        SizedBox(
          width: 15.w,
        ),
        SizedBox(
          width: 250.w,
          child: Text(
            "محول العملات".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 24.sp,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentCurrencyCard(
      HomeController controller, ThemeController themeController) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.1),
            AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
            color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              size: 24.w),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              "${'العملة الحالية:'.tr}'${controller.currency.value}".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 16.sp,
                color: AppColors.textColor(themeController.isDarkMode.value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(Map<String, dynamic> currency,
      HomeController homeController, ThemeController themeController) {
    final isSelected = currency['code'] == homeController.currency.value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            currency['color'][0].withOpacity(isSelected ? 0.9 : 0.7),
            currency['color'][2].withOpacity(isSelected ? 0.7 : 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: currency['color'][0].withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => homeController.currency.value = currency['code'],
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Stack(
              children: [
                // Flag Background
                Positioned(
                  right: -30.w,
                  top: -30.h,
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      currency['flag'],
                      width: 120.w,
                      height: 120.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Currency Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Currency Symbol
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: currency['color'][1],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            currency['symbol'],
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              fontSize: 22.sp,
                              color: currency['color'][0],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        // Currency Name
                        Text(
                          currency['name'],
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            fontSize: 20.sp,
                            color: currency['color'][1],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    // Exchange Rate (يمكن إضافته إذا كانت هناك بيانات)
                    Text(
                      "1 USD ≈ 1,450 IQD",
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 16.sp,
                        color: currency['color'][1].withOpacity(0.9),
                      ),
                    ),
                  ],
                ),

                // Selection Check
                if (isSelected)
                  Positioned(
                    top: 10.w,
                    left: 10.w,
                    child: Icon(Icons.check_circle_rounded,
                        color: currency['color'][1], size: 24.w),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

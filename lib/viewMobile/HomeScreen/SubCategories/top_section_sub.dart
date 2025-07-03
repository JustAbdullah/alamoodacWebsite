import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/searchController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../customWidgets/custom_logo.dart';

class TopSectionSub extends StatelessWidget {
  TopSectionSub({super.key});

  final homeController = Get.find<HomeController>();
  final searchcontroller = Get.find<Searchcontroller>();

  void _handleBackButton() {
    homeController.showTheSubTwo.value = false;
    searchcontroller.idOfCateSearchBox.value = 0;
    homeController.showTheSubCategories.value = false;
    homeController.subCategories.clear();
    searchcontroller.isOpenFromSub.value = 0;
    searchcontroller.getDataForOneTime.value = false;
    searchcontroller.isOpenINSubPost.value = false;
    searchcontroller.selectedMainCategory = null;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    // تحديد الألوان بناءً على الوضع المظلم
    final mainColor = themeController.isDarkMode.value
        ? AppColors.yellowColor // لون بديل للوضع المظلم
        : AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value);

    final textColor = themeController.isDarkMode.value
        ? AppColors.whiteColor // لون النص في الوضع المظلم
        : AppColors.blackColor;

    final backgroundColor = themeController.isDarkMode.value
        ? AppColors.balckColorTypeFour // لون الخلفية في الوضع المظلم
        : AppColors.whiteColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: themeController.isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 90.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: _handleBackButton,
                  splashColor: mainColor.withOpacity(0.1),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: mainColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20.r,
                          color: mainColor,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "العودة".tr,
                              style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: textColor.withOpacity(0.8),
                                fontSize: 12.sp,
                              ),
                            ),
                            GetX<HomeController>(
                              builder: (controller) => Container(
                                constraints: BoxConstraints(maxWidth: 150.w),
                                child: Text(
                                  controller.nameCategories.value,
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.DinarOne,
                                    color: mainColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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

              // الشعار مع تأثير الإضاءة
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CustomLogo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

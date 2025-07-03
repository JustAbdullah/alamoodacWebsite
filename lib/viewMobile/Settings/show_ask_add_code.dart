import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/subscriptionController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

import '../../core/localization/changelanguage.dart';

class ShowAskAddCode extends StatelessWidget {
  const ShowAskAddCode({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.find<Settingscontroller>();

    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: settingsController.isShowAddCode.value
            ? Scaffold(
                body: _buildFullScreenDialog(
                    context, themeController, settingsController))
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildFullScreenDialog(BuildContext context,
      ThemeController themeController, Settingscontroller settingsController) {
    final isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(isDarkMode),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(
                  isDarkMode, settingsController, themeController),
              SizedBox(height: 40.h),
              _buildProcessGuide(isDarkMode),
              SizedBox(height: 40.h),
              _buildCodeInputSection(isDarkMode),
              const Spacer(),
              _buildActivationButton(isDarkMode, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isDarkMode, Settingscontroller controller,
      ThemeController themeController) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            controller.isShowAddCode.value = false;
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
            "تفعيل الباقة باستخدام الكود".tr,
            style: TextStyle(
              fontSize: 22.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessGuide(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "خطوات التفعيل:".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor(isDarkMode),
          ),
        ),
        SizedBox(height: 20.h),
        _buildStepItem(
            "1", "احصل على كود التفعيل من المصدر المعتمد".tr, isDarkMode),
        _buildStepItem("2", "أدخل الكود في الحقل المخصص أدناه".tr, isDarkMode),
        _buildStepItem(
            "3", "اضغط على زر التفعيل لإكمال العملية".tr, isDarkMode),
      ],
    );
  }

  Widget _buildStepItem(String number, String text, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(number,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.5,
                  color: AppColors.textColor(isDarkMode),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputSection(bool isDarkMode) {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("كود التفعيل",
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 16.sp,
              color: AppColors.textColor(isDarkMode),
            )),
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.primaryLight : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: subscriptionController.codeController,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 20.sp,
              letterSpacing: 5.w,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(isDarkMode),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "XXXX-XXXX-XXXX",
              hintStyle: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textGrey,
                letterSpacing: 3.w,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 18.h),
              suffixIcon: Icon(
                Icons.vpn_key,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                size: 26.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivationButton(bool isDarkMode, BuildContext context) {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () {
          subscriptionController.redeemSubscriptionCode(context);
        },
        child: Text(
          "تفعيل الآن".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

import '../../core/localization/changelanguage.dart';

class ShowAskDeleteAccountDeskTopPage extends StatelessWidget {
  const ShowAskDeleteAccountDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final Settingscontroller settingsController = Get.find();

    return Obx(
      () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildDestructiveDialog(
              themeController, context, settingsController)),
    );
  }

  Widget _buildDestructiveDialog(ThemeController themeController,
      BuildContext context, Settingscontroller controller) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
            children: [
              _buildDialogHeader(themeController, controller),
              SizedBox(height: 30.h),
              _buildWarningIllustration(),
              SizedBox(height: 25.h),
              _buildConsequencesList(),
              SizedBox(height: 35.h),
              _buildActionButtons(themeController, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(
      ThemeController themeController, Settingscontroller controller) {
    return Row(
      children: [
        _buildCloseIcon(themeController, controller),
        SizedBox(
          width: 15.w,
        ),
        SizedBox(
          width: 250.w,
          child: Text(
            "حذف الحساب الدائم".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.errorColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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

  Widget _buildWarningIllustration() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.warning_amber_rounded,
        size: 60.w,
        color: AppColors.errorColor,
      ),
    );
  }

  Widget _buildConsequencesList() {
    return Column(
      children: [
        _buildConsequenceItem("كل البيانات سيتم حذفها بشكل نهائي".tr),
        _buildConsequenceItem("لا يمكن استرجاع الحساب بعد الحذف".tr),
        _buildConsequenceItem("سيتم إلغاء جميع الاشتراكات".tr),
        _buildConsequenceItem("فقدان الوصول إلى الخدمات المرتبطة".tr),
      ],
    );
  }

  Widget _buildConsequenceItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18.w, color: AppColors.errorColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text.tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 14.sp,
                color: AppColors.textColor(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      ThemeController themeController, Settingscontroller controller) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              side: BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => controller.showAskToDeleteAccount.value = false,
            child: Text(
              "إلغاء الأمر".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 16.sp,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
            ),
            onPressed: () => _performAccountDeletion(controller),
            child: Text(
              "تأكيد الحذف النهائي".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 16.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _performAccountDeletion(Settingscontroller controller) {
    controller.softDeleteUser();
  }
}

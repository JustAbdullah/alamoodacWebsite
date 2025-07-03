import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/settingsController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../customWidgets/custome_textfiled.dart';
import '../../AuthDeskTop/login_screen_desktop.dart';
import '../../SidePopup.dart';
import 'ques_save_account_desktop.dart';

class ChosePhoneDeskTopPage extends StatelessWidget {
  const ChosePhoneDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.find<Settingscontroller>();
    final loadingController = Get.find<LoadingController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor(
            themeController.isDarkMode.value), // إضافة لون الخلفية
        body: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: BoxDecoration(
              color:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Column(
                children: [
                  _buildHeader(settingsController),
                  SizedBox(height: 30.h),
                  _buildPhoneIcon(),
                  SizedBox(height: 25.h),
                  _buildTitleSection(themeController),
                  SizedBox(height: 15.h),
                  _buildInstructions(themeController),
                  SizedBox(height: 30.h),
                  _buildPhoneInputSection(settingsController, themeController),
                  SizedBox(height: 100.h),
                  _buildNextButton(
                      settingsController, loadingController, context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(Settingscontroller controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            onPressed: () {
              controller.enterDataSaveAccountOne.value = false;
              Get.back();
            }),
        _buildStepIndicator(1, 3),
      ],
    );
  }

  Widget _buildStepIndicator(int currentStep, int totalSteps) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Container(
          width: 20.w,
          height: 5.h,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: index < currentStep
                ? AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                : AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildPhoneIcon() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            .withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.phone_android_rounded,
        size: 50.sp,
        color: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value),
      ),
    );
  }

  Widget _buildTitleSection(ThemeController themeController) {
    return Text(
      "ربط رقم الاستعادة".tr,
      style: TextStyle(
        fontFamily: AppTextStyles.DinarOne,
        color: AppColors.textColor(themeController.isDarkMode.value),
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInstructions(ThemeController themeController) {
    return Column(
      children: [
        _buildInstructionText(
          "رقم خاص تستخدمه لإستعادة حسابك عند الحاجة".tr,
          themeController,
        ),
        _buildInstructionText(
          "مثال: +964 770 123 4567".tr,
          themeController,
          isExample: true,
        ),
      ],
    );
  }

  Widget _buildInstructionText(String text, ThemeController themeController,
      {bool isExample = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        text.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: isExample
              ? AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              : AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.8),
          fontSize: isExample ? 14.sp : 16.sp,
          fontWeight: isExample ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection(
      Settingscontroller controller, ThemeController themeController) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: [
              if (controller.phoneNumberText.value.text.isNotEmpty)
                BoxShadow(
                  color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value)
                      .withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: TextFormFieldCustom(
            maxLines: 1,
            label: "رقم الهاتف".tr,
            hint: "+964XXXXXXXXXX".tr,
            icon: Icons.phone_iphone_rounded,
            controller: controller.phoneNumberText.value,
            fillColor: themeController.isDarkMode.value
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.shade100,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value),
            borderColor: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.3),
            fontColor: AppColors.textColor(themeController.isDarkMode.value),
            obscureText: false,
            borderRadius: 15,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            validator: (value) => _validatePhoneNumber(value),
            onChanged: (value) => _handlePhoneInputChange(controller, value),
          ),
        ),
        SizedBox(height: 15.h),
        _buildValidationMessage(controller),
      ],
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال رقم الهاتف".tr;
    }
    if (!RegExp(r'^\+?\d{8,15}$').hasMatch(value)) {
      return "رقم غير صحيح!! ناقص او غير مكتمل".tr;
    }
    return null;
  }

  void _handlePhoneInputChange(Settingscontroller controller, String value) {
    controller.update();
  }

  Widget _buildValidationMessage(Settingscontroller controller) {
    return Obx(() {
      final isValid = _isValidPhone(controller.phoneNumberText.value.text);
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: controller.phoneNumberText.value.text.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Icon(
                      isValid
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: isValid ? Colors.green : AppColors.redColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isValid ? "رقم صحيح".tr : "تأكد من صحة الرقم".tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: isValid ? Colors.green : AppColors.redColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  bool _isValidPhone(String value) {
    return RegExp(r'^\+?\d{8,15}$').hasMatch(value);
  }

  Widget _buildNextButton(Settingscontroller controller,
      LoadingController loadingController, BuildContext context) {
    return InkWell(
      onTap: () => _handleNextButton(controller, loadingController, context),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward_rounded, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              "التــالي".tr,
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
    );
  }

  void _handleNextButton(Settingscontroller controller,
      LoadingController loadingController, BuildContext context) {
    if (loadingController.currentUser == null) {
      _showLoginRequiredSnackbar(context);
    } else if (_isValidPhone(controller.phoneNumberText.value.text)) {
      controller.enterDataSaveAccountTwo.value = true;
      showSidePopup(
        context: context,
        child: QuesSaveAccountDeskTopPage(),
        widthPercent: 0.60,
        useSideAlignment: false,
      );
    } else {
      Get.snackbar(
        "خطأ في الإدخال".tr,
        "الرجاء إدخال رقم هاتف صحيح".tr,
        backgroundColor: AppColors.redColor.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      );
    }
  }

  void _showLoginRequiredSnackbar(BuildContext context) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.redColor,
      colorText: Colors.white,
      titleText: Text(
        "يتطلب تسجيل الدخول".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'يجب تسجيل الدخول لإكمال هذه العملية'.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
      mainButton: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => const LoginPopup(),
        ),
        child: Text(
          'تسجيل الدخول'.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 14.sp,
            color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      duration: const Duration(seconds: 4),
    );
  }
}

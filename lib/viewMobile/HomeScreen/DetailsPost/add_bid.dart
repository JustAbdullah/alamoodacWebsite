import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../Auth/login_screen.dart';

class AddBid extends StatelessWidget {
  const AddBid({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final LoadingController loadingController = Get.find();

    return GetX<HomeController>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: controller.showTheBid.value
            ? Scaffold(
              body: Container(
                  key: const ValueKey('bid-container'),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundColor(
                            themeController.isDarkMode.value),
                        AppColors.backgroundColor(
                            themeController.isDarkMode.value),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBackButton(controller, themeController),
                            Text(
                              "المزايدة".tr,
                              style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.textColor(
                                    themeController.isDarkMode.value),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(width: 40.w),
                          ],
                        ),
              
                        SizedBox(height: 20.h),
              
                        // Instruction Text
                        Text(
                          "قم رجاءًا بملا الحقول للمزايدة".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                    themeController.isDarkMode.value)
                                .withOpacity(0.8),
                            fontSize: 16.sp,
                            height: 1.4,
                          ),
                        ),
              
                        SizedBox(height: 25.h),
              
                        // Bid Input Fields
                        _buildInputField(
                          controller: controller.bidAmountController,
                          label: "سعر المزايدة".tr,
                          hint: "ادخل سعر المزايدة".tr,
                          icon: Icons.attach_money_rounded,
                          themeController: themeController,
                          isNumber: true,
                        ),
              
                        SizedBox(height: 20.h),
              
                        _buildInputField(
                          controller: controller.contactInfoController,
                          label: "معلومات التواصل".tr,
                          hint: "ادخل معلومات التواصل".tr,
                          icon: Icons.contact_phone_rounded,
                          themeController: themeController,
                        ),
              
                        SizedBox(height: 20.h),
              
                        _buildInputField(
                          controller: controller.additionalNotesController,
                          label: "التفاصيل الإضافية".tr,
                          hint: "ادخل التفاصيل الإضافية".tr,
                          icon: Icons.note_alt_rounded,
                          themeController: themeController,
                          maxLines: 4,
                        ),
              
                        const Spacer(),
              
                        // Submit Button
                        _buildSubmitButton(
                            controller, loadingController, themeController),
                      ],
                    ),
                  ),
                ),
            )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBackButton(
      HomeController controller, ThemeController themeController) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
controller.showTheBid.value = false;

      } ,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.textColor(themeController.isDarkMode.value)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: AppColors.textColor(themeController.isDarkMode.value)),
            SizedBox(width: 5.w),
            Text(
              "العودة".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeController themeController,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.textColor(themeController.isDarkMode.value)
                .withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.15),
              width: 0.8,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            maxLines: maxLines,
            style: TextStyle(
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.4),
              ),
              prefixIcon: Icon(icon,
                  color: AppColors.textColor(themeController.isDarkMode.value)
                      .withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(HomeController controller,
      LoadingController loadingController, ThemeController themeController) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleBidSubmission(controller, loadingController),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              "إضافة مزايدة".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: AppTextStyles.DinarOne,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBidSubmission(
      HomeController controller, LoadingController loadingController) {
    if (loadingController.currentUser == null) {
      _showAuthErrorSnackbar();
    } else if (controller.bidAmountController.text.isEmpty ||
        controller.contactInfoController.text.isEmpty) {
      Get.snackbar(
        'خطأ'.tr,
        'يرجى ملء جميع الحقول المطلوبة'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      String bidAmountText = controller
          .convertArabicNumbersToEnglish(controller.bidAmountController.text);
      double bidAmount = double.tryParse(bidAmountText) ?? 0.0;

      if (bidAmount <= 0) {
        Get.snackbar(
          'خطأ'.tr,
          'يجب إدخال قيمة صحيحة للمزايدة'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        controller.placeBid(
          auctionId: controller.idAucToAdd,
          bidAmount: bidAmount,
          contactInfo: controller.contactInfoController.text,
          additionalNotes: controller.additionalNotesController.text,
          context: Get.context!,
        );
      }
    }
  }

  void _showAuthErrorSnackbar() {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      titleText: Text(
        "ليس لديك الإذن".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'لاتستطيع القيام بهذه العملية قم بتسجيل دخولك اولاً'.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
      mainButton: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => Get.to(LoginScreen()),
        child: Text(
          'تسجيل الدخول'.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddBidDesktop extends StatelessWidget {
  const AddBidDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final HomeController homeController = Get.find();
    final LoadingController loadingController = Get.find();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 50.h),
      alignment: Alignment.topCenter,
      backgroundColor: Colors.transparent,
      child: GetX<HomeController>(
        builder: (controller) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: const ValueKey('bid-container'),
            constraints: BoxConstraints(
              maxWidth: 700.w,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor(themeController.isDarkMode.value),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 40.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  _buildHeader(controller, themeController),
                  
                  SizedBox(height: 30.h),
                  
                  // Instruction Text
                  _buildInstructionText(themeController),
                  
                  SizedBox(height: 30.h),
                  
                  // Bid Input Fields Grid
                  Flexible(
                    child: _buildInputGrid(controller, themeController),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Submit Button
                  _buildSubmitButton(controller, themeController,loadingController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller, ThemeController themeController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCloseButton(themeController,controller),
        Text(
          "المزايدة".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(width: 40.w),
      ],
    );
  }

  Widget _buildCloseButton(ThemeController themeController,HomeController homeController){
    return IconButton(
      icon: Icon(Icons.close_rounded,
          size: 28.sp,
          color: AppColors.textColor(themeController.isDarkMode.value)),
      onPressed: () => homeController.showTheBid.value = false,
      tooltip: 'إغلاق'.tr,
    );
  }
}
  Widget _buildInstructionText(ThemeController themeController) {
    return Text(
      "قم رجاءًا بملا الحقول للمزايدة".tr,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppTextStyles.DinarOne,
        color: AppColors.textColor(themeController.isDarkMode.value)
            .withOpacity(0.8),
        fontSize: 18.sp,
        height: 1.5,
      ),
    );
  }

  Widget _buildInputGrid(HomeController controller, ThemeController themeController) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 4,
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      shrinkWrap: true,
      children: [
        _buildInputField(
          controller: controller.bidAmountController,
          label: "سعر المزايدة".tr,
          hint: "مثال: 150.5 ريال".tr,
          icon: Icons.attach_money_rounded,
          themeController: themeController,
          isNumber: true,
        ),
        _buildInputField(
          controller: controller.contactInfoController,
          label: "معلومات التواصل".tr,
          hint: "مثال: 0555555555".tr,
          icon: Icons.contact_phone_rounded,
          themeController: themeController,
        ),
        _buildInputField(
          controller: controller.additionalNotesController,
          label: "التفاصيل الإضافية".tr,
          hint: "اكتب ملاحظاتك هنا...".tr,
          icon: Icons.note_alt_rounded,
          themeController: themeController,
          maxLines: 3,
        )
      ],
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textColor(themeController.isDarkMode.value)
              .withOpacity(0.1)),
        borderRadius: BorderRadius.circular(15.r),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: Row(
              children: [
                Icon(icon, size: 20.sp, 
                  color: AppColors.textColor(themeController.isDarkMode.value)
                      .withOpacity(0.6)),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textColor(themeController.isDarkMode.value)
                        .withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
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
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(HomeController controller, ThemeController themeController,LoadingController loadingController ){
    return ElevatedButton(
      onPressed: () => _handleBidSubmission(controller,loadingController),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 3,
      ),
      child: Text(
        "إضافة مزايدة".tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: Colors.white,
          letterSpacing: -0.5,
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
        onPressed: () {
          // Get.to(LoginScreen()),
          },
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


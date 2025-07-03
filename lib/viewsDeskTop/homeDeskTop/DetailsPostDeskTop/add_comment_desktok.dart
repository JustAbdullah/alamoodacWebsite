import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';

class AddCommentDesktop extends StatelessWidget {
  const AddCommentDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final HomeController homeController = Get.find();
    final LoadingController loadingController = Get.find();
    return Dialog(
      insetPadding: EdgeInsets.all(40.w),
      alignment: Alignment.topCenter,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600.w,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 35.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCloseButton(themeController),
                  Text(
                    "إضافة تعليق".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 28.sp,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 40), // للتوازن البصري
                ],
              ),

              SizedBox(height: 30.h),

              // حقل الإدخال
              Flexible(
                child: _buildCommentField(themeController, homeController),
              ),

              SizedBox(height: 30.h),

              // زر الإرسال
              _buildSubmitButton(
                  themeController, homeController, loadingController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(ThemeController themeController) {
    return IconButton(
      icon: Icon(Icons.close_rounded,
          size: 28.sp,
          color: AppColors.textColor(themeController.isDarkMode.value)),
      onPressed: () => Get.back(),
      tooltip: 'إغلاق'.tr,
    );
  }

  Widget _buildCommentField(
      ThemeController themeController, HomeController homeController) {
    return TextField(
      controller: homeController.CommentController,
      minLines: null,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: 18.sp,
        color: AppColors.textColor(themeController.isDarkMode.value),
      ),
      decoration: InputDecoration(
        hintText: "اكتب تعليقك هنا...".tr,
        hintStyle: TextStyle(
          color: AppColors.textColor(themeController.isDarkMode.value)
              .withOpacity(0.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.textColor(themeController.isDarkMode.value)
            .withOpacity(0.05),
        contentPadding: EdgeInsets.all(20.w),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeController themeController,
      HomeController controller, LoadingController loadingController) {
    return ElevatedButton(
      onPressed: () => _handleCommentSubmission(controller, loadingController),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      child: Text(
        "نشر التعليق".tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleCommentSubmission(
      HomeController controller, LoadingController loadingController) {
    if (loadingController.currentUser == null) {
      _showAuthErrorSnackbar();
    } else if (controller.CommentController.text.isEmpty) {
      Get.snackbar(
        'خطأ'.tr,
        'يرجى إدخال نص التعليق'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      controller.addComment(
        postId: controller.selectedPost.value!.id,
        commentText: controller.CommentController.text,
        context: Get.context!,
      );
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
          backgroundColor: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          //Get.to(LoginScreen())
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
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../Auth/login_screen.dart';

class AddComment extends StatelessWidget {
  const AddComment({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final LoadingController loadingController = Get.find();

    return GetX<HomeController>(
      builder: (controller) => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: controller.showTheComment.value
            ? Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                              "التعليق".tr,
                              style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.textColor(
                                    themeController.isDarkMode.value),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 40.w), // For balance
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Instruction Text
                        Text(
                          "قم رجاءًا بملا الحقول للتعليق".tr,
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

                        // Comment Input Field
                        _buildCommentInputField(controller, themeController),

                        Spacer(),

                        // Submit Button
                        _buildSubmitButton(
                            controller, loadingController, themeController),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBackButton(
      HomeController controller, ThemeController themeController) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        controller.showTheComment.value = false;
        Get.back();
      },
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

  Widget _buildCommentInputField(
      HomeController controller, ThemeController themeController) {
    return Container(
      height: 150.h,
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
        controller: controller.CommentController,
        maxLines: 5,
        style: TextStyle(
          color: AppColors.textColor(themeController.isDarkMode.value),
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: "ادخل هنا التعليق".tr,
          hintStyle: TextStyle(
              color: AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(HomeController controller,
      LoadingController loadingController, ThemeController themeController) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleCommentSubmission(controller, loadingController),
        child: Container(
          width: double.infinity,
          height: 55.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              "إضافة التعليق".tr,
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
      Get.back();
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

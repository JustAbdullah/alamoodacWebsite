import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';

class AnsQueForgetDestkop extends StatelessWidget {
  AnsQueForgetDestkop({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<AuthController>(AuthController());

    return GetX<AuthController>(
        builder: (controller) => Center(
                child: Material(
              color: Colors.transparent,
              child: Container(
                width: 700.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.whiteColor,
                              AppColors.whiteColorTypeTwo,
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SafeArea(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 30.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ImagesPath.logoText,
                                      width: 120.w,
                                      height: 120.h,
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      "استعادة الحساب".tr,
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.DinarOne,
                                        color: AppColors.TheMain,
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "أجب على أسئلة الأمان لتأكيد هويتك".tr,
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.DinarOne,
                                        color: AppColors.balckColorTypeThree,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    _buildSecurityQuestions(controller),
                                    const Spacer(),
                                    _buildVerifyButton(controller),
                                    SizedBox(height: 30.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _LoadingOverlay(controller: controller),
                  ],
                ),
              ),
            )));
  }

  Widget _buildSecurityQuestions(AuthController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            controller.UserAnwOneInForgt.value,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.TheMain,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          TextFormFieldCustom(
            maxLines: 1,
            label: "الإجابة الأولى".tr,
            hint: "أدخل الإجابة هنا".tr,
            icon: Icons.security_rounded,
            controller: controller.anwOneForget,
            fillColor: Colors.grey.shade50,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.TheMain,
            borderColor: Colors.transparent,
            fontColor: Colors.black,
            obscureText: false,
            borderRadius: 15,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.name],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "هذا الحقل مطلوب".tr;
              }
              return null;
            },
            onChanged: (value) => controller.anwOneForget.text = value,
          ),
          SizedBox(height: 30.h),
          Text(
            controller.UserAnwTwoInForgt.value,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.TheMain,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          TextFormFieldCustom(
            maxLines: 1,
            label: "الإجابة الثانية".tr,
            hint: "أدخل الإجابة هنا".tr,
            icon: Icons.security_rounded,
            controller: controller.anwTwoForget,
            fillColor: Colors.grey.shade50,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.TheMain,
            borderColor: Colors.transparent,
            fontColor: Colors.black,
            obscureText: false,
            borderRadius: 15,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.name],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "هذا الحقل مطلوب".tr;
              }
              return null;
            },
            onChanged: (value) => controller.anwTwoForget.text = value,
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(AuthController controller) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 4,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.TheMain,
              AppColors.TheMain.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => controller.verifyAnswers(
            controller.idUserInForget.value,
            controller.anwOneForget.text,
            controller.anwTwoForget.text,
            Get.context!,
          ),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "التحقق والاستعادة".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                  ),
                ),
                Icon(Icons.verified_rounded, color: Colors.white, size: 24.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final AuthController controller;
  const _LoadingOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: controller.waitCheckData.value
          ? Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.TheMain,
                      strokeWidth: 5,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "جارٍ التحقق من الإجابات...".tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: AppColors.whiteColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

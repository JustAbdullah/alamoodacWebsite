import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';
import 'sign_screen_desktop.dart';

class ForgetAccountScreenDeskTop extends StatelessWidget {
  ForgetAccountScreenDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put<AuthController>(AuthController());

    return Center(
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
                                    ImagesPath.logo,
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
                                    "أدخل معلوماتك للتحقق من الهوية".tr,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      color: AppColors.balckColorTypeThree,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  _buildInputSection(controller),
                                  const Spacer(),
                                  _buildActionButtons(controller),
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
            )));
  }

  Widget _buildInputSection(AuthController controller) {
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
          TextFormFieldCustom(
            maxLines: 1,
            label: "اسم المستخدم".tr,
            hint: "أدخل اسم المستخدم".tr,
            icon: Icons.person_outline_rounded,
            controller: controller.nameUserForget,
            fillColor: Colors.grey.shade50,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.TheMain,
            borderColor: Colors.transparent,
            fontColor: Colors.black,
            obscureText: false,
            borderRadius: 15,
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.username],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "هذا الحقل مطلوب".tr;
              }
              return null;
            },
            onChanged: (value) => controller.nameUserForget.text = value,
          ),
          SizedBox(height: 20.h),
          TextFormFieldCustom(
            maxLines: 1,
            label: "رقم الهاتف".tr,
            hint: "مثال: 009647801234567".tr,
            icon: Icons.phone_iphone_rounded,
            controller: controller.PhoneNumberForget,
            fillColor: Colors.grey.shade50,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.TheMain,
            borderColor: Colors.transparent,
            fontColor: Colors.black,
            obscureText: false,
            borderRadius: 15,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "هذا الحقل مطلوب".tr;
              }
              if (!value.startsWith('00')) {
                return "يجب أن يبدأ الرقم بمفتاح الدولة".tr;
              }
              return null;
            },
            onChanged: (value) => controller.PhoneNumberForget.text = value,
          ),
          SizedBox(height: 15.h),
          Text(
            "أدخل الرقم مع مفتاح الدولة (مثال: 00964)".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.redColor,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AuthController controller) {
    return Column(
      children: [
        _buildVerifyButton(controller),
        SizedBox(height: 20.h),
        TextButton(
          onPressed: () {
            Get.back(); // إغلاق نافذة تسجيل الدخول
            Get.dialog(
              SignupPopup(),
              barrierDismissible: true,
            );
          },
          child: Text(
            "ليس لديك حساب؟ سجل الآن".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.TheMain,
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
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
          onTap: () {
            controller.isGoFromWeb.value = true;
            controller.getUserData(
              controller.nameUserForget.text,
              controller.PhoneNumberForget.text,
              Get.context!,
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "التحقق".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                  ),
                ),
                Icon(Icons.verified_user_rounded,
                    color: Colors.white, size: 24.sp),
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
                      "جارٍ التحقق من البيانات...".tr,
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

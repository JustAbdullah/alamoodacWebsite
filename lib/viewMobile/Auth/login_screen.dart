import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';
import 'forget_account.dart';
import 'sign_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put<AuthController>(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      body: Stack(
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
                            "مرحبًا بعودتك!".tr,
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.TheMain,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "سجل الدخول لاستئناف رحلتك".tr,
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.balckColorTypeThree,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
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
                                  controller: controller.textControllerName,
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
                                      return "يجب إدخال اسم المستخدم".tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    controller.nameEnter.value = value;
                                  },
                                ),
                                SizedBox(height: 20.h),
                                GetX<AuthController>(
                                  builder: (controller) => TextFormFieldCustom(
                                    maxLines: 1,
                                    label: "كلمة المرور".tr,
                                    hint: "أدخل كلمة المرور".tr,
                                    icon: Icons.lock_outline_rounded,
                                    controller:
                                        controller.textControllerPassword,
                                    fillColor: Colors.grey.shade50,
                                    hintColor: Colors.grey.shade500,
                                    iconColor: AppColors.TheMain,
                                    borderColor: Colors.transparent,
                                    fontColor: Colors.black,
                                    obscureText:
                                        !controller.isPasswordVisible.value,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey.shade600,
                                        size: 22.sp,
                                      ),
                                      onPressed: () =>
                                          controller.togglePasswordVisibility(),
                                    ),
                                    borderRadius: 15,
                                    keyboardType: TextInputType.visiblePassword,
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "يجب إدخال كلمة المرور".tr;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      controller.passwordEnter.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.h),
                          _LoginButton(controller: controller),
                          SizedBox(height: 20.h),
                          _buildBottomActions(),
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
    );
  }

  Widget _buildBottomActions() {
    return Column(
      children: [
        TextButton(
          onPressed: () => Get.to(SignScreen()),
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
        SizedBox(height: 10.h),
        TextButton(
          onPressed: () => Get.to(ForgetAccountScreen()),
          child: Text(
            "نسيت كلمة المرور؟".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.redColor,
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 30.h),
        _GuestButton(),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final AuthController controller;
  const _LoginButton({required this.controller});

  @override
  Widget build(BuildContext context) {
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
            if (controller.textControllerName.text.isNotEmpty &&
                controller.textControllerPassword.text.isNotEmpty) {
              controller.loginMobile(
                  controller.nameEnter.value, controller.passwordEnter.value);
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تسجيل الدخول".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                  ),
                ),
                Icon(Icons.login_rounded, color: Colors.white, size: 24.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => Get.offAll(HomeScreen()),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "المتابعة كزائر".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: AppColors.balckColorTypeThree,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(Icons.explore_outlined,
                    color: AppColors.TheMain, size: 24.sp),
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
    return GetX<AuthController>(
        builder: (controller) => Visibility(
            visible: controller.waitCheckData.value,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
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
                              "جاري تسجيل الدخول...".tr,
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
            )));
  }
}

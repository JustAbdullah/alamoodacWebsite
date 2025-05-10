import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';
import '../OnAppPages/on_app_pages.dart';
import '../Settings/chose_terms.dart';
import 'login_screen.dart';

class SignScreen extends StatelessWidget {
  SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

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
                            "انضم إلينا بسهولة".tr,
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.TheMain,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "أنشئ حسابك في دقيقتين".tr,
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.balckColorTypeThree,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          _SignupForm(controller: controller),
                          const Spacer(),
                          Column(
                            children: [
                              SizedBox(height: 30.h),
                              _GuestButton(controller: controller),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "لديك حساب؟".tr,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      color: AppColors.balckColorTypeThree,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Get.off(() => LoginScreen()),
                                    child: Text(
                                      "سجل الدخول الآن".tr,
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.DinarOne,
                                        color: AppColors.TheMain,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: () =>
                                      Get.to(() => AboutTermsPrivacyPage()),
                                  child: Text(
                                    "بالاستمرار أنت توافق على الشروط والأحكام"
                                        .tr,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      color: AppColors.balckColorTypeFour,
                                      fontSize: 12.sp,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({required this.controller});
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
              // Name Field
              TextFormFieldCustom(
                maxLines: 1,
                label: "اسم المستخدم".tr,
                hint: "مثال: أحمد محمد".tr,
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
                    return "يجب ألا يقل الاسم عن 3 أحرف".tr;
                  }
                  if (value.trim().length < 3) {
                    return "الاسم قصير جدًا (3 أحرف على الأقل)".tr;
                  }
                  return null;
                },
                onChanged: (value) => controller.validateForm(),
              ),

              SizedBox(height: 20.h),

              // Password Field
              TextFormFieldCustom(
                maxLines: 1,
                label: "كلمة المرور".tr,
                hint: "أدخل كلمة مرور قوية".tr,
                icon: Icons.lock_outline_rounded,
                controller: controller.textControllerPassword,
                fillColor: Colors.grey.shade50,
                hintColor: Colors.grey.shade500,
                iconColor: AppColors.TheMain,
                borderColor: Colors.transparent,
                fontColor: Colors.black,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey.shade600,
                    size: 22.sp,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
                borderRadius: 15,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يجب ألا تقل كلمة المرور عن 4 أحرف".tr;
                  }
                  if (value.trim().length < 4) {
                    return "كلمة المرور قصيرة جدًا (4 أحرف على الأقل)".tr;
                  }
                  return null;
                },
                onChanged: (value) => controller.validateForm(),
              ),
            ],
          ),
        ),

        SizedBox(height: 25.h),

        // Register Button
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: controller.isFormValid.value
              ? Material(
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
                      onTap: () => controller.registerMobile(
                        controller.textControllerName.text.trim(),
                        controller.textControllerPassword.text.trim(),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Text(
                          "أنشئ الحساب".tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.whiteColor,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : _buildErrorText("املأ جميع الحقول بشكل صحيح".tr),
        ),
      ],
    );
  }

  Widget _buildErrorText(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.red.shade600,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// باقي الودجات تبقى كما هي (_GuestButton, _LoadingOverlay) مع إزالة الودجات الغير مستخدمة

class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.controller});
  final AuthController controller;

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
          onTap: () => Get.to(HomeScreen()),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "استكشف التطبيق كزائر".tr,
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
  const _LoadingOverlay({required this.controller});
  final AuthController controller;

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
                          "جاري إنشاء حسابك...".tr,
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
        ),
      ),
    );
  }
}

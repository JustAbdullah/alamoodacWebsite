import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';
import 'forget_account_desktop.dart';
import 'sign_screen_desktop.dart';


import '../../controllers/LoadingController.dart';


class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final LoadingController loadingController = Get.find<LoadingController>();

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
          child: Obx(() {
            if (authController.waitCheckData.value) {
              return Center(
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
                        color: AppColors.TheMain,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      ImagesPath.logo,
                      width: 100.w,
                      height: 100.h,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "مرحبًا بعودتك!".tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: AppColors.TheMain,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "سجل الدخول لاستئناف رحلتك".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // حقل اسم المستخدم
                    SizedBox(
                      width: 400.w,
                      child: TextFormFieldCustom(
                        maxLines: 1,
                        label: "اسم المستخدم".tr,
                        hint: "أدخل اسم المستخدم".tr,
                        icon: Icons.person_outline_rounded,
                        controller: authController.textControllerName,
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
                          authController.nameEnter.value = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // حقل كلمة المرور
                    GetX<AuthController>(
                        builder: (controller) => SizedBox(
                              width: 400.w,
                              child: TextFormFieldCustom(
                                maxLines: 1,
                                label: "كلمة المرور".tr,
                                hint: "أدخل كلمة المرور".tr,
                                icon: Icons.lock_outline_rounded,
                                controller:
                                    authController.textControllerPassword,
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
                                    size: 14.sp,
                                  ),
                                  onPressed: () =>
                                      controller.togglePasswordVisibility(),
                                ),
                                borderRadius: 15,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "يجب إدخال كلمة المرور".tr;
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  authController.passwordEnter.value = value;
                                },
                              ),
                            )),
                    SizedBox(height: 25.h),

                    // زر تسجيل الدخول
                    _LoginButton(
                      controller: authController,
                      loadingController: loadingController,
                    ),
                    SizedBox(height: 15.h),

                    // رابط نسيت كلمة المرور
                    TextButton(
                      onPressed: () {
                        Get.back(); // إغلاق نافذة تسجيل الدخول
                        Get.dialog(
                          ForgetAccountScreenDeskTop(),
                          barrierDismissible: true,
                        );
                      },
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
                    SizedBox(height: 10.h),

                    // رابط إنشاء حساب جديد
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
                    SizedBox(height: 10.h),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final AuthController controller;
  final LoadingController loadingController;

  const _LoginButton({
    required this.controller,
    required this.loadingController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.TheMain,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        onPressed: () async {
          if (controller.textControllerName.text.isEmpty ||
              controller.textControllerPassword.text.isEmpty) {
            Get.snackbar(
              "خطأ".tr,
              "يجب إدخال اسم المستخدم وكلمة المرور".tr,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          try {
            await controller.login(
              controller.textControllerName.text,
              controller.textControllerPassword.text,
            );

            // بعد تسجيل الدخول الناجح
            if (controller.currentUser != null) {
              await loadingController.loadUserDataOnUpdate();

              // يمكنك إضافة أي إجراءات إضافية هنا بعد تسجيل الدخول
            }
          } catch (e) {
            Get.snackbar(
              "خطأ".tr,
              "حدث خطأ أثناء تسجيل الدخول".tr,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: Text(
          "تسجيل الدخول".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

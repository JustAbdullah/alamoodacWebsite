
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/AuthController.dart';
import '../../../controllers/LoadingController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/settingsController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../customWidgets/custome_textfiled.dart';
import '../../AuthDeskTop/login_screen_desktop.dart';

class QuesSaveAccountDeskTopPage extends StatelessWidget {
  const QuesSaveAccountDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    final loadingController = Get.find<LoadingController>();
    final ThemeController themeController = Get.find();

    return GetX<Settingscontroller>(
        builder: (controller) => Visibility(
            visible:true,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.92,
                color:
                    AppColors.backgroundColor(themeController.isDarkMode.value),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      InkWell(
                        onTap: () {
                          controller.enterDataSaveAccountTwo.value = false;
                          Get.back();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              ImagesPath.back,
                              width: 20.w,
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "العودة".tr,
                              // ignore: deprecated_member_use
                              style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  color: AppColors.textColor(
                                      themeController.isDarkMode.value),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "الخـطوة الثانية إضافة وسيلة الامان".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "إضافة وسيلة الامان سيساعدك في عملية تامين حسابك وإمكانية إستعادته عند فقدانه".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "قم بإدخال أسئلة الأمان الخاصة بك".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 500.w,
                        child: TextFormFieldCustom(
                          maxLines: 3,
                          label: "السؤال الأول".tr,
                          hint: "أدخل هنا سؤال يخصك لتأمين الحساب".tr,
                          icon: Icons.safety_check,
                          controller: controller.QuOneText,
                          fillColor: Colors.grey.shade200,
                          hintColor: Colors.grey.shade500,
                          iconColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          borderColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          fontColor: Colors.black,
                          obscureText: false,
                          borderRadius: 15,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.name],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال  سؤال الأمان".tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.QuOneText.text = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 500.w,
                        child: TextFormFieldCustom(
                          maxLines: 3,
                          label: "إجابة السؤال الأول".tr,
                          hint: "أدخل هنا إجابة السؤال الأول".tr,
                          icon: Icons.safety_check,
                          controller: controller.AnsOneText,
                          fillColor: Colors.grey.shade200,
                          hintColor: Colors.grey.shade500,
                          iconColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          borderColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          fontColor: Colors.black,
                          obscureText: false,
                          borderRadius: 15,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.name],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال جواب سؤال الأمان".tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.AnsOneText.text = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 500.w,
                        child: TextFormFieldCustom(
                          maxLines: 3,
                          label: "السؤال الثاني".tr,
                          hint: "أدخل هنا سؤال يخصك لتأمين الحساب".tr,
                          icon: Icons.safety_check,
                          controller: controller.QuTwoText,
                          fillColor: Colors.grey.shade200,
                          hintColor: Colors.grey.shade500,
                          iconColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          borderColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          fontColor: Colors.black,
                          obscureText: false,
                          borderRadius: 15,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.name],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال  سؤال الأمان ".tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.QuTwoText.text = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                     SizedBox(
                        width: 500.w,
                        child: TextFormFieldCustom(
                          maxLines: 3,
                          label: "إجابة السؤال الثاني".tr,
                          hint: "أدخل هنا إجابة السؤال الثاني".tr,
                          icon: Icons.safety_check,
                          controller: controller.AnsTwoText,
                          fillColor: Colors.grey.shade200,
                          hintColor: Colors.grey.shade500,
                          iconColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          borderColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                          fontColor: Colors.black,
                          obscureText: false,
                          borderRadius: 15,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.name],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال جواب سؤال الأمان ".tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.AnsTwoText.text = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (loadingController.currentUser == null) {
                            // عرض Snackbar إذا لم يتم العثور على بيانات المستخدم
                            Get.snackbar(
                              '', // اترك العنوان فارغًا لأنك ستستخدم titleText
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
                                'لاتستطيع القيام بهذه العملية قم بتسجيل دخولك اولاً'
                                    .tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                              mainButton: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), // لون الخلفية
                                  foregroundColor: Colors.white, // لون النص
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8), // شكل الزر
                                  ),
                                ),
                                onPressed: () {
                                  // التوجيه إلى شاشة تسجيل الدخول
                                       showDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => const LoginPopup(),
);
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
                          } else {
                            controller.verifyAccount(
                                phone: controller.phoneNumberText.value.text
                                    .toString(),
                                securityQuestion1:
                                    controller.QuOneText.text.toString(),
                                securityAnswer1:
                                    controller.AnsOneText.text.toString(),
                                securityQuestion2:
                                    controller.QuTwoText.text.toString(),
                                securityAnswer2:
                                    controller.AnsTwoText.text.toString(),
                                context: context);

                                Get.back();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "الحفظ".tr,
                            style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ]))))));
  }
}

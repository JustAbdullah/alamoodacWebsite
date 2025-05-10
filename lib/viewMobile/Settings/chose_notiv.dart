import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../Auth/login_screen.dart';

class ChoseNotiv extends StatelessWidget {
  const ChoseNotiv({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingController = Get.find<LoadingController>();

    return GetX<Settingscontroller>(
        builder: (controller) => Visibility(
            visible: controller.showNotiv.value,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.92,
                color: AppColors.whiteColorTypeOne,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      InkWell(
                        onTap: () {
                          controller.showNotiv.value = false;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                color: AppColors.balckColorTypeFour,
                                fontSize: 18.sp,
                              ),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "تفعيل التنبيهات".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.blackColorTypeTeo,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "الان تمتع بوصول الإشعارات الحديثة إليك عند إضافة العروض والصفقات الخاصة"
                            .tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.balckColorTypeFour,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "أضغط على زر تفعيل الإشعارات والبدء الان".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.balckColorTypeFour,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
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
                                      AppColors.TheMain, // لون الخلفية
                                  foregroundColor: Colors.white, // لون النص
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8), // شكل الزر
                                  ),
                                ),
                                onPressed: () {
                                  // التوجيه إلى شاشة تسجيل الدخول
                                  Get.to(LoginScreen());
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
                          } else {}
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.TheMain,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "تـــفعيل الإشعارات".tr,
                            style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                color: AppColors.balckColorTypeFour,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Text(
                        "ملاحظة هذه الخاصية للحسابات المشتركة في الباقات الخاصة"
                            .tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.redColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ]))))));
  }
}

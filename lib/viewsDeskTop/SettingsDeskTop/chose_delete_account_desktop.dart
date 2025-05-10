import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../AuthDeskTop/login_screen_desktop.dart';

class ChoseDeleteAccountDeskTopPage  extends StatelessWidget {
  ChoseDeleteAccountDeskTopPage ({super.key});

  @override
  Widget build(BuildContext context) {
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
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      InkWell(
                        onTap: () {
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
                        "حذف الحــساب".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.redColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "إننا نقوم بإعطائك الحرية في أي وقت تشاء لحذف وتعطيل حسابك ولكن عليك مراعاة الشروط التالية"
                            .tr,
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
                        "لايمكن حذف حسابك او تعطيله بعد نشر اي منشور في اي قسم ما"
                            .tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            fontSize: 16.sp,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "عليك الضغط على زر حذف الحساب لبدء عملية الحذف".tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            fontSize: 16.sp,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "بعد عملية حذف الحساب لن نستطيع  تسجيل الدخول مجددًا او المطالبة بإستعادة الحساب مهما كان السبب"
                            .tr,
                        style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
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
                          } else {}
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.redColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "البدء الان بحذف الحساب".tr,
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

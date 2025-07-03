import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../customWidgets/custome_textfiled.dart';

class NewPasswordInForgetDeskTop extends StatelessWidget {
  NewPasswordInForgetDeskTop({super.key});

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
                      GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: SafeArea(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height,
                              ),
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 40.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30.h),
                                      Image.asset(
                                        ImagesPath.logoText,
                                        width: 80.w,
                                        height: 80.h,
                                      ),
                                      SizedBox(height: 15.h),
                                      Text(
                                        "أستعادة كلمة المرور".tr,
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.TheMain,
                                          fontSize: 21.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        "مرحـــبا بك..".tr,
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeThree,
                                          fontSize: 19.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        "قم بإدخال كلمة المرور الجديدة".tr,
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                          fontSize: 16.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 25.h),
                                      TextFormFieldCustom(
                                        maxLines: 1,
                                        label: "كلمة المرور ".tr,
                                        hint: "أدخل كلمة المرور ".tr,
                                        icon: Icons.password,
                                        controller:
                                            controller.newPassworsInForget,
                                        fillColor: Colors.grey.shade200,
                                        hintColor: Colors.grey.shade500,
                                        iconColor: AppColors.TheMain,
                                        borderColor: AppColors.TheMain,
                                        fontColor: Colors.black,
                                        obscureText: true,
                                        borderRadius: 15,
                                        keyboardType: TextInputType.text,
                                        autofillHints: const [
                                          AutofillHints.username
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "الرجاء إدخال اسم كلمة المرور"
                                                .tr;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          controller.newPassworsInForget.text =
                                              value;
                                        },
                                      ),
                                      Spacer(flex: 1),
                                      Align(
                                          alignment: Alignment.center,
                                          child: InkWell(
                                            onTap: () {
                                              controller.updatePassword(
                                                  controller
                                                      .idUserInForget.value,
                                                  controller
                                                      .newPassworsInForget.text
                                                      .toString(),
                                                  context);
                                            },
                                            child: Container(
                                              width: 270.w,
                                              height: 37.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "الحفظ الان".tr,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTextStyles
                                                                .DinarOne,
                                                        color: controller
                                                                .isButtonEnabledNext
                                                                .value
                                                            ? AppColors
                                                                .whiteColor
                                                            : AppColors
                                                                .balckColorTypeThree,
                                                        fontSize: 19.sp,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Image.asset(
                                                      ImagesPath.arrowLeft,
                                                      width: 30.w,
                                                      height: 30.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

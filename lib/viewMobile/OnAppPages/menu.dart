import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/subscriptionController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/localization/changelanguage.dart';
import '../Auth/login_screen.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());

    LoadingController loadingController = Get.put(LoadingController());
    return GetX<HomeController>(
        builder: (controller) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color:
                        AppColors.cardColor(themeController.isDarkMode.value),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 3.w,
                          ),
                          Container(
                            color: AppColors.cardColor(
                                themeController.isDarkMode.value),
                            alignment: Alignment.center,
                            width: 70.w,
                            height: 50.h,
                            child: SingleChildScrollView(
                              child: InkWell(
                                onTap: () {
                                  controller.isChosedHome();
                                  Get.offNamed(
                                    '/mobile', // المسار مع المعلمة الديناميكية
                                    // إرسال الكائن كامل
                                  );
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.isHome.value
                                            ? ImagesPath.redHome
                                            : ImagesPath.homeOne,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            "الرئيسية".tr,
                                            // ignore: deprecated_member_use
                                            style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: controller.isHome.value
                                                    ? AppColors.oragne
                                                    : AppColors.textColor(
                                                        themeController
                                                            .isDarkMode.value),
                                                fontSize: 13.sp,
                                                fontWeight:
                                                    controller.isHome.value
                                                        ? FontWeight.bold
                                                        : FontWeight.w500),

                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ]),
                              ),
                            ),
                          ),
                          Container(
                              color: AppColors.cardColor(
                                  themeController.isDarkMode.value),
                              alignment: Alignment.center,
                              width: 70.w,
                              height: 50.h,
                              child: SingleChildScrollView(
                                child: InkWell(
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
                                            backgroundColor: AppColors
                                                .TheMain, // لون الخلفية
                                            foregroundColor:
                                                Colors.white, // لون النص
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // شكل الزر
                                            ),
                                          ),
                                          onPressed: () {
                                            // التوجيه إلى شاشة تسجيل الدخول
                                            Get.to(LoginScreen());
                                          },
                                          child: Text(
                                            'تسجيل الدخول'.tr,
                                            style: TextStyle(
                                              fontFamily:
                                                  AppTextStyles.DinarOne,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        duration: const Duration(seconds: 3),
                                      );
                                    } else {
                                      Userdahsboardcontroller
                                          userdahsboardcontroller =
                                          Get.put(Userdahsboardcontroller());
                                             userdahsboardcontroller.  fetchPosts  (Get.find<ChangeLanguageController>()
                                              .currentLocale
                                              .value
                                              .languageCode);
                                      userdahsboardcontroller.fetchStroePuscher(
                                          Get.find<ChangeLanguageController>()
                                              .currentLocale
                                              .value
                                              .languageCode);
                                      final subController =
                                          Get.put(SubscriptionController());
                                      subController.fetchUserSubscriptions(
                                          Get.find<LoadingController>()
                                                  .currentUser
                                                  ?.id ??
                                              0,
                                          Get.find<ChangeLanguageController>()
                                              .currentLocale
                                              .value
                                              .languageCode);
                                      Get.offNamed(
                                        '/dashboard-mobile/',
                                      );
                                      controller.isChosedInfo();
                                    }
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          controller.isInfo.value
                                              ? ImagesPath.redUser
                                              : ImagesPath.userOne,
                                          width: 20.w,
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            "معلوماتي".tr,
                                            // ignore: deprecated_member_use
                                            style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: controller.isInfo.value
                                                    ? AppColors.oragne
                                                    : AppColors.textColor(
                                                        themeController
                                                            .isDarkMode.value),
                                                fontSize: 13.sp,
                                                fontWeight:
                                                    controller.isInfo.value
                                                        ? FontWeight.bold
                                                        : FontWeight.w500),

                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]),
                                ),
                              )),
                          SizedBox(
                            width: 50.w,
                          ),
                          InkWell(
                            onTap: () {
                              controller.isChosedSearch();
                              Get.offNamed(
                                '/search-mobile', // المسار مع المعلمة الديناميكية
                                // إرسال الكائن كامل
                              );
                            },
                            child: Container(
                              color: AppColors.cardColor(
                                  themeController.isDarkMode.value),
                              alignment: Alignment.center,
                              width: 70.w,
                              height: 50.h,
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.isSearch.value
                                            ? ImagesPath.redSearch
                                            : ImagesPath.searchOne,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            "البحث".tr,
                                            // ignore: deprecated_member_use
                                            style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: controller.isSearch.value
                                                    ? AppColors.oragne
                                                    : AppColors.textColor(
                                                        themeController
                                                            .isDarkMode.value),
                                                fontSize: 13.sp,
                                                fontWeight:
                                                    controller.isSearch.value
                                                        ? FontWeight.bold
                                                        : FontWeight.w500),

                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ]),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.isChosedMenu();
                              Get.offNamed(
                                '/settings-mobile', // المسار مع المعلمة الديناميكية
                                // إرسال الكائن كامل
                              );
                            },
                            child: Container(
                              color: AppColors.cardColor(
                                  themeController.isDarkMode.value),
                              alignment: Alignment.center,
                              width: 70.w,
                              height: 50.h,
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.isMenu.value
                                            ? ImagesPath.redSettings
                                            : ImagesPath.MenuOne,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        width: 50.w,
                                        child: Text(
                                          "الإعدادت".tr,
                                          // ignore: deprecated_member_use
                                          style: TextStyle(
                                              fontFamily:
                                                  AppTextStyles.DinarOne,
                                              color: controller.isMenu.value
                                                  ? AppColors.oragne
                                                  : AppColors.textColor(
                                                      themeController
                                                          .isDarkMode.value),
                                              fontSize: 13.sp,
                                              fontWeight:
                                                  controller.isMenu.value
                                                      ? FontWeight.bold
                                                      : FontWeight.w500),

                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
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
                        } else {
                          final subController =
                              Get.put(SubscriptionController());

                          subController.fetchUserSubscriptions(
                              Get.find<LoadingController>().currentUser?.id ??
                                  0,
                              Get.find<ChangeLanguageController>()
                                  .currentLocale
                                  .value
                                  .languageCode);
                          controller.isChosedAddPost();
                          Get.offNamed(
                            '/add-post-mobile', // المسار مع المعلمة الديناميكية
                            // إرسال الكائن كامل
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 60.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.oragne,
                            ),
                            child: Image.asset(
                              ImagesPath.add,
                              width: 25.w,
                              height: 25.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              "إضافة منشور".tr,
                              // ignore: deprecated_member_use
                              style: TextStyle(
                                  fontFamily: AppTextStyles.DinarOne,
                                  color: controller.addPost.value
                                      ? AppColors.oragne
                                      : AppColors.textColor(
                                          themeController.isDarkMode.value),
                                  fontSize: 9.5.sp,
                                  fontWeight: controller.addPost.value
                                      ? FontWeight.bold
                                      : FontWeight.w500),

                              textAlign: TextAlign.center, maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

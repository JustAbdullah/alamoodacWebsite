import 'package:alamoadac_website/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/appcolors.dart';
import '../../customWidgets/custom_flag_desktop.dart';
import '../../customWidgets/custom_logo.dart';
import '../AuthDeskTop/login_screen_desktop.dart';
import '../SettingsDeskTop/chose_route_desktop.dart';
import '../SidePopup.dart';

class TopSectionDeskTop extends StatefulWidget {
  const TopSectionDeskTop({super.key});

  @override
  State<TopSectionDeskTop> createState() => _TopSectionDeskTopState();
}

class _TopSectionDeskTopState extends State<TopSectionDeskTop> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final LoadingController loadingController = Get.find();
    final HomeController homeController = Get.find();

    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor(themeController.isDarkMode.value),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Section
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSettingsButton(homeController, context),
                  const SizedBox(width: 30),
                  // إضافة قسم اختيار الدولة هنا
             //     _buildCountrySelector(homeController),
                  const SizedBox(width: 30),
                  _buildUserSection(
                      loadingController, themeController, context),
                ],
              ),
            ),

            // Right Section
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CustomFlagDeskTop(),
                  const SizedBox(width: 25),
                  _buildThemeToggle(themeController),
                  const SizedBox(width: 25),
                  _buildHoverLogo(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // دالة لبناء قسم اختيار الدولة
  /*Widget _buildCountrySelector(HomeController homeController) {
    final Settingscontroller settingsController = Get.find();
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
         showSidePopup(
                      context: context,
                      child: const ChoseRouteDesktop(),
                      widthPercent: 0.30,
                      useSideAlignment: true,);
          settingsController.showTheRoute.value = true;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 18.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 10.w),
              GetX<HomeController>(
                builder: (controller) => Text(
                  homeController.selectedRoute.value.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  Widget _buildHoverLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: EdgeInsets.all(8.w),
        child: const CustomLogo(),
      ),
    );
  }

  Widget _buildThemeToggle(ThemeController themeController) {
    return Obx(() => Tooltip(
          message: themeController.isDarkMode.value
              ? 'الوضع الفاتح'
              : 'الوضع المظلم',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: themeController.isDarkMode.value
                    ? [Colors.amber[300]!, Colors.orange]
                    : [Colors.indigo, Colors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: IconButton(
              icon: themeController.isDarkMode.value
                  ? Icon(Icons.wb_sunny, size: 24.sp)
                  : Icon(Icons.nightlight_round, size: 24.sp),
              color: Colors.white,
              onPressed: () {
                if (themeController.isDarkMode.value) {
                  themeController.enableLightMode();
                } else {
                  themeController.enableDarkMode();
                }
                setState(() {});
              },
              splashRadius: 25.r,
            ),
          ),
        ));
  }
}

Widget _buildSettingsButton(HomeController controller, BuildContext context) {
  return Tooltip(
    message: 'الإعدادات',
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withOpacity(0.1),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.settings,
          size: 24.sp,
          color:
              AppColors.iconColor(Get.find<ThemeController>().isDarkMode.value),
        ),
        onPressed: () => controller.showSettingsPopup(context),
        splashRadius: 25.r,
      ),
    ),
  );
}

Widget _buildUserSection(
  LoadingController controller,
  ThemeController themeController,
  BuildContext context,
) {
  return GetBuilder<LoadingController>(
    builder: (_) {
      final user = controller.currentUser;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          key: ValueKey(user?.id ?? 'guest'),
          onTap: () {
            if (user == null) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => const LoginPopup(),
              );
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.TheMain.withOpacity(0.15),
                    AppColors.TheMainLight.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.3),
                          AppColors.accentColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null ? "مرحباً".tr : "سجل دخولك".tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeController.isDarkMode.value
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.primaryColor,
                        ),
                      ),
                      if (user != null)
                        Text(
                          user.name ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
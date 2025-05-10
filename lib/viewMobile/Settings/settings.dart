import 'package:alamoadac_website/viewMobile/Settings/show_ask_add_code.dart';
import 'package:alamoadac_website/viewMobile/Settings/show_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../Auth/Terms.dart';
import '../OnAppPages/menu.dart';
import 'chose_conis.dart';
import 'chose_delete_account.dart';
import 'chose_lang.dart';
import 'chose_location.dart';
import 'chose_messages.dart';
import 'chose_mode.dart';
import 'chose_notiv.dart';
import 'chose_track.dart';
import 'createPusher/chose_pusher.dart';
import 'saveAccount/save_account.dart';
import 'show_ask_delete_account.dart';
import 'show_ask_promoted.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.find<Settingscontroller>();
    final loadingController = Get.find<LoadingController>();
    final controller = Get.put(Userdahsboardcontroller());

    return GetX<HomeController>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 5),
        child: controller.isMenu.value
            ? Scaffold(
                body: Stack(
                  children: [
                    _buildSettingsPanel(
                        themeController, settingsController, loadingController),
                    _BottomNavigationSection(),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildSettingsPanel(
    ThemeController themeController,
    Settingscontroller settingsController,
    LoadingController loadingController,
  ) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            decoration: BoxDecoration(
              color:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(20.w),
                      children: [
                        _buildSectionTitle("الإعدادات العامة".tr),
                        _buildSettingItem(
                            icon: MdiIcons.translate,
                            title: "اللغة",
                            onTap: () {
                              settingsController.showChoseLang.value = true;
                              Get.to(() => ChoseLang());
                            }),
                        _buildSettingItem(
                            icon: MdiIcons.currencyUsd,
                            title: "العملة",
                            onTap: () {
                              settingsController.showCoins.value = true;
                              Get.to(() => ChoseConis());
                            }),
                        _buildSettingItem(
                            icon: MdiIcons.shieldCheck,
                            title: "توثيق الحساب",
                            onTap: () {
                              settingsController.saveAccount.value = true;
                              Get.to(() => SaveAccount());
                            }),
                        _buildSettingItem(
                          icon: MdiIcons.packageVariant,
                          title: "الباقات",
                          onTap: () {
                            settingsController.showPack.value = true;
                            Get.to(() => ShowPackages());
                          }, // أضف المنطق المناسب هنا
                        ),
                        _buildSettingItem(
                          icon: MdiIcons.packageCheck,
                          title: "الاشتراك من خلال الاكواد".tr,
                          onTap: () {
                            settingsController.isShowAddCode.value = true;
                            Get.to(() => ShowAskAddCode());
                          }, // أضف المنطق المناسب هنا
                        ),
                        /* _buildSettingItem(
                          icon: MdiIcons.mapMarker,
                          title: "الموقع الجغرافي",
                          onTap: () =>
                              settingsController.showLocation.value = true,
                        ),*/
                        _buildDivider(),
                        _buildSectionTitle("المظهر".tr),
                        _buildSettingItem(
                            icon: MdiIcons.themeLightDark,
                            title: "مظهر التطبيق",
                            onTap: () {
                              settingsController.showMode.value = true;
                              Get.to(() => ChoseMode());
                            }),
                        _buildDivider(),
                        _buildSectionTitle("إدارة الحساب".tr),
                        _buildSettingItem(
                            icon: MdiIcons.viewDashboard,
                            title: "لوحة التحكم",
                            onTap: () {
                              Get.find<Userdahsboardcontroller>()
                                  .showDashBoardUser
                                  .value = true;

                              Get.toNamed(
                                '/dashboard-mobile', // المسار مع المعلمة الديناميكية
                                // إرسال الكائن كامل
                              );
                            }),
                        _buildSettingItem(
                            icon: MdiIcons.information,
                            title: "بيانات الناشر",
                            onTap: () {
                              settingsController.showPusher.value = true;
                              Get.to(() => ChosePusher());
                            }),
                        _buildSettingItem(
                            icon: MdiIcons.mapMarkerPath,
                            title: "تمويل المنشورات".tr,
                            onTap: () {
                              settingsController.showAskToPromotedAd.value =
                                  true;
                              Get.to(() => ShowAskPromoted());
                            }),
                        _buildSettingItem(
                            icon: MdiIcons.message,
                            title: "الرسائل والتنبيهات".tr,
                            onTap: () {
                              settingsController.showMessages.value = true;
                              settingsController.fetchMessages(
                                Get.find<LoadingController>().currentUser?.id ??
                                    0,
                              );
                              Get.to(() => ChoseMessages());
                            }),
                        _buildDivider(),
                        _buildSectionTitle("القوانين".tr),
                        _buildSettingItem(
                            icon: MdiIcons.fileDocument,
                            title: "الشروط والقوانين",
                            onTap: () => Get.to(() => AboutTermsPrivacyPage())),
                        _buildDivider(),
                        _buildSectionTitle("الخروج".tr),
                        _buildDangerousItem(
                            icon: MdiIcons.delete,
                            title: "حذف الحساب",
                            onTap: () {
                              settingsController.showAskToDeleteAccount.value =
                                  true;
                              Get.to(() => ShowAskDeleteAccount());
                            }),
                        _buildDangerousItem(
                            icon: MdiIcons.logout,
                            title: "تسجيل الخروج",
                            onTap: () {
                              _handleLogout(
                                  loadingController, settingsController);
                            }),
                        SizedBox(
                          height: 100.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ChoseLang(),
        ChoseConis(),
        ChoseNotiv(),
        ChoseLocation(),
        ChoseTrack(),
        ChoseDeleteAccount(),
        ChoseMode(),
        ChosePusher(),
        ShowAskPromoted(),
        ShowAskDeleteAccount(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.TheMain.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Text(
        "الإعدادات".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color:
              AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Text(
        title.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          color:
              AppColors.textColor(Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    final themeController = Get.find<ThemeController>();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.textColor(themeController.isDarkMode.value)
              .withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 24.sp,
            color: AppColors.backgroundColorIcon(
                themeController.isDarkMode.value)),
      ),
      title: Text(
        title.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          color: AppColors.textColor(themeController.isDarkMode.value),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18.sp,
        color: AppColors.textColor(themeController.isDarkMode.value)
            .withOpacity(0.5),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildDangerousItem({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.redColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 24.sp, color: AppColors.redColor),
      ),
      title: Text(
        title.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          color: AppColors.redColor,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 40.h,
      color: AppColors.TheMain.withOpacity(0.1),
      thickness: 1,
    );
  }

  void _handleLogout(LoadingController loadingController,
      Settingscontroller settingsController) {
    if (loadingController.currentUser == null) {
      Get.snackbar(
        'خطأ'.tr,
        'يجب تسجيل الدخول أولاً'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      settingsController.SignOut();
    }
  }
}

class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColors.backgroundColor(
            Get.find<ThemeController>().isDarkMode.value),
        width: MediaQuery.of(context).size.width,
        height: 70.h,
        child: const Menu(),
      ),
    );
  }
}

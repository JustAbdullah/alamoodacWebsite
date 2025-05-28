import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/chose_conis_desktop.dart';
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/chose_lang_desktop.dart';
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/show_ask_add_code_desktop.dart';
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/show_ask_delete_account_desktop.dart';
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/show_ask_promoted_desktop.dart';
import 'package:alamoadac_website/viewsDeskTop/SettingsDeskTop/show_packages_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// تم إزالة استيراد flutter_vector_icons

import '../../../controllers/ThemeController.dart';
import '../../../controllers/LoadingController.dart';
import '../../../controllers/settingsController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../controllers/subscriptionController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/localization/changelanguage.dart';
import '../SidePopup.dart';
import '../dashboardUserDeskTop/home_dashboard_user_dasktop.dart';
import 'chose_messages_desktop.dart';
import 'chose_mode_desktop.dart';
import 'chose_terms_desktop.dart';
import 'createPusher/chose_pusher_desktop.dart';
import 'saveAccount/save_account_desktop.dart';

class SettingsContentDeskTopPage extends StatelessWidget {
  const SettingsContentDeskTopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.find<Settingscontroller>();
    final loadingController = Get.find<LoadingController>();
    final controller = Get.put(Userdahsboardcontroller());

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
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
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  _buildSectionTitle("الإعدادات العامة".tr),
                  _buildSettingItem(
                    icon: Icons.translate,
                    title: "اللغة",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ChoseLangDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.attach_money,
                    title: "العملة",
                    onTap: () => showSidePopup(
                      context: context,
                      child: ChoseConisDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.verified_user,
                    title: "توثيق الحساب",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const SaveAccountDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.work,
                    title: "الباقات",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ShowPackagesDeskTopPage(),
                      widthPercent: 0.75,
                      useSideAlignment: false,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.confirmation_number,
                    title: "الاشتراك من خلال الاكواد".tr,
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ShowAskAddCodeDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildDivider(),
                  _buildSectionTitle("المظهر".tr),
                  _buildSettingItem(
                    icon: Icons.brightness_6,
                    title: "مظهر التطبيق",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ChoseModeDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildDivider(),
                  _buildSectionTitle("إدارة الحساب".tr),
                  _buildSettingItem(
                      icon: Icons.dashboard,
                      title: "لوحة التحكم",
                      onTap: () {
                        Userdahsboardcontroller userdahsboardcontroller =
                            Get.find<Userdahsboardcontroller>();
                        userdahsboardcontroller.fetchStroePuscher(
                            Get.find<ChangeLanguageController>()
                                .currentLocale
                                .value
                                .languageCode);
                        final subController =
                            Get.find<SubscriptionController>();
                        subController.fetchUserSubscriptions(
                            Get.find<LoadingController>().currentUser?.id ?? 0,
                            Get.find<ChangeLanguageController>()
                                .currentLocale
                                .value
                                .languageCode);

                        showSidePopup(
                          context: context,
                          child: const HomeDashboardUserDeskTop(),
                          widthPercent: 1,
                          useSideAlignment: true,
                        );
                      }),
                  _buildSettingItem(
                    icon: Icons.business,
                    title: "بيانات الناشر",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ChosePusherDesktop(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.local_offer,
                    title: "تمويل المنشورات".tr,
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ShowAskPromotedDeskTopPage(),
                      widthPercent: 0.40,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_active,
                    title: "الرسائل والتنبيهات".tr,
                    onTap: () {
                      settingsController.showMessages.value = true;
                      settingsController.fetchMessages(
                        Get.find<LoadingController>().currentUser?.id ?? 0,
                      );
                      showSidePopup(
                        context: context,
                        child: const ChoseMessagesDeskTop(),
                        widthPercent: 0.40,
                        useSideAlignment: true,
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSectionTitle("القوانين".tr),
                  _buildSettingItem(
                    icon: Icons.description,
                    title: "الشروط والقوانين",
                    onTap: () {
                      showSidePopup(
                        context: context,
                        child: const AboutTermsPrivacyPageDeskTopPage(),
                        widthPercent: 0.50,
                        useSideAlignment: true,
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSectionTitle("الخروج".tr),
                  _buildDangerousItem(
                    icon: Icons.delete_forever,
                    title: "حذف الحساب",
                    onTap: () => showSidePopup(
                      context: context,
                      child: const ShowAskDeleteAccountDeskTopPage(),
                      widthPercent: 0.30,
                      useSideAlignment: true,
                    ),
                  ),
                  _buildDangerousItem(
                    icon: Icons.logout,
                    title: "تسجيل الخروج",
                    onTap: () =>
                        _handleLogout(loadingController, settingsController),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          color: AppColors.textColor(
            Get.find<ThemeController>().isDarkMode.value,
          ),
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
          color: AppColors.textColor(
            Get.find<ThemeController>().isDarkMode.value,
          ).withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final themeController = Get.find<ThemeController>();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      leading: Container(
        padding: EdgeInsets.all(12.w), // زيادة الـ padding
        decoration: BoxDecoration(
          color: AppColors.textColor(themeController.isDarkMode.value)
              .withOpacity(0.15),
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.oragne.withOpacity(0.3),
              Colors.transparent.withOpacity(0.3),
            ],
          ),
        ),
        child: Icon(
          icon,
          size: 26.sp, // زيادة حجم الأيقونة
          color: AppColors.backgroundColorIcon(
            themeController.isDarkMode.value,
          ),
        ),
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      leading: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.redColor.withOpacity(0.15),
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.redColor.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
        child: Icon(icon, size: 26.sp, color: AppColors.redColor),
      ),
      title: Text(
        title.tr,
        style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 18.sp,
            color: AppColors.redColor),
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

  void _handleLogout(
    LoadingController loadingController,
    Settingscontroller settingsController,
  ) {
    if (loadingController.currentUser == null) {
      Get.snackbar(
        'خطأ'.tr,
        'يجب تسجيل الدخول أولاً'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'تم الخروج'.tr,
        "تم تسجيل الخروج بنجاح".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      settingsController.SignOutDeskTop();
    }
  }
}

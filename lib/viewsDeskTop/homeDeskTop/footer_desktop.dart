import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/ThemeController.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../SettingsDeskTop/chose_terms_desktop.dart';
import '../SettingsDeskTop/show_ask_promoted_desktop.dart';
import '../SettingsDeskTop/show_packages_desktop.dart';
import '../SidePopup.dart';
import '../dashboardUserDeskTop/home_dashboard_user_dasktop.dart';

class FooterDesktop extends StatelessWidget {
  const FooterDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return _buildPremiumFooter(themeController, context);
    });
  }
}

Widget _buildPremiumFooter(
    ThemeController themeController, BuildContext context) {
  final isDark = themeController.isDarkMode.value;
  final bgColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark ? Colors.white70 : Colors.black54;
  final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
  const sectionPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 24);

  return Semantics(
    container: true,
    label: 'Footer',
    child: Container(
      width: double.infinity,
      color: bgColor,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط تزييني
          Container(
            height: 4.h,
            width: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.TheMain, AppColors.TheMain.withOpacity(0.6)],
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),

          // الأعمدة الرئيسية
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شعار وتعريف
              Expanded(
                flex: 2,
                child: Padding(
                  padding: sectionPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(ImagesPath.logo,
                              width: 50.w, height: 50.h),
                          SizedBox(width: 12.w),
                          Text(
                            'على مودك'.tr,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'منصة الإعلانات المبوبة في العراق'.tr,
                        style: TextStyle(fontSize: 14.sp, color: subtitleColor),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'مطورة من طرف العاصمة للتسويق والبرمجة © 2025'.tr,
                        style: TextStyle(fontSize: 12.sp, color: subtitleColor),
                      ),
                    ],
                  ),
                ),
              ),

              // روابط عن المنصة
              Expanded(
                flex: 2,
                child: Padding(
                  padding: sectionPadding,
                  child: _footerLinks(
                    title: 'عن المنصة'.tr,
                    links: {
                      'من نحن'.tr: () {
                        showSidePopup(
                          context: context,
                          child: const AboutTermsPrivacyPageDeskTopPage(),
                          widthPercent: 0.50,
                          useSideAlignment: true,
                        );
                      },
                      'الشروط والقوانين'.tr: () {
                        showSidePopup(
                          context: context,
                          child: const AboutTermsPrivacyPageDeskTopPage(),
                          widthPercent: 0.50,
                          useSideAlignment: true,
                        );
                      },
                      'سياسة الخصوصية'.tr: () {
                        showSidePopup(
                          context: context,
                          child: const AboutTermsPrivacyPageDeskTopPage(),
                          widthPercent: 0.50,
                          useSideAlignment: true,
                        );
                      },
                    },
                    textColor: textColor,
                  ),
                ),
              ),

              // روابط خدماتنا
              Expanded(
                flex: 2,
                child: Padding(
                  padding: sectionPadding,
                  child: _footerLinks(
                    title: 'خدماتنا'.tr,
                    links: {
                      'نشر منشور الآن'.tr: () => Get.toNamed('/add-post'),
                      'الباقات'.tr: () => showSidePopup(
                            context: context,
                            child: const ShowPackagesDeskTopPage(),
                            widthPercent: 0.75,
                            useSideAlignment: false,
                          ),
                      'تمويل منشور'.tr: () => showSidePopup(
                            context: context,
                            child: const ShowAskPromotedDeskTopPage(),
                            widthPercent: 0.40,
                            useSideAlignment: true,
                          ),
                      'لوحة التحكم'.tr: () => showSidePopup(
                            context: context,
                            child: const HomeDashboardUserDeskTop(),
                            widthPercent: 1,
                            useSideAlignment: true,
                          ),
                    },
                    textColor: textColor,
                  ),
                ),
              ),

              // تواصل معنا
              Expanded(
                flex: 2,
                child: Padding(
                  padding: sectionPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تواصل معنا'.tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _contactItem(
                          Icons.email, 'info@alamoodac.com', textColor),
                      _contactItem(Icons.phone, '+964 770 123 4567', textColor),
                      _contactItem(Icons.access_time, 'أحد–خميس: 8 ص – 5 م'.tr,
                          textColor),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),
          Divider(color: dividerColor),
          SizedBox(height: 20.h),

          // أيقونات تواصل اجتماعي
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _socialIcon(Icons.facebook, AppColors.TheMain, isDark,
                    'https://facebook.com/yourpage'),
                SizedBox(width: 16.w),
                _socialIcon(Icons.telegram, Colors.blue[400]!, isDark,
                    'https://t.me/yourchannel'),
                SizedBox(width: 16.w),
                _socialIcon(Icons.youtube_searched_for, Colors.red, isDark,
                    'https://youtube.com/yourchannel'),
                SizedBox(width: 16.w),
                _socialIcon(Icons.phone_android_sharp, Colors.green, isDark,
                    'https://wa.me/9647701234567'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _footerLinks({
  required String title,
  required Map<String, VoidCallback> links,
  required Color textColor,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor),
        ),
        SizedBox(height: 8.h),
        ...links.entries
            .map((e) => _footerLink(e.key, e.value, textColor))
            .toList(),
      ],
    );

// هنا التعديل الرئيسي:
Widget _footerLink(String text, VoidCallback onTap, Color baseColor) {
  return TextButton(
    style: ButtonStyle(
      mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      minimumSize: MaterialStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.centerLeft,
    ),
    onPressed: onTap,
    child: Text(
      text,
      style: TextStyle(fontSize: 14.sp, color: baseColor.withOpacity(0.85)),
    ),
  );
}

Widget _contactItem(IconData icon, String label, Color baseColor) => Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: baseColor.withOpacity(0.8)),
          SizedBox(width: 8.w),
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: baseColor.withOpacity(0.8))),
        ],
      ),
    );

Widget _socialIcon(IconData icon, Color color, bool isDark, String url) {
  return InkWell(
    mouseCursor: SystemMouseCursors.click,
    borderRadius: BorderRadius.circular(18),
    onTap: () async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) launchUrl(uri);
    },
    child: Container(
      width: 36.w,
      height: 36.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.3 : 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18.sp),
    ),
  );
}

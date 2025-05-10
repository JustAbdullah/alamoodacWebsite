// File: promotion_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/subscriptionController.dart';
import '../../core/localization/changelanguage.dart';
import '../SettingsDeskTop/show_ask_promoted_desktop.dart';
import '../SettingsDeskTop/show_packages_desktop.dart';
import '../SidePopup.dart';

/// واجهة بسيطة ومحترفة لخطوتين: نشر المنشور وتمويل المنشور
class PromotionInfoSection extends StatelessWidget {
  const PromotionInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تدرجات لونية للبطاقتين
    final gradients = [
      [Color(0xFF4C9AFF), Color(0xFF0057D9)],
      [Color.fromARGB(255, 232, 173, 62), Color.fromARGB(255, 247, 167, 46)],
    ];

    // تعريف بيانات البطاقات
    final cards = [
      _InfoCardData(
        icon: Icons.post_add,
        title: "أنشئ منشور جديد".tr,
        subtitle: "ابدأ نشر إعلانك خلال دقائق".tr,
      ),
      _InfoCardData(
        icon: Icons.attach_money,
        title: "تمويل منشور".tr,
        subtitle: "اختر الخطة لتعزيز وصولك".tr,
      ),
    ];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 700),
      tween: Tween(begin: 0, end: 1),
      builder: (_, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cards.length, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _InfoCard(
                  data: cards[i],
                  gradient: gradients[i],
                  index: i,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _InfoCardData {
  final IconData icon;
  final String title;
  final String subtitle;

  _InfoCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _InfoCard extends StatefulWidget {
  final _InfoCardData data;
  final List<Color> gradient;
  final int index;

  const _InfoCard({
    Key? key,
    required this.data,
    required this.gradient,
    required this.index,
  }) : super(key: key);

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Transform.scale(
        scale: _hover ? 1.04 : 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _hover ? 18 : 8,
                offset: Offset(0, _hover ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.data.icon, size: 48.sp, color: Colors.white),
              SizedBox(height: 12.h),
              Text(
                widget.data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                widget.data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 16.h),
              // الأزرار حسب نوع البطاقة
              if (widget.index == 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final subController = Get.put(SubscriptionController());

                        subController.fetchUserSubscriptions(
                            Get.find<LoadingController>().currentUser?.id ?? 0,
                            Get.find<ChangeLanguageController>()
                                .currentLocale
                                .value
                                .languageCode);
                        Get.toNamed(
                          '/add-post',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: widget.gradient.last,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        'اذهب'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    TextButton(
                      onPressed: () {
                        showSidePopup(
                          context: context,
                          child: const ShowPackagesDeskTopPage(),
                          widthPercent: 0.75,
                          useSideAlignment: false,
                        );
                      },
                      child: Text(
                        'استعراض الباقات'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    showSidePopup(
                      context: context,
                      child: const ShowAskPromotedDeskTopPage(),
                      widthPercent: 0.40,
                      useSideAlignment: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.gradient.last,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 10.h,
                    ),
                  ),
                  child: Text(
                    'اذهب'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Controllers
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';

// Core Styles & Colors
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';

// Custom Widgets

import 'PromotedAdPage_desktop.dart';
import 'PromotionCard.dart';
import 'ad_section_desktop.dart';
import 'categories_desktop.dart';
import 'cutom_cart_post.dart';
import 'footer_desktop.dart';
import 'most_rating_post_desktop.dart';
import 'most_view_posts_desktop.dart';
import 'new_posts_desktop.dart';
import '../searchDeskTop/search_box_desktop.dart';
import 'top_section_desktop.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    // استخدام Get.put لتسجيل المتحكمات
    final ThemeController themeController = Get.put(ThemeController());
    final HomeController homeController = Get.put(HomeController());
    homeController.isSearchFromHome.value = false;

    return GetX<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              AppColors.backgroundColor(themeController.isDarkMode.value),
          body: Column(
            children: [
              const TopSectionDeskTop(),
              // Main Content Area
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Animated Categories Section
                      _buildAnimatedCategoriesSection(themeController),
                      SizedBox(
                        height: 7.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: PromotionInfoSection(),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      // Featured Ads Section
                      _buildFeaturedAdsSection(isRTL, themeController),
                      SizedBox(
                        height: 7.h,
                      ),
                      // Main Content with Sidebar (Smart Posts)
                      _buildSmartPost(themeController, homeController, isRTL),
                      SizedBox(
                        height: 7.h,
                      ),
                      // Premium Footer Section
                      FooterDesktop(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  Widget _buildAnimatedCategoriesSection(ThemeController themeController) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            SectionTitle(
              title: "التصنيفات الرئيسية".tr,
              icon: Icons.category,
              themeController: themeController,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تصفح المنشورات التى تريدها من خلال التصنيف المرغوب".tr,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontFamily: AppTextStyles.DinarOne,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const CategoriesPageWeb(),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  Widget _buildFeaturedAdsSection(bool isRTL, ThemeController themeController) {
    return Column(
      children: [
        SectionTitle(
          title: "إعلاناتنا الحالية".tr,
          icon: Icons.star,
          themeController: themeController,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "شاهد أحدث الإعلانات الخاصة والعروض الخاصة".tr,
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const AdSectionWebPage(),
        ),
      ],
    );
  }

  // ==========================================
  Widget _buildSmartPost(
      ThemeController themeController, HomeController controller, bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "المنشورات والبحث".tr,
          icon: Icons.category_outlined,
          themeController: themeController,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تصــفح المــنشورات وابحث من خلال صندوق البحث المتقدم".tr,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Obx(() {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // القسم الأيمن: صندوق البحث مع قائمة المنشورات (يمكن استخدام ListView.builder إذا كان عدد المنشورات كبيراً)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.h),
                    child: Column(
                      children: [
                        SearchBoxDeskTop(),
                        SizedBox(height: 3.h),
                        Container(
                          // هذا الحاوية تمثل المكان المخصص لعرض المنشورات
                          // يمكن استبدالها بـ ListView.builder لتحميل المنشورات بشكل lazy
                          height: 9100.h,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor(
                                themeController.isDarkMode.value),
                            borderRadius: BorderRadius.circular(0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                // القسم الأيسر: عرض المنشورات المفصلة
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromotedadpageDeskTopPage(),
                      SizedBox(height: 10.h),
                      const NewPostsDesktop(),
                      SizedBox(height: 10.h),
                      const MostViewPostsDesktop(),
                      SizedBox(height: 10.h),
                      const MostRatingPostDesktop(),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "المول الإلكتروني".tr,
                        isLoading: controller.LoadingPostsCateOne,
                        postsList: controller.postsListCateOne,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "سوق المستعمل".tr,
                        isLoading: controller.LoadingPostsCateTwo,
                        postsList: controller.postsListCateTwo,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "مركبات للبيع والايجار".tr,
                        isLoading: controller.LoadingPostsCateThree,
                        postsList: controller.postsListCateThree,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "المهن والحرف".tr,
                        isLoading: controller.LoadingPostsCateFour,
                        postsList: controller.postsListCateFour,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "منتجات من البيت".tr,
                        isLoading: controller.LoadingPostsCateFive,
                        postsList: controller.postsListCateFive,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "عقارات للبيع والإيجار".tr,
                        isLoading: controller.LoadingPostsCateSix,
                        postsList: controller.postsListCateSix,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "عروض وصفقات".tr,
                        isLoading: controller.LoadingPostsCateSeven,
                        postsList: controller.postsListCateSeven,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "المزاد الإلكتروني".tr,
                        isLoading: controller.LoadingPostsCateEight,
                        postsList: controller.postsListCateEight,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "متجر المنتجات العالمية".tr,
                        isLoading: controller.LoadingPostsCateNine,
                        postsList: controller.postsListCateNine,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الإعلانات الرسمية".tr,
                        isLoading: controller.LoadingPostsCateTen,
                        postsList: controller.postsListCateTen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "سوق الجملة والتوكيلات".tr,
                        isLoading: controller.LoadingPostsCateEleven,
                        postsList: controller.postsListCateEleven,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "فرص عمل".tr,
                        isLoading: controller.LoadingPostsCateTwelve,
                        postsList: controller.postsListCateTwelve,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "أفكار ومشاريع للتمويل".tr,
                        isLoading: controller.LoadingPostsCateThrteen,
                        postsList: controller.postsListCateThrteen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "المطاعم".tr,
                        isLoading: controller.LoadingPostsCateFourTeen,
                        postsList: controller.postsListCateFourTeen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "دليل الشركات".tr,
                        isLoading: controller.LoadingPostsCateFifteen,
                        postsList: controller.postsListCateFifteen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "منتجات من المرزعة".tr,
                        isLoading: controller.LoadingPostsCateSixteen,
                        postsList: controller.postsListCateSixteen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الخدمات التعليمية".tr,
                        isLoading: controller.LoadingPostsCateSeventeen,
                        postsList: controller.postsListCateSeventeen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "عمال يوميين".tr,
                        isLoading: controller.LoadingPostsCateEighteen,
                        postsList: controller.postsListCateEighteen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "خدمات الذكاء الاصطناعي".tr,
                        isLoading: controller.LoadingPostsCateNineteen,
                        postsList: controller.postsListCateNineteen,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الانشاءات مواد البناء",
                        isLoading: controller.LoadingPostsCateTwenty,
                        postsList: controller.postsListCateTwenty,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الالات والمعدات".tr,
                        isLoading: controller.LoadingPostsCateTwentyOne,
                        postsList: controller.postsListCateTwentyOne,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الزراعة والحيوان".tr,
                        isLoading: controller.LoadingPostsCateTwentyTwo,
                        postsList: controller.postsListCateTwentyTwo,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الصالونات الصحية والرياضية".tr,
                        isLoading: controller.LoadingPostsCateTwentyThree,
                        postsList: controller.postsListCateTwentyThree,
                      ),
                      SizedBox(height: 10.h),
                      CustomCardPostDeskTop(
                        title: "الحيوانات الأليفة".tr,
                        isLoading: controller.LoadingPostsCateTwentyFour,
                        postsList: controller.postsListCateTwentyFour,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// _buildPremiumFooter: تصميم فوتر متناسق ومحسّن لتطبيق "على مودك"
}

/// عنوان القسم الموحد
class SectionTitle extends StatelessWidget {
  final themeController;
  final String title;
  final IconData? icon;

  const SectionTitle(
      {Key? key, required this.title, this.icon, required this.themeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon,
                color: AppColors.backgroundColorIconBack(
                    themeController.isDarkMode.value),
                size: 24.sp),
            SizedBox(width: 10.w),
          ],
          Column(
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8.h),
              Skeletonizer(
                child: Container(
                  width: 90.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.backgroundColorIconBack(
                                themeController.isDarkMode.value)
                            .withOpacity(0.8),
                        AppColors.backgroundColorIconBackTwo(
                                themeController.isDarkMode.value)
                            .withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

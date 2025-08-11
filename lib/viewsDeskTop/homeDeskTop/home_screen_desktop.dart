import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Controllers
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';

// Core Styles & Colors
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';

// Custom Widgets

import '../../core/data/model/post.dart';
import '../../core/localization/changelanguage.dart';
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
    final ThemeController themeController = Get.find<ThemeController>();
    final HomeController homeController = Get.find<HomeController>();
        Searchcontroller searchcontroller = Get.find<Searchcontroller>();

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
                   /*   Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: PromotionInfoSection(),
                      ),*/
                      SizedBox(
                        height: 7.h,
                      ),
                      // Featured Ads Section
                  _buildFeaturedAdsSection(isRTL, themeController),
                      SizedBox(
                        height: 7.h,
                      ),
                      // Main Content with Sidebar (Smart Posts)
                      _buildSmartPost(themeController, homeController, isRTL,searchcontroller),
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
  Widget _buildFeaturedAdsSection(bool isRTL, ThemeController themeController,) {
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
      ThemeController themeController, HomeController controller, bool isRTL, Searchcontroller searchcontroller) {
        
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
                    _buildCategoryDesktop(
  controller,
  searchcontroller,
  "المول الإلكتروني".tr,
  controller.LoadingPostsCateOne,
  controller.postsListCateOne,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "سوق المستعمل".tr,
  controller.LoadingPostsCateTwo,
  controller.postsListCateTwo,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "مركبات للبيع والايجار".tr,
  controller.LoadingPostsCateThree,
  controller.postsListCateThree,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "عقارات للايجار".tr,
  controller.LoadingPostsCateThirty,
  controller.postsListCateThirty,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "عقارات للبيع".tr,
  controller.LoadingPostsCateSix,
  controller.postsListCateSix,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الحي الصناعي".tr,
  controller.LoadingPostsCateTwentyEight,
  controller.postsListCateTwentyEight,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "منتجات من البيت".tr,
  controller.LoadingPostsCateFive,
  controller.postsListCateFive,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "منتجات من المرزعة".tr,
  controller.LoadingPostsCateSixteen,
  controller.postsListCateSixteen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "المهن والحرف".tr,
  controller.LoadingPostsCateFour,
  controller.postsListCateFour,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "مكاتب ومؤسسات".tr,
  controller.LoadingPostsCateTwentySeven,
  controller.postsListCateTwentySeven,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الخدمات الطبية".tr,
  controller.LoadingPostsCateTwentyNine,
  controller.postsListCateTwentyNine,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الخدمات التعليمية".tr,
  controller.LoadingPostsCateSeventeen,
  controller.postsListCateSeventeen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الخدمات المالية".tr,
  controller.LoadingPostsCateTwentyFive,
  controller.postsListCateTwentyFive,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الخدمات المتنوعة".tr,
  controller.LoadingPostsCateTwentySix,
  controller.postsListCateTwentySix,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "خدمات الذكاء الاصطناعي".tr,
  controller.LoadingPostsCateNineteen,
  controller.postsListCateNineteen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "عمال يوميين".tr,
  controller.LoadingPostsCateEighteen,
  controller.postsListCateEighteen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "عروض وصفقات".tr,
  controller.LoadingPostsCateSeven,
  controller.postsListCateSeven,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "المزاد الإلكتروني".tr,
  controller.LoadingPostsCateEight,
  controller.postsListCateEight,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "فرص عمل".tr,
  controller.LoadingPostsCateTwelve,
  controller.postsListCateTwelve,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "أفكار ومشاريع للتمويل".tr,
  controller.LoadingPostsCateThrteen,
  controller.postsListCateThrteen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "دليل الشركات".tr,
  controller.LoadingPostsCateFifteen,
  controller.postsListCateFifteen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الالات والمعدات".tr,
  controller.LoadingPostsCateTwentyOne,
  controller.postsListCateTwentyOne,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "سوق الجملة والتوكيلات".tr,
  controller.LoadingPostsCateEleven,
  controller.postsListCateEleven,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الانشاءات مواد البناء",
  controller.LoadingPostsCateTwenty,
  controller.postsListCateTwenty,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الزراعة والحيوان".tr,
  controller.LoadingPostsCateTwentyTwo,
  controller.postsListCateTwentyTwo,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الحيوانات الأليفة".tr,
  controller.LoadingPostsCateTwentyFour,
  controller.postsListCateTwentyFour,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "مطاعم وكوفيهات".tr,
  controller.LoadingPostsCateFourTeen,
  controller.postsListCateFourTeen,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "الصالونات الصحية والرياضية".tr,
  controller.LoadingPostsCateTwentyThree,
  controller.postsListCateTwentyThree,
),
_buildCategoryDesktop(
  controller,
  searchcontroller,
  "متجر المنتجات العالمية".tr,
  controller.LoadingPostsCateNine,
  controller.postsListCateNine,
),
Visibility(
  visible: controller.selectedRoute.value == "العراق",
  child: _buildCategoryDesktop(
    controller,
    searchcontroller,
    "الاعلانات الرسمية".tr,
    controller.LoadingPostsCateTen,
    controller.postsListCateTen,
  ),
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
Widget _buildCategoryDesktop(
  HomeController controller,  Searchcontroller searchcontroller,
  String title,
  RxBool loading,
  RxList<Post> postsList,
) {
  return Column(
    children: [
      SizedBox(height: 10.h),
      CustomCardPostDeskTop(
        title: title,
        isLoading: loading,
        postsList: postsList,
        onTap: () {
          final firstPost = postsList.first;
          final categoryId = firstPost.categoryId.toString();
          
          controller.nameCategories.value = firstPost.category.translations.first.name;
          controller.idCategories.value = categoryId;
          
          controller.fetchSubcategories(
            int.parse(categoryId),
            Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
          );
          
          controller.fetchPostsAll(
            int.parse(categoryId),
            Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
            null,
            null,
             Get.find<HomeController>().         getCountryCode( Get.find<HomeController>().selectedRoute.value),
          );

          searchcontroller.subCategories.clear();
          searchcontroller.isChosedAndShowTheSub.value = false;
          searchcontroller.fetchSubcategories(
            int.parse(categoryId),
            Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
          ).then((_) {
            searchcontroller.isChosedAndShowTheSub.value = true;
          });
          
          searchcontroller.idOfCateSearchBox.value = int.parse(categoryId);
          print("/......................................");
          print(searchcontroller.idOfCateSearchBox.value);
          print("/......................................");
          
          searchcontroller.detailCarControllers["القسم الرئيسي"]?.text = categoryId;
          searchcontroller.detailRealestateControllers["القسم الرئيسي"]?.text = categoryId;
          searchcontroller.isOpenINSubPost.value = true;
          searchcontroller.selectedMainCategory = int.parse(categoryId);

          Get.toNamed('/Category', preventDuplicates: false);
        },
      ),
    ],
  );
}



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../core/localization/changelanguage.dart';
import '../OnAppPages/menu.dart';
import 'PromotedAdPage.dart';
import 'ad_section.dart';
import 'categories.dart';
import 'cutom_cart_post.dart';
import 'most_rating_post.dart';
import 'most_view_posts.dart';
import 'new_posts.dart';
import 'top_section.dart';

class SectionData<T> {
  final String title;
  final RxBool isLoading;
  final RxList<T> posts;
  final void Function()? onTap;

  SectionData(this.title, this.isLoading, this.posts, this.onTap);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // الحفاظ على الحالة عند التنقل

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    final ThemeController themeController = Get.find();
    final HomeController controller = Get.find<HomeController>();
    final Searchcontroller searchcontroller = Get.find<Searchcontroller>();

    return GetX<HomeController>(
      builder: (controller) {
        // دالة التعامل مع نقرة قسم محدد
        void _handleCategoryTap(TheCategory category) async {
          controller.nameCategories.value = category.translations.first.name;
          controller.idCategories.value = category.id.toString();
          controller.fetchSubcategories(
            category.id,
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );
          controller.fetchPostsAll(
            category.id,
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
            null,
            null,
          );

          searchcontroller.subCategories.clear();
          searchcontroller.isChosedAndShowTheSub.value = false;
          searchcontroller
              .fetchSubcategories(
            int.parse(controller.idCategories.value),
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          )
              .then((_) {
            searchcontroller.isChosedAndShowTheSub.value = true;
          });
          searchcontroller.idOfCateSearchBox.value = category.id;
          searchcontroller.detailCarControllers["القسم الرئيسي"]?.text =
              controller.idCategories.value;
          searchcontroller.detailRealestateControllers["القسم الرئيسي"]?.text =
              controller.idCategories.value;
          searchcontroller.isOpenINSubPost.value = true;
          searchcontroller.selectedMainCategory = category.id;
          controller.showTheSubCategories.value = true;
          Get.toNamed('/category-mobile');
        }

        // دالة التفاعل عند الضغط على قسم من الأقسام
        void _handleSectionTap(RxList<Post> postsList) {
          if (postsList.isNotEmpty && postsList.first.category != null) {
            final category = postsList.first.category!;
            _handleCategoryTap(category);
          } else {
            Get.snackbar("خطأ", "لا يوجد بيانات لهذا القسم");
          }
        }

        final List<SectionData<Post>> sections = [
          SectionData<Post>(
              "المول الإلكتروني".tr,
              controller.LoadingPostsCateOne,
              controller.postsListCateOne,
              () => _handleSectionTap(controller.postsListCateOne)),
          SectionData<Post>(
              "سوق المستعمل".tr,
              controller.LoadingPostsCateTwo,
              controller.postsListCateTwo,
              () => _handleSectionTap(controller.postsListCateTwo)),
          SectionData<Post>(
              "مركبات للبيع والايجار".tr,
              controller.LoadingPostsCateThree,
              controller.postsListCateThree,
              () => _handleSectionTap(controller.postsListCateThree)),
          SectionData<Post>(
              "المهن والحرف".tr,
              controller.LoadingPostsCateFour,
              controller.postsListCateFour,
              () => _handleSectionTap(controller.postsListCateFour)),
          SectionData<Post>(
              "منتجات من البيت".tr,
              controller.LoadingPostsCateFive,
              controller.postsListCateFive,
              () => _handleSectionTap(controller.postsListCateFive)),
          SectionData<Post>(
              "عقارات للبيع والإيجار".tr,
              controller.LoadingPostsCateSix,
              controller.postsListCateSix,
              () => _handleSectionTap(controller.postsListCateSix)),
          SectionData<Post>(
              "عروض وصفقات".tr,
              controller.LoadingPostsCateSeven,
              controller.postsListCateSeven,
              () => _handleSectionTap(controller.postsListCateSeven)),
          SectionData(
              "المزاد الإلكتروني".tr,
              controller.LoadingPostsCateEight,
              controller.postsListCateEight,
              () => _handleSectionTap(controller.postsListCateEight)),
          SectionData<Post>(
              "متجر المنتجات العالمية".tr,
              controller.LoadingPostsCateNine,
              controller.postsListCateNine,
              () => _handleSectionTap(controller.postsListCateNine)),
          SectionData<Post>(
              "الإعلانات الرسمية".tr,
              controller.LoadingPostsCateTen,
              controller.postsListCateTen,
              () => _handleSectionTap(controller.postsListCateTen)),
          SectionData<Post>(
              "سوق الجملة والتوكيلات".tr,
              controller.LoadingPostsCateEleven,
              controller.postsListCateEleven,
              () => _handleSectionTap(controller.postsListCateEleven)),
          SectionData<Post>(
              "فرص عمل".tr,
              controller.LoadingPostsCateTwelve,
              controller.postsListCateTwelve,
              () => _handleSectionTap(controller.postsListCateTwelve)),
          SectionData<Post>(
              "أفكار ومشاريع للتمويل".tr,
              controller.LoadingPostsCateThrteen,
              controller.postsListCateThrteen,
              () => _handleSectionTap(controller.postsListCateThrteen)),
          SectionData<Post>(
              "المطاعم".tr,
              controller.LoadingPostsCateFourTeen,
              controller.postsListCateFourTeen,
              () => _handleSectionTap(controller.postsListCateFourTeen)),
          SectionData<Post>(
              "دليل الشركات".tr,
              controller.LoadingPostsCateFifteen,
              controller.postsListCateFifteen,
              () => _handleSectionTap(controller.postsListCateFifteen)),
          SectionData<Post>(
              "منتجات من المرزعة".tr,
              controller.LoadingPostsCateSixteen,
              controller.postsListCateSixteen,
              () => _handleSectionTap(controller.postsListCateSixteen)),
          SectionData<Post>(
              "الخدمات التعليمية".tr,
              controller.LoadingPostsCateSeventeen,
              controller.postsListCateSeventeen,
              () => _handleSectionTap(controller.postsListCateSeventeen)),
          SectionData<Post>(
              "عمال يوميين".tr,
              controller.LoadingPostsCateEighteen,
              controller.postsListCateEighteen,
              () => _handleSectionTap(controller.postsListCateEighteen)),
          SectionData<Post>(
              "خدمات الذكاء الاصطناعي".tr,
              controller.LoadingPostsCateNineteen,
              controller.postsListCateNineteen,
              () => _handleSectionTap(controller.postsListCateNineteen)),
          SectionData<Post>(
              "الانشاءات مواد البناء".tr,
              controller.LoadingPostsCateTwenty,
              controller.postsListCateTwenty,
              () => _handleSectionTap(controller.postsListCateTwenty)),
          SectionData<Post>(
              "الالات والمعدات".tr,
              controller.LoadingPostsCateTwentyOne,
              controller.postsListCateTwentyOne,
              () => _handleSectionTap(controller.postsListCateTwentyOne)),
          SectionData<Post>(
              "الزراعة والحيوان".tr,
              controller.LoadingPostsCateTwentyTwo,
              controller.postsListCateTwentyTwo,
              () => _handleSectionTap(controller.postsListCateTwentyTwo)),
          SectionData<Post>(
              "الصالونات الصحية والرياضية".tr,
              controller.LoadingPostsCateTwentyThree,
              controller.postsListCateTwentyThree,
              () => _handleSectionTap(controller.postsListCateTwentyThree)),
          SectionData<Post>(
              "الحيوانات الأليفة".tr,
              controller.LoadingPostsCateTwentyFour,
              controller.postsListCateTwentyFour,
              () => _handleSectionTap(controller.postsListCateTwentyFour)),
        ];

        return Scaffold(
          body: Stack(
            children: [
              // المحتوى الأساسي للصفحة داخل ScrollView مع تخصيص ارتفاع مناسب
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: size.width,
                  height: size.height * 0.92,
                  color: AppColors.backgroundColor(
                      themeController.isDarkMode.value),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: const TopSection(),
                        ),
                        SizedBox(height: 15.h),
                        CategoriesPage(),
                        SizedBox(height: 5.h),
                        const AdSection(),
                        SizedBox(height: 5.h),
                        const PromotedAdPage(),
                        const NewPosts(),
                        const MostViewPosts(),
                        const MostRatingPost(),
                        // عرض الأقسام باستخدام ListView.builder داخل الـ Column
                        ListView.builder(
                          itemCount: sections.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final section = sections[index];
                            return CustomCardPost(
                              title: section.title,
                              isLoading: section.isLoading,
                              postsList: section.posts,
                              onTap: section.onTap,
                            );
                          },
                        ),
                        SizedBox(height: 55.h),
                      ],
                    ),
                  ),
                ),
              ),
              // شريط التنقل السفلي
              const _BottomNavigationSection(),
            ],
          ),
        );
      },
    );
  }
}

class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode.value;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColors.backgroundColor(isDarkMode),
        width: size.width,
        height: 70.h,
        child: const Menu(),
      ),
    );
  }
}

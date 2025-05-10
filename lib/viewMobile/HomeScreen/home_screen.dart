import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
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

  SectionData(this.title, this.isLoading, this.posts);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // <-- تفعيل الحفاظ على الحالة

  Widget build(BuildContext context) {
    super.build(context);
    final ThemeController themeController = Get.find();

    return GetX<HomeController>(
      builder: (controller) {
        // قائمة الأقسام
        final List<SectionData<Post>> sections = [
          SectionData<Post>("المول الإلكتروني".tr,
              controller.LoadingPostsCateOne, controller.postsListCateOne),
          SectionData<Post>("سوق المستعمل".tr, controller.LoadingPostsCateTwo,
              controller.postsListCateTwo),
          SectionData<Post>("مركبات للبيع والايجار".tr,
              controller.LoadingPostsCateThree, controller.postsListCateThree),
          SectionData<Post>("المهن والحرف".tr, controller.LoadingPostsCateFour,
              controller.postsListCateFour),
          SectionData<Post>("منتجات من البيت".tr,
              controller.LoadingPostsCateFive, controller.postsListCateFive),
          SectionData<Post>("عقارات للبيع والإيجار".tr,
              controller.LoadingPostsCateSix, controller.postsListCateSix),
          SectionData<Post>("عروض وصفقات".tr, controller.LoadingPostsCateSeven,
              controller.postsListCateSeven),
          SectionData("المزاد الإلكتروني".tr, controller.LoadingPostsCateEight,
              controller.postsListCateEight),
          SectionData<Post>("متجر المنتجات العالمية".tr,
              controller.LoadingPostsCateNine, controller.postsListCateNine),
          SectionData<Post>("الإعلانات الرسمية".tr,
              controller.LoadingPostsCateTen, controller.postsListCateTen),
          SectionData<Post>(
              "سوق الجملة والتوكيلات".tr,
              controller.LoadingPostsCateEleven,
              controller.postsListCateEleven),
          SectionData<Post>("فرص عمل".tr, controller.LoadingPostsCateTwelve,
              controller.postsListCateTwelve),
          SectionData<Post>(
              "أفكار ومشاريع للتمويل".tr,
              controller.LoadingPostsCateThrteen,
              controller.postsListCateThrteen),
          SectionData<Post>("المطاعم".tr, controller.LoadingPostsCateFourTeen,
              controller.postsListCateFourTeen),
          SectionData<Post>(
              "دليل الشركات".tr,
              controller.LoadingPostsCateFifteen,
              controller.postsListCateFifteen),
          SectionData<Post>(
              "منتجات من المرزعة".tr,
              controller.LoadingPostsCateSixteen,
              controller.postsListCateSixteen),
          SectionData<Post>(
              "الخدمات التعليمية".tr,
              controller.LoadingPostsCateSeventeen,
              controller.postsListCateSeventeen),
          SectionData<Post>(
              "عمال يوميين".tr,
              controller.LoadingPostsCateEighteen,
              controller.postsListCateEighteen),
          SectionData<Post>(
              "خدمات الذكاء الاصطناعي".tr,
              controller.LoadingPostsCateNineteen,
              controller.postsListCateNineteen),
          SectionData<Post>(
              "الانشاءات مواد البناء".tr,
              controller.LoadingPostsCateTwenty,
              controller.postsListCateTwenty),
          SectionData<Post>(
              "الالات والمعدات".tr,
              controller.LoadingPostsCateTwentyOne,
              controller.postsListCateTwentyOne),
          SectionData<Post>(
              "الزراعة والحيوان".tr,
              controller.LoadingPostsCateTwentyTwo,
              controller.postsListCateTwentyTwo),
          SectionData<Post>(
              "الصالونات الصحية والرياضية".tr,
              controller.LoadingPostsCateTwentyThree,
              controller.postsListCateTwentyThree),
          SectionData<Post>(
              "الحيوانات الأليفة".tr,
              controller.LoadingPostsCateTwentyFour,
              controller.postsListCateTwentyFour),
        ];

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.92,
                  color: AppColors.backgroundColor(
                      themeController.isDarkMode.value),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
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

                        // الأقسام
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
                            );
                          },
                        ),
                        SizedBox(height: 55.h),
                      ],
                    ),
                  ),
                ),
              ),
              _BottomNavigationSection(),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/data/model/category.dart';
import '../../core/localization/changelanguage.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final controller = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();
  final searchcontroller = Get.find<Searchcontroller>();
  final langController = Get.find<ChangeLanguageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.backgroundColor(themeController.isDarkMode.value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            SizedBox(height: 7.h),
            _buildCategoriesListSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "الرئيسية".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildToggleButton(),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Obx(() {
      final isShow = controller.isShowTheCate.value;
      return InkWell(
        onTap: () => controller.isShowTheCate.value = !isShow,
        child: Container(
          width: 180.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: !isShow ? AppColors.blueLight : AppColors.redColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130.w,
                  child: Text(
                    !isShow ? "مشاهدة الأقسام".tr : "إخفاء الأقسام".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color: AppColors.whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  !isShow
                      ? ImagesPath.showMoreTheCate
                      : ImagesPath.showLessTheCate,
                  width: 20.w,
                  height: 20.h,
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCategoriesListSection(BuildContext context) {
    return Obx(() {
      if (!controller.isShowTheCate.value) return const SizedBox.shrink();

      return Obx(() {
        if (controller.isLoadingCategories.value) {
          return _buildSkeletonLoader();
        }

        if (controller.categoriesList.isEmpty) {
          return _buildEmptyState();
        }

        return _buildCategoriesList(context);
      });
    });
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (_, index) => ListTile(
        title: Container(height: 20.h, color: Colors.grey[300]),
        subtitle: Container(height: 15.h, color: Colors.grey[300]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "المعــذرة البيانات حاليًا غير متاحة للعرض ..حاول مجددًا".tr,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.redColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor(themeController.isDarkMode.value),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.categoriesList.length,
        itemBuilder: (context, index) {
          final category = controller.categoriesList[index];
          return _buildCategoryItem(category);
        },
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: InkWell(
        onTap: () => _handleCategoryTap(category),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor(themeController.isDarkMode.value),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCategoryImage(category),
                SizedBox(width: 15.w),
                _buildCategoryInfo(category),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage(Category category) {
    return CachedNetworkImage(
      imageUrl: category.image,
      width: 50.w,
      height: 50.h,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: 50.w,
        height: 50.h,
        color:
            AppColors.backgroundColorIconBack(themeController.isDarkMode.value),
        alignment: Alignment.center,
        child: Text(
          "على مودك".tr,
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 50.w,
        height: 50.h,
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Icon(
          Icons.broken_image,
          color: AppColors.backgroundColorIconBack(
              themeController.isDarkMode.value),
          size: 30.sp,
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(Category category) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.translations.first.name,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.2.h),
          Text(
            category.translations.first.description,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColorOne(themeController.isDarkMode.value),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _handleCategoryTap(Category category) async {
   /* controller.nameCategories.value = category.translations.first.name;
    controller.idCategories.value = category.id.toString();

    final langCode = langController.currentLocale.value.languageCode;

    await controller.fetchSubcategories(category.id, langCode);
    await controller.fetchPostsAll(category.id, langCode, null, null);

    searchcontroller.subCategories.clear();
    searchcontroller.isChosedAndShowTheSub.value = false;

    await searchcontroller.fetchSubcategories(
      int.parse(controller.idCategories.value),
      langCode,
    );

    searchcontroller.isChosedAndShowTheSub.value = true;
    searchcontroller.idOfCateSearchBox.value = category.id;

    searchcontroller.detailCarControllers["القسم الرئيسي"]?.text =
        controller.idCategories.value;

    searchcontroller.detailRealestateControllers["القسم الرئيسي"]?.text =
        controller.idCategories.value;

    searchcontroller.isOpenINSubPost.value = true;
    searchcontroller.selectedMainCategory = category.id;

    controller.showTheSubCategories.value = true;*/

     controller.nameCategories.value =
                                          category.translations.first.name;
                                      controller.idCategories.value =
                                          category.id.toString();
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
                                      searchcontroller
                                          .isChosedAndShowTheSub.value = false;
                                      searchcontroller
                                          .fetchSubcategories(
                                        int.parse(
                                            controller.idCategories.value),
                                        Get.find<ChangeLanguageController>()
                                            .currentLocale
                                            .value
                                            .languageCode,
                                      )
                                          .then((_) {
                                        searchcontroller
                                            .isChosedAndShowTheSub.value = true;
                                      });
                                      searchcontroller.idOfCateSearchBox.value =
                                          category.id;
                                      print(
                                          "/......................................");
                                      print(searchcontroller
                                          .idOfCateSearchBox.value);
                                      print(
                                          "/......................................");
                                      searchcontroller
                                          .detailCarControllers["القسم الرئيسي"]
                                          ?.text = controller.idCategories.value;

                                      searchcontroller
                                              .detailRealestateControllers[
                                                  "القسم الرئيسي"]
                                              ?.text =
                                          controller.idCategories.value;

                                      searchcontroller.isOpenINSubPost.value =
                                          true;
                                      searchcontroller.selectedMainCategory =
                                          category.id;

                                      controller.showTheSubCategories.value =
                                          true;
    Get.toNamed('/category-mobile');
  }
}

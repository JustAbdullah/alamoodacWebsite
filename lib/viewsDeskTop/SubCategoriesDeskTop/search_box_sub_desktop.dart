import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/localization/changelanguage.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../customWidgets/DropdwondFieldApi.dart';
import 'searchingTypeDeskTop/all_type_prices_sub.dart';
import 'searchingTypeDeskTop/cars_type_sub_desktop.dart';
import 'searchingTypeDeskTop/realestate_sub_desktop.dart';

class SearchBoxSubDesktop extends StatelessWidget {
  const SearchBoxSubDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final searchController = Get.find<Searchcontroller>();
    final isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.only(
            topLeft: isArabic ? Radius.zero : Radius.circular(20.r),
            bottomLeft: isArabic ? Radius.zero : Radius.circular(20.r),
            topRight: isArabic ? Radius.circular(20.r) : Radius.zero,
            bottomRight: isArabic ? Radius.circular(20.r) : Radius.zero,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(searchController, isArabic, themeController),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSubCategoryDropdown(searchController),
                    SizedBox(height: 5.h),
                    _buildSubCategoryLevelTwoDropdown(searchController),
                    SizedBox(height: 5.h),
                    _buildSearchCriteria(searchController),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(Searchcontroller controller, bool isArabic,
      ThemeController themeController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor(themeController.isDarkMode.value),
        borderRadius: BorderRadius.only(
          topLeft: isArabic ? Radius.zero : Radius.circular(20.r),
          topRight: isArabic ? Radius.circular(20.r) : Radius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "فلترة متقدمة".tr,
            style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor(themeController.isDarkMode.value)),
          ),
          _buildResetButton(controller),
        ],
      ),
    );
  }

  Widget _buildResetButton(Searchcontroller controller) {
    return Tooltip(
      message: "إعادة التعيين".tr,
      child: IconButton(
        icon: Icon(Icons.restart_alt_rounded,
            color: AppColors.redColor, size: 28.sp),
        onPressed: () => controller.resetCategorySelectionInSubPost(),
      ),
    );
  }

  Widget _buildSubCategoryDropdown(Searchcontroller controller) {
    return Obx(() {
      return AnimatedSwitcher(
          duration: 300.ms,
          child: _buildDropdownSection(
            title: "القسم الفرعي".tr,
            child: DropdownFieldApi(
              label: "اختر القسم الفرعي".tr,
              items: [
                "غير مدخل".tr,
                ...controller.subCategories
                    .map((sub) => sub.translations.first.name)
              ],
              selectedItem:
                  controller.subCategories.isNotEmpty ? "غير مدخل".tr : null,
              onChanged: (value) => _handleSubCategoryChange(controller, value),
            ),
          ));
    });
  }

  void _handleSubCategoryChange(Searchcontroller controller, String? value) {
    if (value != "غير مدخل".tr) {
      final selectedSub = controller.subCategories.firstWhere(
        (sub) => sub.translations.first.name == value,
        orElse: () => controller.subCategories.first,
      );
      controller.idOfSub = selectedSub.id;
      controller.selectedSubCategory = selectedSub.id;
      controller.fetchSubcategoriesLevelTwo(
          selectedSub.id,
          Get.find<ChangeLanguageController>()
              .currentLocale
              .value
              .languageCode);
    } else {
      controller.resetSubCategorySelection();
    }
  }

  Widget _buildSubCategoryLevelTwoDropdown(Searchcontroller controller) {
    return AnimatedSwitcher(
      duration: 300.ms,
      child: controller.isChosedAndShowTheSubTwo.value
          ? _buildDropdownSection(
              title: "القسم الفرعي الثاني".tr,
              child: DropdownFieldApi(
                label: "اختر القسم الفرعي الثاني".tr,
                items: [
                  "غير مدخل".tr,
                  ...controller.subcategoriesLevelTwo
                      .map((sub) => sub.translations.first.name)
                ],
                selectedItem: controller.subcategoriesLevelTwo.isNotEmpty
                    ? "غير مدخل".tr
                    : null,
                onChanged: (value) =>
                    _handleSubCategoryLevelTwoChange(controller, value),
              ),
            )
          : const SizedBox(),
    );
  }

  void _handleSubCategoryLevelTwoChange(
      Searchcontroller controller, String? value) {
    if (value != "غير مدخل".tr) {
      final selectedSub = controller.subcategoriesLevelTwo.firstWhere(
        (sub) => sub.translations.first.name == value,
        orElse: () => controller.subcategoriesLevelTwo.first,
      );
      controller.selectedSubCategoryLevel2 = selectedSub.id;
      controller.idOfSubTwo = selectedSub.id;
    } else {
      controller.resetSubCategoryLevelTwoSelection();
    }
  }

  Widget _buildSearchCriteria(Searchcontroller controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle("معايير البحث".tr),
        SizedBox(height: 15.h),
        AnimatedSwitcher(
          duration: 700.ms,
          child: _getSearchComponent(controller.idOfCateSearchBox.value),
        ),
      ],
    );
  }

  Widget _getSearchComponent(int categoryId) {
    switch (categoryId) {
      case 3:
        return const CarsTypeSubDeskTop();
      case 6:
        return const RealestateTypeSubDeskTop();
      case 1:
      case 2:
      case 5:
      case 7:
      case 8:
      case 9:
      case 16:
        return const AllTypePricesSubDeskTop();
      default:
        return categoryId != 0
            ? const AllTypePricesSubDeskTop()
            : const SizedBox();
    }
  }

  Widget _buildDropdownSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(title),
        SizedBox(height: 10.h),
        child,
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color:
              AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
        ),
      ),
    );
  }
}

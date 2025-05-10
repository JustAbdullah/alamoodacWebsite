import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/localization/changelanguage.dart';
import '../../customWidgets/DropdwondFieldApi.dart';
import 'searchingType/all_type_prices.dart';
import 'searchingType/cars_type.dart';
import 'searchingType/realestate.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    return GetX<Searchcontroller>(
      builder: (controller) {
        if (!controller.searchingBox.value) return const SizedBox();

        return Stack(
          children: [
            // الخلفية المعتمة
            GestureDetector(
              onTap: () => controller.searchingBox.value = false,
              child: AnimatedContainer(
                duration: 300.ms,
                color: Colors.black
                    .withOpacity(controller.searchingBox.value ? 0.4 : 0),
              ),
            ),

            // صندوق البحث (يتكيف مع اللغة)
            AnimatedPositioned(
              duration: 500.ms,
              curve: Curves.easeOutExpo,
              right: isArabic
                  ? (controller.searchingBox.value ? 0 : -500.w)
                  : null, // يظهر من اليمين للعربية
              left: isArabic
                  ? null
                  : (controller.searchingBox.value
                      ? 0
                      : -500.w), // يظهر من اليسار للإنجليزية
              top: 0,
              bottom: 0,
              child: Container(
                width: 0.82.sw,
                margin: EdgeInsets.only(
                  top: 00.h,
                  bottom: 20.h,
                  right: isArabic ? 00.w : 0, // هامش من اليمين للعربية
                  left: isArabic ? 0 : 00.w, // هامش من اليسار للإنجليزية
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor(
                      themeController.isDarkMode.value),
                  borderRadius: BorderRadius.only(
                    topLeft: !isArabic ? Radius.zero : Radius.circular(20.r),
                    bottomLeft: !isArabic ? Radius.zero : Radius.circular(20.r),
                    topRight: !isArabic ? Radius.circular(20.r) : Radius.zero,
                    bottomRight:
                        !isArabic ? Radius.circular(20.r) : Radius.zero,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(controller, isArabic, themeController),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryDropdown(controller),
                            _buildSubCategoryDropdown(controller),
                            _buildSubCategoryLevelTwoDropdown(controller),
                            _buildSearchCriteria(controller),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Searchcontroller controller, bool isArabic,
      ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor(themeController.isDarkMode.value),
        borderRadius: BorderRadius.only(
          topLeft: isArabic ? Radius.zero : Radius.circular(20.r),
          topRight: isArabic ? Radius.circular(20.r) : Radius.zero,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.redAccent, size: 28.sp),
            onPressed: () => controller.searchingBox.value = false,
          ),
          Text(
            "صندوق البحث".tr,
            style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor(themeController.isDarkMode.value)),
          ),
          IconButton(
            icon: Icon(Icons.restart_alt_rounded,
                color: AppColors.redColor, size: 28.sp),
            onPressed: controller.resetCategorySelection,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(Searchcontroller controller) {
    return _buildDropdownSection(
      title: "حـدد القسم للفلترة".tr,
      child: DropdownFieldApi(
        label: "اختر القسم الرئيسي".tr,
        items: [
          "غير مدخل".tr,
          ...controller.categoriesList.map((cat) => cat.translations.first.name)
        ],
        selectedItem:
            controller.categoriesList.isNotEmpty ? "غير مدخل".tr : null,
        onChanged: (value) => _handleCategoryChange(controller, value),
      ),
    );
  }

  void _handleCategoryChange(Searchcontroller controller, String? value) {
    if (value != "غير مدخل".tr) {
      final selectedCat = controller.categoriesList.firstWhere(
        (cat) => cat.translations.first.name == value,
        orElse: () => controller.categoriesList.first,
      );
      controller.idOfCateSearchBox.value = selectedCat.id;
      controller.selectedMainCategory = selectedCat.id;
      controller.fetchSubcategories(
          selectedCat.id,
          Get.find<ChangeLanguageController>()
              .currentLocale
              .value
              .languageCode);
    } else {
      controller.resetCategorySelection();
    }
  }

  Widget _buildSubCategoryDropdown(Searchcontroller controller) {
    return AnimatedSwitcher(
      duration: 300.ms,
      child: controller.isChosedAndShowTheSub.value
          ? _buildDropdownSection(
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
                onChanged: (value) =>
                    _handleSubCategoryChange(controller, value),
              ),
            )
          : const SizedBox(),
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("حدد معايير البحث".tr),
        SizedBox(height: 0.h),
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
        return const CarsType();
      case 6:
        return const RealestateType();
      case 1:
      case 2:
      case 5:
      case 7:
      case 8:
      case 9:
      case 16:
        return const AllTypePrices();
      default:
        return categoryId != 0 ? const AllTypePrices() : const SizedBox();
    }
  }

  Widget _buildDropdownSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(height: 0.h),
        child,
        SizedBox(height: 0.h),
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
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color:
              AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
        ),
      ),
    );
  }
}

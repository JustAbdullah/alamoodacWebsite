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
import 'searchingType/all_type_prices_desktop.dart';
import 'searchingType/cars_type_desktop.dart';
import 'searchingType/realestate_desktop.dart';

class SearchBoxDeskTop extends StatelessWidget {
  const SearchBoxDeskTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    // استخدام كونتينر واحد بخلفية بيضاء واضحة بدون تداخل
    return GetX<Searchcontroller>(builder: (controller) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.circular(0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isArabic, themeController),
            Divider(height: 1.h, color: Colors.grey.shade300),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryDropdown(controller),
                    _buildSubCategoryDropdown(controller),
                    _buildSubCategoryLevelTwoDropdown(controller),
                    _buildSearchCriteria(controller),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(bool isArabic, ThemeController themeController) {
    return GetX<Searchcontroller>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor(themeController.isDarkMode.value),
            borderRadius: BorderRadius.only(
              topLeft: isArabic ? Radius.zero : Radius.circular(20.r),
              topRight: isArabic ? Radius.circular(20.r) : Radius.zero,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // تغيير عنوان الصندوق إلى "البحث المتخصص"
              Text(
                "البحث المخصص".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
              ),
              // زر إعادة التعيين بتصميم محسّن داخل دائرة مع تظليل بسيط
              Container(
                decoration: BoxDecoration(
                  color: AppColors.redColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.restart_alt_rounded,
                    color: AppColors.redColor,
                    size: 28.sp,
                  ),
                  onPressed: controller.resetCategorySelection,
                ),
              ),
            ],
          ),
        );
      },
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
        return const CarsTypeDesktop();
      case 6:
        return const RealestateTypeDeskTop();
      case 1:
      case 2:
      case 5:
      case 7:
      case 8:
      case 9:
      case 16:
        return const AllTypePricesDeskTop();
      default:
        return categoryId != 0
            ? const AllTypePricesDeskTop()
            : const SizedBox();
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

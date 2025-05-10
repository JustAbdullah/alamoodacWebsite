import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/localization/changelanguage.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import 'map_search_sub_cate_desktop.dart';
import 'posts_sub_desktop.dart';
import 'search_box_sub_desktop.dart';
import 'top_section_sub_desktop.dart';

class SubCategoriesPageDeskTop extends StatelessWidget {
  const SubCategoriesPageDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final searchController = Get.find<Searchcontroller>();
    final isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    return GetX<HomeController>(
      builder: (controller) => Scaffold(
        backgroundColor:
            AppColors.backgroundColor(themeController.isDarkMode.value),
        body: SafeArea(
          child: Column(
            children: [
              // الجزء العلوي بدون ظل ثقيل
              _buildTopSection(themeController, controller),

              // الجزء الرئيسي
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الفلترة الجانبية
                    Container(
                        width: 280.w,
                        margin: EdgeInsets.only(
                          top: 16.h,
                          bottom: 16.h,
                          right: isArabic ? 16.w : 0,
                          left: isArabic ? 0 : 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor(
                              themeController.isDarkMode.value),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: SearchBoxSubDesktop()),

                    // المحتوى الرئيسي
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 12.h),
                        child: PostsSubDesktop(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(
      ThemeController themeController, HomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TopSectionSubDesktop(),
          SizedBox(height: 14.h),
          _buildControlBar(controller, themeController),
        ],
      ),
    );
  }

  Widget _buildControlBar(
      HomeController controller, ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMapButton(controller),
            const SortingIconsWithDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton(HomeController controller) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () {
            Get.to(
              () => MapSearchInSubCateDeskTop(),
              transition: Transition.native, // أفضل انتقال لـ iOS
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutBack,
            );
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: Colors.white, size: 22.w),
                SizedBox(width: 8.w),
                Text(
                  "عرض الخريطة".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SortingIconsWithDropdown extends StatefulWidget {
  const SortingIconsWithDropdown({Key? key}) : super(key: key);

  @override
  _SortingIconsWithDropdownState createState() =>
      _SortingIconsWithDropdownState();
}

class _SortingIconsWithDropdownState extends State<SortingIconsWithDropdown> {
  OverlayEntry? _dropdownOverlayEntry;
  int? activeDropdownIndex;

  final List<SortingCategory> categories = [
    SortingCategory(
      title: 'ترتيب حسب المشاهدات'.tr,
      icon: Icons.remove_red_eye_outlined,
      options: [
        SortingOption(label: 'الأعلى مشاهدة'.tr, value: 'most_viewed'),
        SortingOption(label: 'الأقل مشاهدة'.tr, value: 'least_viewed'),
      ],
    ),
    SortingCategory(
      title: 'ترتيب حسب السعر'.tr,
      icon: Icons.attach_money,
      options: [
        SortingOption(label: 'الأعلى سعراً'.tr, value: 'most_expensive'),
        SortingOption(label: 'الأقل سعراً'.tr, value: 'cheapest'),
      ],
    ),
    SortingCategory(
      title: 'ترتيب حسب التاريخ'.tr,
      icon: Icons.calendar_today_outlined,
      options: [
        SortingOption(label: 'الأحدث أولاً'.tr, value: 'latest'),
        SortingOption(label: 'الأقدم أولاً'.tr, value: 'oldest'),
      ],
    ),
    SortingCategory(
      title: 'ترتيب حسب التقييم'.tr,
      icon: Icons.star_border,
      options: [
        SortingOption(label: 'الأعلى تقييماً'.tr, value: 'highest_rated'),
        SortingOption(label: 'الأقل تقييماً'.tr, value: 'lowest_rated'),
      ],
    ),
  ];

  void _toggleDropdown(int index) {
    if (_dropdownOverlayEntry != null) {
      _removeDropdown();
      if (activeDropdownIndex == index) return;
    }
    activeDropdownIndex = index;
    _dropdownOverlayEntry = _createOverlayEntry(index);
    Overlay.of(context)!.insert(_dropdownOverlayEntry!);
  }

  void _removeDropdown() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;
    activeDropdownIndex = null;
  }

  OverlayEntry _createOverlayEntry(int index) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeDropdown,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: _buildDropdown(categories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(SortingCategory category) {
    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.title,
                    style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _removeDropdown,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
          ...category.options.map((option) => ListTile(
                leading: Icon(_getOptionIcon(option.value),
                    color: Theme.of(context).iconTheme.color),
                title: Text(option.label,
                    style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne, fontSize: 14.sp)),
                onTap: () {
                  _handleOptionSelection(option.value);
                  _removeDropdown();
                },
              )),
        ],
      ),
    );
  }

  void _handleOptionSelection(String value) {
    final controller = Get.find<HomeController>();
    final lang =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;
    switch (value) {
      case 'most_viewed':
        controller.fetchMostViewedPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'least_viewed':
        controller.fetchLeastViewedPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'most_expensive':
        controller.fetchMostExpensivePosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'cheapest':
        controller.fetchCheapestPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'latest':
        controller.fetchLatestPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'oldest':
        controller.fetchOldestPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'highest_rated':
        controller.fetchHighestRatedPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
      case 'lowest_rated':
        controller.fetchLowestRatedPosts(
            language: lang, categoryId: controller.idCategories.value);
        break;
    }
  }

  IconData _getOptionIcon(String value) {
    switch (value) {
      case 'most_viewed':
        return Icons.trending_up;
      case 'least_viewed':
        return Icons.trending_down;
      case 'most_expensive':
        return Icons.arrow_upward;
      case 'cheapest':
        return Icons.arrow_downward;
      case 'latest':
        return Icons.new_releases;
      case 'oldest':
        return Icons.history;
      case 'highest_rated':
        return Icons.star;
      case 'lowest_rated':
        return Icons.star_border;
      default:
        return Icons.sort;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        categories.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          child: Container(
            alignment: Alignment.center,
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 205, 204, 204), // خلفية رمادية فاتحة
              borderRadius: BorderRadius.circular(8), // زوايا مدورة
            ),
            // تباعد داخلي
            child: Center(
              child: IconButton(
                icon: Icon(
                  categories[index].icon,
                  color: activeDropdownIndex == index
                      ? AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>()
                              .isDarkMode
                              .value) // اللون الأساسي عند النشاط
                      : Color.fromARGB(255, 118, 117,
                          117), // رمادي غامق للأيقونات غير النشطة
                ),
                onPressed: () => _toggleDropdown(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SortingCategory {
  final String title;
  final IconData icon;
  final List<SortingOption> options;
  SortingCategory(
      {required this.title, required this.icon, required this.options});
}

class SortingOption {
  final String label;
  final String value;
  SortingOption({required this.label, required this.value});
}

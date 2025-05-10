import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/searchController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/localization/changelanguage.dart';
import '../../OnAppPages/menu.dart';
import 'list_sub_categories.dart';
import 'list_sub_categories_two.dart';
import 'map_search_sub_cate.dart';
import 'posts_sub.dart';
import 'search_box_sub.dart';
import 'top_section_sub.dart';

class SubCategoriesPage extends StatelessWidget {
  SubCategoriesPage({Key? key}) : super(key: key);

  // نقل التهيئة إلى الحقول لتجنّب استدعاءها داخل build
  final ThemeController _themeController = Get.find();
  final HomeController _homeController = Get.find();
  final Searchcontroller _searchController = Get.put(Searchcontroller());

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: controller.showTheSubCategories.value
            ? Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      // المحتوى الرئيسي: AppBar + القائمة
                      Expanded(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: true,
                              collapsedHeight: 280.h,
                              expandedHeight: 280.h,
                              flexibleSpace: _buildTopSection(controller),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: PostsSub(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const _BottomNavigationSection(),
                    ],
                  ),
                ),
                floatingActionButton: const SearchBoxSub(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTopSection(HomeController controller) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        TopSectionSub(),
        SizedBox(height: 10.h),
        ListSubCategories(),
        SizedBox(height: 10.h),

        // عرض القائمة الثانية دفعة واحدة
        GetX<HomeController>(
          builder: (c) {
            if (!c.showTheSubTwo.value) return const SizedBox.shrink();
            return Column(
              children: [
                ListSubCategoriesTwo(),
                SizedBox(height: 10.h),
              ],
            );
          },
        ),

        _buildSortingAndFilterSection(),
      ],
    );
  }

  Widget _buildSortingAndFilterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationButton(),
              const SortingIconsWithDropdown(),
              _buildResetButton(),
            ],
          ),
          SizedBox(height: 5.h),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: InkWell(
        onTap: () {
          _homeController.showMap.value = true;
          Get.to(() => const MapSearchInSubCate());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.oragne,
          ),
          child: Icon(
            Icons.location_on,
            color: Colors.white,
            size: 22.w,
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Container(
      width: 60.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.red.withOpacity(0.3),
      ),
      child: IconButton(
        icon: Icon(
          Icons.restart_alt_rounded,
          color: AppColors.redColor,
          size: 30.sp,
        ),
        onPressed: _searchController.resetCategorySelectionInSubPost,
      ),
    );
  }

  Widget _buildFilterButton() {
    final isDark = _themeController.isDarkMode.value;
    return TextButton.icon(
      onPressed: () => _searchController.searchingBox.value = true,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.backgroundColorIconBack(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      icon: Icon(
        Icons.sort_rounded,
        color: Colors.white,
        size: 22.w,
      ),
      label: Text(
        "الـفلترة الخـاصة".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(isDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: const Menu(),
    );
  }
}

// بقية الكودر تبقى كما هي، مضافًا إليها const حيث ممكن
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

Widget _buildTopSection(Searchcontroller searchcontroller,
    ThemeController themeController, HomeController controller) {
  return Column(
    children: [
      SizedBox(
        height: 10.h,
      ),
      TopSectionSub(),
      SizedBox(
        height: 10.h,
      ),
      ListSubCategories(),
      SizedBox(
        height: 10.h,
      ),
      GetX<HomeController>(
          builder: (controller) => Visibility(
              visible: controller.showTheSubTwo.value,
              child: ListSubCategoriesTwo())),
      GetX<HomeController>(
          builder: (controller) => Visibility(
              visible: controller.showTheSubTwo.value,
              child: SizedBox(
                height: 10.h,
              ))),
      SizedBox(
        height: 8.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
        child: Padding(
          padding: EdgeInsets.only(right: 5.w, left: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر الفرز مع أيقونة
              SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: InkWell(
                    onTap: () {
                      controller.showMap.value = true;
                      Get.to(() => MapSearchInSubCate());
                      //controller.isShowTheFetch(context);
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.oragne),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 22.w,
                      ),
                    ),
                  )),

              SortingIconsWithDropdown(),
              // عنوان الفرز
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الفرز مع أيقونة
              TextButton.icon(
                onPressed: () {
                  searchcontroller.searchingBox.value = true;
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 5.h,
                  ),
                  elevation: 2,
                  shadowColor: Colors.black26,
                ),
                icon: Icon(
                  Icons.sort_rounded,
                  color: Colors.white,
                  size: 22.w,
                ),
                label: Text(
                  "الـفلترة الخـاصة".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 60.w,
                height: 40.h,
                alignment: Alignment.center,

                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red.withOpacity(0.3),
                ),
                child: Center(
                  child: IconButton(
                      icon: Icon(Icons.restart_alt_rounded,
                          color: AppColors.redColor, size: 30.sp),
                      onPressed: () {
                        searchcontroller.resetCategorySelectionInSubPost();
                      }),
                ),

                // عنوان الفرز
              )
            ],
          ),
        ),
      ),
    ],
  );
}

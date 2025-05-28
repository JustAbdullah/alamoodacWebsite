import 'package:alamoadac_website/viewsDeskTop/searchDeskTop/map_search_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/localization/changelanguage.dart';
import '../../controllers/searchController.dart';
import '../../customWidgets/SearchFieldWithCategoryDropdown.dart';

import '../homeDeskTop/footer_desktop.dart';
import '../homeDeskTop/top_section_desktop.dart';
import 'list_stores_desktop.dart';
import 'post_searching_list_desktop.dart';
import 'search_box_desktop.dart';

class SearchScreenDesktop extends StatelessWidget {
  const SearchScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor(themeCtrl.isDarkMode.value),
        body: SafeArea(
          child: GetBuilder<Searchcontroller>(
            builder: (searchCtrl) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: TopSectionDeskTop()),

                  // Header Section
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: searchCtrl.showPublishers.value
                          ? _PublishersSearchHeader(searchCtrl: searchCtrl)
                          : _PostsSearchHeader(searchCtrl: searchCtrl),
                    ),
                  ),

                  // Toggle Buttons
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.h, horizontal: 40.w),
                    sliver: SliverToBoxAdapter(
                      child: _SearchToggleButtons(searchCtrl: searchCtrl),
                    ),
                  ),

                  // Main Content
                  searchCtrl.showPublishers.value
                      ? _PublishersContent()
                      : _PostsContent(),

                  const SliverToBoxAdapter(child: FooterDesktop()),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}

// جزء رأس البحث عن المنشورات
class _PostsSearchHeader extends StatelessWidget {
  final Searchcontroller searchCtrl;

  const _PostsSearchHeader({required this.searchCtrl});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          "الــبحث".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeCtrl.isDarkMode.value),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          "قم بالبحث عن ماتريد عن طريق أدوات بحث مخصصة".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeCtrl.isDarkMode.value),
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SearchFieldWithCategoryDropdown(searchcontroller: searchCtrl),
        ),
        SizedBox(height: 16.h),
        _SearchControlBar(),
      ],
    );
  }
}

// جزء رأس البحث عن الناشرين
class _PublishersSearchHeader extends StatelessWidget {
  final Searchcontroller searchCtrl;

  const _PublishersSearchHeader({required this.searchCtrl});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeCtrl.isDarkMode.value),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Text(
            "البحث عن ناشرين".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(themeCtrl.isDarkMode.value),
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: TextField(
                controller: searchCtrl.publisherNameController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "أدخل اسم الناشر".tr,
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: themeCtrl.isDarkMode.value
                      ? Colors.grey.shade800
                      : Colors.grey.shade50,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 12.w),
                    child: Icon(
                      Icons.search_rounded,
                      size: 24.w,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  suffixIcon: _buildSearchIndicator(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 24.w,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor.withOpacity(0.8),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                onSubmitted: (value) => _performSearch(value.trim()),
              ),
            ),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }

  Widget _buildSearchIndicator() {
    return GetBuilder<Searchcontroller>(
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: controller.isSearchingPublishers.value
              ? Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  void _performSearch(String value) {
    if (value.isEmpty) return;

    searchCtrl.isSearchingPublishers.value = true;
    searchCtrl.fetchStoresList(
      language:
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
      searchName: value,
    );
  }
}

// أزرار التبديل بين البحثين
class _SearchToggleButtons extends StatelessWidget {
  final Searchcontroller searchCtrl;

  const _SearchToggleButtons({required this.searchCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          _AnimatedToggleButton(
            index: 0,
            label: 'المنشورات',
            icon: Icons.article_rounded,
            isActive: !searchCtrl.showPublishers.value,
            onTap: () {
              searchCtrl.showPublishers.value = false;
              searchCtrl.update();
            },
          ),
          SizedBox(width: 14.w),
          _AnimatedToggleButton(
            index: 1,
            label: 'الناشرين',
            icon: Icons.storefront_rounded,
            isActive: searchCtrl.showPublishers.value,
            onTap: () {
              searchCtrl.showPublishers.value = true;
              searchCtrl.update();
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedToggleButton extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedToggleButton({
    required this.index,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: 62.w,
            vertical: 16.h,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.TheMain : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive ? Colors.transparent : AppColors.TheMain,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.TheMain.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 24.w,
                  color: isActive ? Colors.white : AppColors.TheMain),
              SizedBox(width: 12.w),
              Text(
                label.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : AppColors.TheMain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// شريط التحكم في البحث
class _SearchControlBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MapButton(),
          const SortingIconsWithDropdown(),
        ],
      ),
    );
  }
}

// زر عرض الخريطة
class _MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.map_outlined, size: 20.w),
      label: Text("عرض الخريطة".tr),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.TheMain,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 22.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onPressed: () => Get.to(
        () => MapSearchDesktop(),
        transition: Transition.cupertino,
        duration: Duration(milliseconds: 400),
      ),
    );
  }
}

// محتوى المنشورات
// محتوى المنشورات
class _PostsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Searchcontroller>(builder: (searchCtrl) {
      return SliverPadding(
        padding: EdgeInsets.all(16.w),
        sliver: SliverCrossAxisGroup(
          slivers: [
            // الجزء الجانبي للفلترة
            SliverConstrainedCrossAxis(
              maxExtent: 280.w,
              sliver: SliverToBoxAdapter(
                // تم تغيير child إلى sliver
                child: _FiltersSidebar(),
              ),
            ),

            // قائمة المنشورات
            SliverPadding(
              padding: EdgeInsets.only(left: 16.w),
              sliver: SliverToBoxAdapter(
                child: PostSearchingListDeskTop(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// الشريط الجانبي للفلترة
class _FiltersSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: SearchBoxDeskTop(),
      ),
    );
  }
}

// محتوى الناشرين
class _PublishersContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.w),
          child: ListStoresDesktop(),
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
    final controller = Get.find<Searchcontroller>();
    final lang =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;
    switch (value) {
      case 'most_viewed':
        controller.fetchMostViewedPosts(language: lang);
        break;
      case 'least_viewed':
        controller.fetchLeastViewedPosts(language: lang);
        break;
      case 'most_expensive':
        controller.fetchMostExpensivePosts(language: lang);
        break;
      case 'cheapest':
        controller.fetchCheapestPosts(language: lang);
        break;
      case 'latest':
        controller.fetchLatestPosts(language: lang);
        break;
      case 'oldest':
        controller.fetchOldestPosts(language: lang);
        break;
      case 'highest_rated':
        controller.fetchHighestRatedPosts(language: lang);
        break;
      case 'lowest_rated':
        controller.fetchLowestRatedPosts(language: lang);
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

/// زر تبديل احترافي مع أيقونة وتأثير متدرّج
class ToggleIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final ThemeController themeController;

  const ToggleIconButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الألوان بناءً على حالة التمكين
    final bgColor = active
        ? AppColors.backgroundColorIconBack(themeController.isDarkMode.value)
        : AppColors.backgroundColor(themeController.isDarkMode.value);
    final textColor = active
        ? Colors.white
        : AppColors.textColor(themeController.isDarkMode.value);
    final iconColor = active
        ? Colors.white
        : AppColors.textColorOne(themeController.isDarkMode.value);

    return Material(
      // لإظهار تأثير الحبر (ripple)
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        splashColor: iconColor.withOpacity(0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 26.w),
          decoration: BoxDecoration(
            gradient: active
                ? LinearGradient(
                    colors: [
                      bgColor.withOpacity(0.9),
                      bgColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: active ? null : bgColor,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              if (active)
                BoxShadow(
                  color: bgColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
            ],
            border: Border.all(
              color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 25.w, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

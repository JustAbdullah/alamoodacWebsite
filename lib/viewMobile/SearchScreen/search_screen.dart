import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/localization/changelanguage.dart';
import '../../customWidgets/SearchFieldWithCategoryDropdown.dart';
import '../OnAppPages/menu.dart';
import 'list_stores.dart';
import 'post_searching_list.dart';
import 'search_box.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Searchcontroller searchcontroller = Get.put(Searchcontroller());
    final ThemeController themeController = Get.find();

    return GetX<HomeController>(
        builder: (Homecontroller) => Visibility(
            visible: Homecontroller.isSearch.value,
            child: Scaffold(
              body: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.92,
                    color: AppColors.backgroundColor(
                        themeController.isDarkMode.value),
                    child: Column(
                      children: [
                        // الجزء العلوي (غير قابل للتمرير)
                        Obx(() => searchcontroller.showPublishers.value
                            ? _buildPublishersTopSection(
                                searchcontroller, themeController)
                            : _buildTopSection(
                                searchcontroller, themeController)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 12.w),
                          child: Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ToggleIconButton(
                                  label: 'المنشورات'.tr,
                                  icon: Icons.article,
                                  active:
                                      !searchcontroller.showPublishers.value,
                                  onTap: () => searchcontroller
                                      .showPublishers.value = false,
                                  themeController: themeController,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                ToggleIconButton(
                                  label: 'الناشرين'.tr,
                                  icon: Icons.people,
                                  active: searchcontroller.showPublishers.value,
                                  onTap: () => searchcontroller
                                      .showPublishers.value = true,
                                  themeController: themeController,
                                ),
                              ],
                            );
                          }),
                        ),
                        // الجزء السفلي (قابل للتمرير)
                        Expanded(child: Obx(() {
                          return searchcontroller.showPublishers.value
                              ? ListStores()
                              : PostSearchingList();
                        })),
                      ],
                    ),
                  ),
                ),
                SearchBox(),
                _BottomNavigationSection()
              ]),
            )));
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

Widget _buildTopSection(
    Searchcontroller searchcontroller, ThemeController themeController) {
  return Column(
    children: [
      SizedBox(height: 20.h),
      Text(
        "الــبحث".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.textColor(themeController.isDarkMode.value),
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        "قم بالبحث عن ماتريد عن طريق أدوات بحث مخصصة".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.textColor(themeController.isDarkMode.value),
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10.h),
      SearchFieldWithCategoryDropdown(searchcontroller: searchcontroller),
      SizedBox(height: 8.h),
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
                    searchcontroller.showMap.value = true;
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
              ),
              SortingIconsWithDropdown(),
            ],
          ),
        ),
      ),
      SizedBox(height: 5.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
        child: Padding(
          padding: EdgeInsets.only(right: 5.w, left: 5.w),
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
                    horizontal: 36.w,
                    vertical: 5.h,
                  ),
                  elevation: 2,
                  shadowColor: Colors.black26,
                ),
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 22.w,
                ),
                label: Text(
                  "خيارات الفلترة".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: Colors.white,
                    fontSize: 14.sp,
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
                    icon: Icon(
                      Icons.restart_alt_rounded,
                      color: AppColors.redColor,
                      size: 28.sp,
                    ),
                    onPressed: () {
                      controller.resetCategorySelection();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.h),
    ],
  );
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
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
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
              Icon(icon, size: 20.w, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 14.sp,
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

/// القسم العلوي للبحث في "الناشرين" (بحث بالاسم فقط)
Widget _buildPublishersTopSection(
  Searchcontroller searchcontroller,
  ThemeController themeController,
) {
  return Column(
    children: [
      SizedBox(height: 20.h),
      Text(
        "البحث عن ناشرين".tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.textColor(themeController.isDarkMode.value),
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 6.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: TextField(
          controller: searchcontroller.publisherNameController,
          decoration: InputDecoration(
            hintText: "أدخل اسم الناشر".tr,
            prefixIcon: Icon(
              Icons.person_search,
              color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onSubmitted: (value) => searchcontroller.fetchStoresList(
              language: Get.find<ChangeLanguageController>()
                  .currentLocale
                  .value
                  .languageCode,
              searchName: value.trim()),
        ),
      ),
      SizedBox(height: 10.h),
    ],
  );
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

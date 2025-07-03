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
                              vertical: 10.h, horizontal: 12.w),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode.value
                                  ? Colors.grey[900]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildToggleButton(
                                    context,
                                    label: 'المنشورات'.tr,
                                    icon: Icons.article,
                                    isActive: !searchcontroller.showPublishers.value,
                                    onTap: () => searchcontroller
                                        .showPublishers.value = false,
                                    themeController: themeController,
                                  ),
                                  SizedBox(width: 8.w),
                                  _buildToggleButton(
                                    context,
                                    label: 'الناشرين'.tr,
                                    icon: Icons.people,
                                    isActive: searchcontroller.showPublishers.value,
                                    onTap: () => searchcontroller
                                        .showPublishers.value = true,
                                    themeController: themeController,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 8.h),
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

  Widget _buildToggleButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required ThemeController themeController,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.oragne
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 22.w,
                    color: isActive
                        ? Colors.white
                        : AppColors.textColorOne(
                            themeController.isDarkMode.value)),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Colors.white
                        : AppColors.textColorOne(
                            themeController.isDarkMode.value),
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
    final themeController = Get.find<ThemeController>();
    
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
          Positioned(
            top: 100.h,
            right: 20.w,
            child: Material(
              color: Colors.transparent,
              child: _buildDropdown(categories[index], themeController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(SortingCategory category, ThemeController themeController) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value 
            ? Colors.grey[900] 
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, 
            blurRadius: 10, 
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value 
                  ? Colors.grey[800]!
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.title,
                    style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: _removeDropdown,
                ),
              ],
            ),
          ),
          ...category.options.map((option) => ListTile(
                leading: Icon(_getOptionIcon(option.value),
                    color: themeController.isDarkMode.value
                        ? Colors.grey[300]
                        : Colors.grey[700]),
                title: Text(option.label,
                    style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne, 
                        fontSize: 14.sp,
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black)),
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
    final themeController = Get.find<ThemeController>();
    
    return Container(
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value 
            ? Colors.grey[900] 
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          categories.length,
          (index) => GestureDetector(
            onTap: () => _toggleDropdown(index),
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: activeDropdownIndex == index
                    ? (themeController.isDarkMode.value
                        ? Colors.grey[700]
                        : Colors.grey[200])
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  categories[index].icon,
                  color: activeDropdownIndex == index
                      ? themeController.isDarkMode.value
                          ? Colors.white
                          : Theme.of(context).primaryColor
                      : themeController.isDarkMode.value
                          ? Colors.grey[400]
                          : Colors.grey[600],
                  size: 22.w,
                ),
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
      SizedBox(height: 16.h),
 Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w),
        child: SearchFieldWithCategoryDropdown(searchcontroller: searchcontroller),
      ),      SizedBox(height: 16.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Material(
                color: AppColors.oragne,
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () {
                    searchcontroller.searchingBox.value = true;
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_alt, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          "خيارات الفلترة".tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Material(
              color: themeController.isDarkMode.value
                  ? Colors.grey[800]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                onTap: () {
                  searchcontroller.showMap.value = true;
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(
                    Icons.location_on, 
                    color: AppColors.oragne
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Material(
              color: themeController.isDarkMode.value
                  ? Colors.grey[800]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                onTap: () {
                  controller.resetCategorySelection();
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(
                    Icons.restart_alt, 
                    color: Colors.red
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SortingIconsWithDropdown(),
      ),
      SizedBox(height: 8.h),
    ],
  );
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
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 12.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(16.r),
          child: TextField(
            controller: searchcontroller.publisherNameController,
            decoration: InputDecoration(
              hintText: "أدخل اسم الناشر".tr,
              prefixIcon: Icon(
                Icons.person_search, 
                color: themeController.isDarkMode.value
                    ? Colors.grey[400]
                    : Colors.grey
              ),
              filled: true,
              fillColor: themeController.isDarkMode.value
                  ? Colors.grey[900]
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
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
      ),
      SizedBox(height: 24.h),
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


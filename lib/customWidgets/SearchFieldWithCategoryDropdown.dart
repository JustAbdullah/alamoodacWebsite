import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/ThemeController.dart';
import '../controllers/searchController.dart';
import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';
import '../core/localization/changelanguage.dart';
import 'custome_textfiled.dart'; // تأكد من وجود تعريف TextFormFieldCustom في هذا الملف

/// هذا الودجت يجمع بين حقل البحث والأيقونة التي تفتح القائمة المنسدلة لتحديد القسم
class SearchFieldWithCategoryDropdown extends StatelessWidget {
  final Searchcontroller searchcontroller;

  const SearchFieldWithCategoryDropdown({
    Key? key,
    required this.searchcontroller,
  }) : super(key: key);

  /// دالة بناء القائمة المنسدلة لتحديد القسم
  Widget _buildCategoryDropdown() {
    return _buildDropdownSection(
      title: "عملية البحث داخل أقسام معينة".tr,
      child: DropdownFieldApi<int>(
        label: "اختر القسم الرئيسي".tr,
        items: [
          DropdownMenuItem<int>(
            value: 0,
            child: Text(
              "غير مدخل".tr,
              style: const TextStyle(fontSize: 19),
            ),
          ),
          ...searchcontroller.categoriesList.map(
            (cat) => DropdownMenuItem<int>(
              value: cat.id, // تأكد من أن لكل عنصر معرف (id) من نوع int
              child: Text(
                cat.translations.first.name,
                style: const TextStyle(fontSize: 19),
              ),
            ),
          )
        ],
        selectedItem: searchcontroller.selectIdToSearch.value,
        onChanged: (value) => _handleCategoryChange(value),
      ),
    );
  }

  /// دالة مساعدة لبناء قسم يحتوي على عنوان وحقل داخلي (مثل Dropdown)
  Widget _buildDropdownSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontWeight: FontWeight.bold,
              fontSize: 19),
        ),
        const SizedBox(height: 48),
        child,
      ],
    );
  }

  /// دالة لمعالجة تغيير القسم المختار وإغلاق القائمة المنسدلة
  void _handleCategoryChange(int? value) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (value != null) {
      // إغلاق القائمة المنسدلة (BottomSheet)
      Get.back();

      searchcontroller.selectIdToSearch.value = value;
      print("القسم المختار: $value");
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد اتجاه اللغة: إذا كانت اللغة عربية فإن الأيقونة على اليسار، وإلا على اليمين
    final bool isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    return SizedBox(
      width: 620.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // حقل البحث المخصص
          TextFormFieldCustom(
            maxLines: 1,
            label: "الــبحث الان".tr,
            hint: "أدخــل هنا أسم المنشور".tr,
            icon: Icons.search,
            controller: searchcontroller.isSearchText,
            fillColor: Colors.grey.shade200,
            hintColor: Colors.grey.shade500,
            iconColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
            borderColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
            fontColor: Colors.black,
            obscureText: false,
            borderRadius: 5,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.username],
            validator: (value) {
              if (value == null || value.isEmpty) {
                searchcontroller.textSearching.value = "";
                return "".tr;
              }
              return null;
            },
            onChanged: (value) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: []);
              searchcontroller.textSearching.value = value.toString();
              searchcontroller.fetchSearchPosts(
                language: Get.find<ChangeLanguageController>()
                    .currentLocale
                    .value
                    .languageCode,
                categoryId: searchcontroller.selectIdToSearch.value,
                subcategoryId: null,
                subcategoryLevel2Id: null,
                searchTerm: searchcontroller.textSearching.value,
                cityId: null,
              );
            },
          ),
          // أيقونة القائمة المنسدلة، موضوعة على اليسار أو اليمين بحسب اللغة
          Positioned(
            top: 0,
            bottom: 0,
            left: isArabic ? 8.0 : null,
            right: !isArabic ? 8.0 : null,
            child: IconButton(
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                size: 30,
              ),
              onPressed: () {
                // عرض القائمة المنسدلة باستخدام BottomSheet
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: _buildCategoryDropdown(),
                  ),
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// تعريف DropdownFieldApi مع النوع العام T لدعم أنواع القيم المختلفة (في حالتنا int)
class DropdownFieldApi<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;
  final Function(T?) onChanged;

  const DropdownFieldApi({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedItem,
      items: items,
      onChanged: onChanged,
      // تكبير حجم الخط داخل القائمة المنسدلة
      style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18,
          color: Colors.black),
    );
  }
}

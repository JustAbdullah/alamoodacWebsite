import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/ThemeController.dart';
import '../controllers/searchController.dart';
import '../core/constant/app_text_styles.dart';
import '../core/localization/changelanguage.dart';
import 'custome_textfiled.dart';

class SearchFieldWithCategoryDropdown extends StatelessWidget {
  final Searchcontroller searchcontroller;

  const SearchFieldWithCategoryDropdown({
    Key? key,
    required this.searchcontroller,
  }) : super(key: key);

  /*Widget _buildCategoryDropdown() {
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
              value: cat.id,
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
*/
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

  void _handleCategoryChange(int? value) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (value != null) {
      Get.back();
      searchcontroller.selectIdToSearch.value = value;
      print("القسم المختار: $value");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final bool isDarkMode = themeController.isDarkMode.value;
    final bool isArabic = Get.find<ChangeLanguageController>()
            .currentLocale
            .value
            .languageCode ==
        "ar";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormFieldCustom(
        maxLines: 1,
        label: "الــبحث الان".tr,
        hint: "أدخــل هنا أسم المنشور".tr,
        icon: Icons.search,
        controller: searchcontroller.isSearchText,
        fillColor: isDarkMode ? Colors.grey[850]! : Colors.white,
        hintColor: isDarkMode ? Colors.grey[500]! : Colors.grey[600]!, // إضافة ! للتأكيد على عدم القابلية للقيمة null
        iconColor: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!, // إضافة ! للتأكيد على عدم القابلية للقيمة null
        borderColor: Colors.transparent,
        fontColor: isDarkMode ? Colors.white : Colors.black,
        obscureText: false,
        borderRadius: 16,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 18.h,
        ),
        // تمت إزالة prefixIconPadding لأنها غير مدعومة
        keyboardType: TextInputType.text,
        autofillHints: const [AutofillHints.username],
      /*  suffixIcon: GestureDetector(
          onTap: () {
            Get.bottomSheet(
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                ),
                child: _buildCategoryDropdown(),
              ),
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              Icons.filter_list,
              size: 24.w,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ),*/
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
    );
  }
}

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
    final ThemeController themeController = Get.find();
    final isDarkMode = themeController.isDarkMode.value;
    
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
      ),
      value: selectedItem,
      items: items,
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: AppTextStyles.DinarOne,
        fontSize: 16.sp,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
      icon: Icon(
        Icons.arrow_drop_down,
        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/areaController.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/searchController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/data/model/Area.dart';
import '../../../core/localization/changelanguage.dart';
import '../../../customWidgets/DropdownField.dart';
import '../../../customWidgets/DropdwondFieldApi.dart';

class RealestateType extends StatelessWidget {
  const RealestateType({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    final AreaController areaController = Get.put(AreaController());
    Searchcontroller searchController = Get.put(Searchcontroller());
    final themeController = Get.find<ThemeController>();
    Widget buildDropdownField({
      required String keyLabel,
      required List<String> items,
      String? defaultValue,
    }) {
      final key = keyLabel.tr;
      return DropdownField(
        label: key,
        items: items,
        selectedItem: defaultValue ?? "غير مدخل".tr,
        onChanged: (value) {
          if (value != null && value != "غير مدخل".tr) {
            // ✨ إضافة المفتاح إذا غير موجود
            if (!searchController.detailRealestateControllers
                .containsKey(key)) {
              searchController.detailRealestateControllers[key] =
                  TextEditingController();
              print("➕ تم إنشاء المفتاح الجديد: $key");
            }

            // 📝 تحديث القيمة
            searchController.detailRealestateControllers[key]!.text = value;
            print(
                "✅ [$key] => ${searchController.detailRealestateControllers[key]!.text}");

            // 🔁 تحديث الواجهة
            searchController.update();
          } else {
            print("ℹ️ تم تجاهل القيمة لأنها غير مدخلة [$key]");
          }
        },
      );
    }

    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),

            buildDropdownField(
              keyLabel: "عدد الغرف",
              items: [
                "غير مدخل".tr,
                "لايوجد".tr,
                "غرفة واحدة".tr,
                "غرفتين".tr,
                "ثلاثة غرف".tr,
                "أربع غرف".tr,
                "خمس غرف".tr,
                "أكثر من خمس غرف".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "عدد الحمامات",
              items: [
                "غير مدخل".tr,
                "لايوجد".tr,
                "واحد".tr,
                "أثنين".tr,
                "ثلاثة".tr,
                "أكثر من ثلاثة".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "عدد الطوابق",
              items: [
                "غير مدخل".tr,
                "لايوجد".tr,
                "طابق واحد".tr,
                "طابقين".tr,
                "ثلاث طوابق".tr,
                "أكثر من ثلاث طوابق".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "مساحة البناء",
              items: [
                "غير مدخل".tr,
                "أقل من 100 متر مربع".tr,
                "من 100 إلى 200 متر مربع".tr,
                "من 200 إلى 300 متر مربع".tr,
                "أكثر من 300 متر مربع".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "مساحة الارض",
              items: [
                "غير مدخل".tr,
                "أقل من 100 متر مربع".tr,
                "من 100 إلى 200 متر مربع".tr,
                "من 200 إلى 500 متر مربع".tr,
                "أكثر من 500 متر مربع".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "عمر البناء",
              items: [
                "غير مدخل".tr,
                "سنة واحدة".tr,
                "سنتين".tr,
                "ثلاث سنين".tr,
                "أربعة سنين".tr,
                "خمس سنين".tr,
                "اكثر من خمس سنين".tr,
              ],
            ),

            SizedBox(height: 10.h),

            buildDropdownField(
              keyLabel: "طريقة الدفع",
              items: [
                "غير مدخل".tr,
                "كاش".tr,
                "يوجد آلية تقسيط".tr,
              ],
            ),
            Text(
              "المنطقة والمكان".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
             Obx(() {
       return   DropdownFieldApi(
            label: "اختر المدينة".tr,
            items: [
              "غير مدخل".tr,
              ...homeController.citiesList
                  .map((city) =>
                      city.translations.firstOrNull?.name ?? "غير معروف")
                  .toList(),
            ],
            selectedItem: homeController.chosedIdCity.value != null
                ? homeController.citiesList
                        .firstWhereOrNull((city) =>
                            city.id == homeController.chosedIdCity.value)
                        ?.translations
                        .firstOrNull
                        ?.name ??
                    "غير مدخل".tr
                : "غير مدخل".tr,
            onChanged: (value) {
              if (value != "غير مدخل".tr) {
                 areaController.selectedAreaName.value = null;
                final selectedCity = homeController.citiesList.firstWhereOrNull(
                  (city) => city.translations.any((t) => t.name == value),
                );

                if (selectedCity != null) {
                   areaController.selectedAreaName.value = null;
                  homeController.chosedIdCity.value = selectedCity.id;
                  print("تم اختيار المدينة بمعرف: ${selectedCity.id}");
                }
              } else {
                areaController.selectedAreaName.value = null;
                homeController.chosedIdCity.value = null; // التصحيح هنا
                print("تم إعادة تعيين معرف المدينة إلى null");
              }
            },
          );}),
          SizedBox(
            height: 10.h,
          ),
        Obx(() {
  String langCode = Get.find<ChangeLanguageController>()
      .currentLocale
      .value
      .languageCode;
  
  String routeSelected = homeController.selectedRoute.value;
  List<Area> areas = [];
  
  if (homeController.chosedIdCity.value != null) {
    if (routeSelected == "العراق") {
      if (langCode == 'tr') {
        areas = areaController.getAreasByCityIdTr(homeController.chosedIdCity.value!);
      } else if (langCode == 'ku') {
        areas = areaController.getAreasByCityIdKr(homeController.chosedIdCity.value!);
      } else {
        areas = areaController.getAreasByCityId(homeController.chosedIdCity.value!);
      }
    } else if (routeSelected == "تركيا") {
      areas = areaController.getAreasByCityTrIdTr(homeController.chosedIdCity.value!);
    }
  }
  
  List<String> areaItems = areas.isNotEmpty
      ? areas.map((area) => area.name).toList()
      : ["اختر المنطقة".tr];
  
  return DropdownFieldApi(
    label: "اختر المنطقة".tr,
    items: areaItems,
    selectedItem: areaController.selectedAreaName.value,
    onChanged: (value) {
      if (value == "اختر المنطقة".tr) {
        areaController.idOfArea.value = 0;
        areaController.selectedAreaName.value = null;
        return;
      }
      
      try {
        Area selectedArea = areas.firstWhere((area) => area.name == value);
        areaController.idOfArea.value = selectedArea.id;
        areaController.selectedAreaName.value = selectedArea.name;
        print("تم اختيار المنطقة: ${selectedArea.name} - ID: ${selectedArea.id}");
      } catch (e) {
        print("لم يتم العثور على المنطقة: $value");
      }
    },
  );
}),
            SizedBox(height: 14.h),

            // Input: نطاق السعر
            Text(
              "الفترة الزمنية".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor(themeController.isDarkMode.value),
              ),
            ),
            SizedBox(height: 8.h),
            DropdownField(
              label: "الفـترة الزمـنية".tr,
              items: [
                "غير مدخل".tr,
                "أخر أربعة وعشرين ساعة".tr,
                "أخر أسبوع".tr,
                "أخر شهر".tr,
                "أخر سنة".tr,
                "كل الأوقات".tr,
              ],
              selectedItem: "غير مدخل".tr,
              onChanged: (value) {
                if (value == "غير مدخل".tr) {
                } else if (value == "أخر أربعة وعشرين ساعة".tr) {
                  searchController.selectedTimeRange.value = "last_24_hours";
                } else if (value == "أخر أسبوع".tr) {
                  searchController.selectedTimeRange.value = "last_7_days";
                } else if (value == "أخر شهر".tr) {
                  searchController.selectedTimeRange.value = "last_month";
                } else if (value == "أخر سنة".tr) {
                  searchController.selectedTimeRange.value = "last_year";
                } else {
                  searchController.selectedTimeRange.value = "all_time";
                }
              },
            ),
            SizedBox(height: 14.h),
            Text(
              "نطاق السعر".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor(themeController.isDarkMode.value),
              ),
            ),
            SizedBox(height: 8.h),
            // Input: نطاق السعر
            TextField(
              onChanged: (value) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
              },
              controller:
                  searchController.detailRealestateControllers["السعر الأدنى"],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "السعر الأدنى".tr,
                labelStyle: TextStyle(
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 18.sp,
                ),
                prefixIcon: Icon(Icons.price_change,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value)),
                suffixText: "دينار عراقي".tr, // رمز العملة
                suffixStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.textColor(
                          themeController.isDarkMode.value)),
                  // رمز العملة),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.textColor(
                          themeController.isDarkMode.value)),
                ),
                filled: true,
                fillColor:
                    AppColors.cardColor(themeController.isDarkMode.value),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 12.h),

            // السعر الأعلى
            TextField(
              onChanged: (value) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
              },
              controller:
                  searchController.detailRealestateControllers["السعر الأعلى"],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 18.sp,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
                labelText: "السعر الأعلى".tr,
                prefixIcon: Icon(Icons.price_change,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value)),
                suffixText: "دينار عراقي".tr, // رمز العملة
                suffixStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    width: 2,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                      width: 2,
                      color: AppColors.textColor(
                          themeController.isDarkMode.value)),
                ),
                filled: true,
                fillColor:
                    AppColors.cardColor(themeController.isDarkMode.value),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: ElevatedButton.icon(
                onPressed: () {
                  // وظيفة زر الفلترة
                  searchController.filterPostsRealestate(context);
                },
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 20.sp,
                ),
                label: Text(
                  "الفرز الان".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 80.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ));
  }
}

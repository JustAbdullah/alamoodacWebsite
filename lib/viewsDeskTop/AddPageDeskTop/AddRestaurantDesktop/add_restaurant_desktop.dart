import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/areaController.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/userDahsboardController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/data/model/Area.dart';
import '../../../core/localization/changelanguage.dart';
import '../../../customWidgets/DropdownField.dart';
import '../../../customWidgets/DropdwondFieldApi.dart';
import '../../../customWidgets/PostDetailsField.dart';
import '../../../controllers/addPostRestaurantController.dart';

class AddRestaurantDesktop extends StatelessWidget {
  AddRestaurantDesktop({super.key});

  final _formKey = GlobalKey<FormState>();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final addpostcontroller = Get.put(Addpostrestaurantcontroller());
    final homeController = Get.put(HomeController());
    final themeController = Get.put(ThemeController());
    final areaController = Get.put(AreaController());
    final userData = Get.put(Userdahsboardcontroller());

    return GetX<Addpostrestaurantcontroller>(
        builder: (controller) => Visibility(
              visible: controller.showAdd.value,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: _buildAppBar(themeController, addpostcontroller),
                body: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: AppColors.backgroundColor(
                        themeController.isDarkMode.value),
                    child: SizedBox(
                      width: 600.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStepProgress(controller),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics:
                                  const ClampingScrollPhysics(), // تغيير الفيزياء
                              children: [
                                _buildStep1(context, controller, userData,
                                    themeController),
                                _buildStep2(context, controller, homeController,
                                    areaController, themeController),
                                _buildStep3(
                                    context, controller, themeController),
                                _buildStep4(
                                    context, controller, themeController),
                                _buildReviewStep(
                                    userData,
                                    controller,
                                    homeController,
                                    areaController,
                                    themeController),
                              ],
                            ),
                          ),
                          _buildNavigationButtons(
                              controller, userData, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  // AppBar مع تعديلات زر العودة
  AppBar _buildAppBar(
      ThemeController themeController, Addpostrestaurantcontroller add) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)),
          onPressed: () {
            add.hideAll();
            add.resetAll();
            Get.toNamed(
              '/add-post',
            );
          }),
      title: SizedBox(
          width: 600.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('إضافة منشور جديد'.tr,
                  style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 20.sp,
                      color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value))),
              Text(add.nameOfCatee.value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 18.sp,
                      color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value))),
            ],
          )),
      centerTitle: true,
      backgroundColor: themeController.isDarkMode.value
          ? AppColors.balckColorTypeFour
          : AppColors.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
          color: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value)),
    );
  }

  // تقدم الخطوات مع تأثير الظل
  Widget _buildStepProgress(Addpostrestaurantcontroller controller) {
    return Obx(
      () => Container(
        width: 600.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            bool isActive = index <= controller.currentStep.value;
            return GestureDetector(
              onTap: () {
                if (index < controller.currentStep.value) {
                  controller.currentStep.value = index;
                  _pageController.jumpToPage(index);
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value)
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getStepLabel(index),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: isActive
                          ? AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value)
                          : Colors.grey,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0:
        return 'المعلومات'.tr;
      case 1:
        return 'الموقع'.tr;
      case 2:
        return 'التفاصيل'.tr;
      case 3:
        return 'الصور'.tr;
      case 4:
        return 'التأكيد'.tr;
      default:
        return '';
    }
  }

  // الخطوة الأولى: المعلومات الأساسية
  Widget _buildStep1(
    BuildContext context,
    Addpostrestaurantcontroller controller,
    Userdahsboardcontroller userData,
    ThemeController themeController,
  ) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.w).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 620.h, // ديناميكي
        ),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 600.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle('المعلومات الأساسية'),
                _buildPublisherDropdown(controller, userData),
                SizedBox(height: 20.h),
                _buildCategoryDropdowns(controller),
              ],
            ),
          ),
        ));
  }

  Widget _buildPublisherDropdown(Addpostrestaurantcontroller controller,
      Userdahsboardcontroller userData) {
    return FormField<String>(
      validator: (value) =>
          value == "غير مدخل".tr ? 'يرجى اختيار الناشر'.tr : null,
      builder: (FormFieldState<String> state) {
        return SizedBox(
            width: 600.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownFieldApi(
                  label: "اختر اسم الناشر".tr,
                  items: [
                    "غير مدخل".tr,
                    ...userData.StorePuscherList.map(
                        (store) => store.translations.first.name).toList(),
                  ],
                  selectedItem: userData.StorePuscherList.isNotEmpty
                      ? "غير مدخل".tr
                      : null,
                  onChanged: (value) {
                    state.didChange(value);
                    if (value != "غير مدخل".tr) {
                      final selected = userData.StorePuscherList.firstWhere(
                        (store) => store.translations.first.name == value,
                      );
                      userData.selectedPublisher.value =
                          selected.translations.first.name;
                      userData.selectedPublisherId.value = selected.id;
                      userData.latitudeEnter = selected.latitude;
                      userData.longitudeEnter = selected.longitude;
                    }
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontFamily: AppTextStyles.DinarOne,
                      ),
                    ),
                  )
              ],
            ));
      },
    );
  }

  Widget _buildCategoryDropdowns(Addpostrestaurantcontroller controller) {
    return SizedBox(
        width: 600.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Visibility(
                  visible: controller.isHaveDayaSubOne.value,
                  child: FormField<String>(
                    validator: (value) => value == "غير مدخل".tr
                        ? 'يرجى اختيار القسم الفرعي'
                        : null,
                    builder: (FormFieldState<String> state) {
                      return SizedBox(
                          width: 600.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownFieldApi(
                                label: "اختر القسم الفرعي".tr,
                                items: [
                                  "غير مدخل".tr,
                                  ...controller.subCategories
                                      .map((sub) => sub.translations.first.name)
                                      .toList(),
                                ],
                                selectedItem:
                                    controller.subCategories.isNotEmpty
                                        ? "غير مدخل".tr
                                        : null,
                                onChanged: (value) {
                                  state.didChange(value);
                                  if (value != "غير مدخل".tr) {
                                    final selected =
                                        controller.subCategories.firstWhere(
                                      (sub) =>
                                          sub.translations.first.name == value,
                                    );
                                    controller.idSub = selected.id;
                                    controller.fetchSubcategoriesLevelTwo(
                                        selected.id);
                                  }
                                },
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontFamily: AppTextStyles.DinarOne,
                                    ),
                                  ),
                                )
                            ],
                          ));
                    },
                  ),
                )),
            Obx(() => Visibility(
                  visible: controller.isHaveSubTwo.value,
                  child: FormField<String>(
                    validator: (value) => value == "غير مدخل"
                        ? 'يرجى اختيار القسم الفرعي الثاني'
                        : null,
                    builder: (FormFieldState<String> state) {
                      return SizedBox(
                          width: 600.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: DropdownFieldApi(
                                  label: "اختر القسم الفرعي الثاني".tr,
                                  items: [
                                    "غير مدخل",
                                    ...controller.subcategoriesLevelTwo
                                        .map((sub) =>
                                            sub.translations.first.name)
                                        .toList(),
                                  ],
                                  selectedItem: controller
                                          .subcategoriesLevelTwo.isNotEmpty
                                      ? "غير مدخل"
                                      : null,
                                  onChanged: (value) {
                                    state.didChange(value);
                                    if (value != "غير مدخل") {
                                      final selected = controller
                                          .subcategoriesLevelTwo
                                          .firstWhere(
                                        (sub) =>
                                            sub.translations.first.name ==
                                            value,
                                      );
                                      controller.idSubTwo = selected.id;
                                    }
                                  },
                                ),
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontFamily: AppTextStyles.DinarOne,
                                    ),
                                  ),
                                )
                            ],
                          ));
                    },
                  ),
                )),
          ],
        ));
  }

  // الخطوة الثانية: الموقع الجغرافي
  Widget _buildStep2(
    BuildContext context,
    Addpostrestaurantcontroller controller,
    HomeController homeController,
    AreaController areaController,
    ThemeController themeController,
  ) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.w).copyWith(
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 620.h, // ديناميكياميكي
        ),
        child: Form(
          child: SizedBox(
            width: 600.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle('الموقع الجغرافي'),
                FormField<String>(
                  validator: (value) =>
                      value == "غير مدخل".tr ? 'يرجى اختيار المدينة' : null,
                  builder: (FormFieldState<String> state) {
                    return SizedBox(
                        width: 600.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownFieldApi(
                              label: "اختر المدينة".tr,
                              items: [
                                "غير مدخل".tr,
                                ...homeController.citiesList
                                    .map((city) =>
                                        city.translations.firstOrNull?.name ??
                                        "غير معروف")
                                    .toList(),
                              ],
                              selectedItem:
                                  homeController.chosedIdCity.value != null
                                      ? homeController.selectedCityName.value
                                      : "غير مدخل".tr,
                              onChanged: (value) {
                                state.didChange(value);
                                if (value != "غير مدخل".tr) {
                                  final selectedCity = homeController.citiesList
                                      .firstWhereOrNull(
                                    (city) => city.translations
                                        .any((t) => t.name == value),
                                  );
                                  homeController.chosedIdCity.value =
                                      selectedCity?.id;
                                  homeController.selectedCityName.value =
                                      value!;
                                }
                              },
                            ),
                            if (state.hasError)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                    fontFamily: AppTextStyles.DinarOne,
                                  ),
                                ),
                              )
                          ],
                        ));
                  },
                ),
                SizedBox(height: 20.h),
                Obx(() {
                  final langCode = Get.find<ChangeLanguageController>()
                      .currentLocale
                      .value
                      .languageCode;
                  List<Area> areas = [];

                  if (homeController.chosedIdCity.value != null) {
                    switch (langCode) {
                      case 'tr':
                        areas = areaController.getAreasByCityIdTr(
                            homeController.chosedIdCity.value!);
                        break;
                      case 'ku':
                        areas = areaController.getAreasByCityIdKr(
                            homeController.chosedIdCity.value!);
                        break;
                      default:
                        areas = areaController.getAreasByCityId(
                            homeController.chosedIdCity.value!);
                    }
                  }

                  return FormField<String>(
                    validator: (value) =>
                        value == "غير مدخل".tr ? 'يرجى اختيار المنطقة' : null,
                    builder: (FormFieldState<String> state) {
                      return SizedBox(
                          width: 600.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownFieldApi(
                                label: "اختر المنطقة".tr,
                                items: areas.isNotEmpty
                                    ? areas.map((area) => area.name).toList()
                                    : ["غير مدخل".tr],
                                onChanged: (value) {
                                  state.didChange(value);
                                  if (value != "غير مدخل".tr) {
                                    final selectedArea = areas.firstWhere(
                                        (area) => area.name == value);
                                    areaController.idOfArea.value =
                                        selectedArea.id;
                                    areaController.selectedAreaName.value =
                                        value!;
                                  }
                                },
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontFamily: AppTextStyles.DinarOne,
                                    ),
                                  ),
                                )
                            ],
                          ));
                    },
                  );
                }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    "ملاحظة: في حال عدم وجود مدينتك اختر غير مدخل".tr,
                    style: TextStyle(
                      color: AppColors.redColor,
                      fontSize: 14.sp,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // الخطوة الثالثة: تفاصيل المنشور
  Widget _buildStep3(BuildContext context,
      Addpostrestaurantcontroller controller, ThemeController themeController) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.w).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 620.h, // ديناميكي
        ),
        child: SizedBox(
          width: 600.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle('تفاصيل المنشور'),
              FormField<String>(
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال العنوان' : null,
                builder: (FormFieldState<String> state) {
                  return SizedBox(
                      width: 600.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PostDetailsField(
                            maxLines: 2,
                            label: "العنوان".tr,
                            hint: "أدخل عنوان المنشور".tr,
                            controller: controller.titleController,
                            keyboardType: TextInputType.text,
                          ),
                          if (state.hasError)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                  fontFamily: AppTextStyles.DinarOne,
                                ),
                              ),
                            )
                        ],
                      ));
                },
              ),
              SizedBox(height: 20.h),
              PostDetailsField(
                maxLines: 4,
                label: "نبذة عن المطعم".tr,
                hint: "نبذة عن المطعم".tr,
                controller: controller.detailControllers["نبذة عن المطعم"],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.h),
              PostDetailsField(
                maxLines: 3,
                label: "أوقات العمل".tr,
                hint: "أوقات العمل".tr,
                controller: controller.detailControllers["أوقات العمل"],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.h),
              DropdownField(
                label: "هل يوجد خدمة توصيل".tr,
                items: [
                  "غير مدخل".tr,
                  "نعم".tr,
                  "لا".tr,
                ],
                selectedItem: "غير مدخل".tr,
                onChanged: (value) {
                  controller.detailControllers["هل يوجد خدمة توصيل"]?.text =
                      value!;
                  print('تم اختيار: $value');
                },
              ),
              SizedBox(height: 20.h),
              DropdownField(
                label: "يوجد دفع الكتروني".tr,
                items: [
                  "غير مدخل".tr,
                  "نعم".tr,
                  "لا".tr,
                ],
                selectedItem: "غير مدخل".tr,
                onChanged: (value) {
                  controller.detailControllers["يوجد دفع الكتروني"]?.text =
                      value!;
                  print('تم اختيار: $value');
                },
              ),
              SizedBox(height: 20.h),
              DropdownField(
                label: "قسم العائلات".tr,
                items: [
                  "غير مدخل".tr,
                  "يوجد".tr,
                  "لايوجد".tr,
                ],
                selectedItem: "غير مدخل".tr,
                onChanged: (value) {
                  controller.detailControllers["قسم العائلات"]?.text = value!;
                  print('تم اختيار: $value');
                },
              ),
              SizedBox(height: 20.h),
              PostDetailsField(
                maxLines: 8,
                label: "أماكن الجلوس".tr,
                hint:
                    "أطلالات او اماكن الجلوس..مثل إطلالة خارجية وجود قسسم VIP خاص وإلخ.."
                        .tr,
                controller: controller.detailControllers["أماكن الجلوس"],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.h),
              PostDetailsField(
                maxLines: 8,
                label: "الخدمات الإضافية".tr,
                hint: "أدخل هنا الخدمات المميزة والخاصة بالمطعم".tr,
                controller: controller.detailControllers["الخدمات الإضافية"],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.h),
              PostDetailsField(
                maxLines: 8,
                label: "التفاصيل الإضافية".tr,
                hint: "أدخل هنا أي تفاصيل إضافية تريد وضعها".tr,
                controller: controller.detailControllers["تفاصيل اضافية"],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ));
  }

  Widget _buildPriceToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            : Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.balckColorTypeFour,
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // الخطوة الرابعة: الصور
  Widget _buildStep4(BuildContext context,
      Addpostrestaurantcontroller controller, ThemeController themeController) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.w).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 620.h, // ديناميكي
        ),
        child: SizedBox(
          width: 600.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle('الصور المرفقة'),
              InkWell(
                onTap: () => controller.pickImages(),
                child: Container(
                  width: 600.w,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.white),
                      SizedBox(width: 10.w),
                      Text(
                        "إضافة صور للمنشور".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppTextStyles.DinarOne,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => controller.images.isEmpty
                  ? Center(
                      child: Text(
                        "لم يتم اختيار أي صور".tr,
                        style: TextStyle(
                          fontFamily: AppTextStyles.DinarOne,
                          color: AppColors.textColor(
                              themeController.isDarkMode.value),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                      ),
                      itemCount: controller.images.length,
                      itemBuilder: (context, index) =>
                          _buildImageItem(controller, index),
                    )),
            ],
          ),
        ));
  }

  Widget _buildImageItem(Addpostrestaurantcontroller controller, int index) {
    return Stack(
      children: [
        Image.memory(
          controller.images[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => controller.updateImage(index),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.removeImage(index),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // الخطوة الخامسة: المراجعة
  Widget _buildReviewStep(
      Userdahsboardcontroller dataUser,
      Addpostrestaurantcontroller controller,
      HomeController homeController,
      AreaController areaController,
      ThemeController themeController) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: 600.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle('مراجعة المعلومات'),
              _buildReviewItem('الناشر', dataUser.selectedPublisher.value),
              _buildReviewItem(
                  'المدينة', homeController.selectedCityName.value),
              _buildReviewItem(
                  'المنطقة', areaController.selectedAreaName.value),
              _buildReviewItem('العنوان', controller.titleController.text),
              SizedBox(height: 30.h),
            ],
          ),
        ));
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: SizedBox(
          width: 600.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 16.sp,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value.isNotEmpty ? value : 'غير محدد',
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              Divider(color: Colors.grey[300], height: 16.h),
            ],
          ),
        ));
  }

  // أزرار التنقل
  Widget _buildNavigationButtons(Addpostrestaurantcontroller controller,
      Userdahsboardcontroller userData, BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentStep.value > 0)
              _buildNavigationButton(
                text: 'السابق'.tr,
                icon: Icons.arrow_back,
                onPressed: () {
                  controller.currentStep.value--;
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            if (controller.currentStep.value < 4)
              _buildNavigationButton(
                text: 'التالي'.tr,
                icon: Icons.arrow_forward,
                isPrimary: true,
                onPressed: () => _validateAndProceed(controller),
              ),
            if (controller.currentStep.value == 4)
              _buildSubmitButton(controller, userData, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white, size: 25.w),
      label: Text(text,
          style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 20.sp,
              color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            : Colors.grey[600],
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              width: 1),
        ),
      ),
      onPressed: onPressed,
    );
  }

  // زر الإرسال النهائي
  Widget _buildSubmitButton(Addpostrestaurantcontroller controller,
      Userdahsboardcontroller dataUser, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await controller.executePostCreation(
            dataUser.selectedPublisherId.value,
            dataUser.longitudeEnter,
            dataUser.latitudeEnter,
            controller.idCate,
            "active",
            context);

        if (controller.isAddPost.value == true) {
          Get.dialog(
            _buildSuccessDialog(context),
            barrierDismissible: false,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value),
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'نشر الآن'.tr,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: Colors.white,
        ),
      ),
    );
  }

  // رسالة النجاح
  Widget _buildSuccessDialog(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Dialog(
        backgroundColor: themeController.isDarkMode.value
            ? AppColors.blackColorTypeTeo
            : AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SizedBox(
            width: 600.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline,
                    color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    size: 60.w),
                SizedBox(height: 20.h),
                Text(
                  "تم التقديم بنجاح!".tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "تم رفع بيانات المنشور بنجاح. يخضع المنشور الآن لمراجعة فريقنا للتأكد من توافقه مع الشروط والأحكام. ستتم إشعارك فور الانتهاء من المراجعة."
                      .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: themeController.isDarkMode.value
                        ? AppColors.whiteColor
                        : AppColors.balckColorTypeFour,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
                SizedBox(height: 25.h),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      '/add-post', // المسار مع المعلمة الديناميكية
                      // إرسال الكائن كامل
                    );
                    Get.find<Addpostrestaurantcontroller>().hideAll();
                    Get.find<Addpostrestaurantcontroller>()
                        .resetAll(); // تم التعديل هنا
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    "متابعة".tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // تحقق من الصحة قبل الانتقال
  void _validateAndProceed(Addpostrestaurantcontroller controller) {
    controller.currentStep.value++;
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Text(
        title.tr,
        style: TextStyle(
          fontSize: 18.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

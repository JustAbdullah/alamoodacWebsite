import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/subscriptionController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/data/model/PackageModel.dart';
import '../../core/localization/changelanguage.dart';
import '../../customWidgets/DropdwondFieldApi.dart';
import '../Auth/login_screen.dart';

class ShowPackages extends StatelessWidget {
  const ShowPackages({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return GetX<Settingscontroller>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: controller.showPack.value,
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.showPack.value = false;
                            Get.offNamed(
                              '/settings-mobile/', // المسار مع المعلمة الديناميكية
                              // إرسال الكائن كامل
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColorIconBack(
                                      themeController.isDarkMode.value)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                                Get.find<ChangeLanguageController>()
                                            .currentLocale
                                            .value
                                            .languageCode ==
                                        "ar"
                                    ? ImagesPath.back
                                    : ImagesPath.arrowLeft,
                                width: 24.w,
                                height: 24.h,
                                color: AppColors.textColor(
                                    themeController.isDarkMode.value)),
                          ),
                        ),
                        SizedBox(
                          width: 250.w,
                          child: Text(
                            "الباقات المتاحة".tr,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontFamily: AppTextStyles.DinarOne,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 24.w), // For symmetric spacing
                      ],
                    ),
                  ),

                  // Packages Grid
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: _buildPackageGrid(controller, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageGrid(
      Settingscontroller controller, BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      if (controller.isLoadingPackages.value) return _buildShimmerLoader();
      if (controller.packages.isEmpty) return _buildEmptyState();

      return GridView.builder(
        padding: EdgeInsets.only(bottom: 20.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateColumns(context),
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: 0.7,
        ),
        itemCount: controller.packages.length,
        itemBuilder: (context, index) =>
            _buildPackageCard(controller.packages[index], context),
      );
    });
  }

  Widget _buildPackageCard(PackageModel package, BuildContext context) {
    final ThemeController themeController = Get.find();
    final locale = Get.locale?.languageCode ?? 'ar';
    final translation = package.translations.firstWhere(
      (t) => t.language == locale,
      orElse: () => package.translations.first,
    );

    final durationText = package.duration >= 365
        ? '${(package.duration / 365).toStringAsFixed(0)}${'سنة'.tr} '
        : '${package.duration}${'شهر'.tr}';

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.cardColor(themeController.isDarkMode.value),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.05),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          translation.translatedName,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontFamily: AppTextStyles.DinarOne,
                          ),
                        ),
                      ),
                      _buildPackageBadge(package),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    translation.translatedDescription,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value)
                              .withOpacity(0.7),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Price & Duration
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        package.price,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value),
                          fontFamily: AppTextStyles.DinarOne,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "دولار".tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textColor(
                                  themeController.isDarkMode.value)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18.w,
                          color: AppColors.textColor(
                                  themeController.isDarkMode.value)
                              .withOpacity(0.7)),
                      SizedBox(width: 8.w),
                      Text(
                        durationText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor(
                                  themeController.isDarkMode.value)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Features List
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: package.features.map((feature) {
                      final translation =
                          feature.featureTranslations.firstWhere(
                        (t) => t.language == locale,
                        orElse: () => feature.featureTranslations.first,
                      );

                      return Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                size: 20.w,
                                color: AppColors.backgroundColorIconBack(
                                    Get.find<ThemeController>()
                                        .isDarkMode
                                        .value)),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                translation.translatedText,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textColor(
                                      themeController.isDarkMode.value),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Subscribe Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 2,
                ),
                onPressed: () => _handleSubscription(package, context),
                child: Text(
                  "اشترك الآن".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageBadge(PackageModel package) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        _getPackageTypeLabel(package),
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getPackageTypeLabel(PackageModel package) {
    switch (package.packageType) {
      case 'diamond':
        return "مميزة".tr;
      case 'investor':
        return "استثمارية".tr;
      case 'commercial':
        return "تجارية".tr;
      case 'economic':
        return "اقتصادية".tr;
      default:
        return "عادية".tr;
    }
  }

  Widget _buildShimmerLoader() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: 20.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateColumns(Get.context!),
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: 0.7,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24.h,
                  width: 150.w,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 16.h,
                  width: 200.w,
                  color: Colors.white,
                ),
                SizedBox(height: 30.h),
                Container(
                  height: 36.h,
                  width: 120.w,
                  color: Colors.white,
                ),
                SizedBox(height: 30.h),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            height: 16.h,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final ThemeController themeController = Get.find();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80.w,
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.3)),
          SizedBox(height: 25.h),
          Text(
            "لا توجد باقات متاحة حالياً".tr,
            style: TextStyle(
              fontSize: 24.sp,
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "يمكنك المحاولة لاحقاً أو التواصل مع الدعم الفني".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () => Get.find<Settingscontroller>().fetchPackages(
                Get.find<ChangeLanguageController>()
                    .currentLocale
                    .value
                    .languageCode),
            child: Text(
              "إعادة المحاولة".tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 3;
    if (width > 700) return 2;
    return 1;
  }

  void _handleSubscription(PackageModel package, BuildContext context) {
    final loadingController = Get.put(LoadingController());

    final subscriptionController = Get.put(SubscriptionController());
    final homeController = Get.put(HomeController());
    final themeController = Get.find<ThemeController>();
    final locale = Get.locale?.languageCode ?? 'ar';

    // ترجمة اسم الباقة حسب اللغة
    final packageTranslation = package.translations.firstWhere(
      (t) => t.language == locale,
      orElse: () => package.translations.first,
    );

    // حساب مدة الاشتراك بطريقة شعرية
    final durationText = package.duration >= 365
        ? '${(package.duration / 365).toStringAsFixed(0)} ${'سنة'.tr}'
        : '${package.duration}${'شهر'.tr}';

    // عرض نافذة الاشتراك السفلية
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        padding: EdgeInsets.all(5.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // عنوان نافذة الاشتراك
              Text(
                "تأكيد طـلب الإشتراك".tr,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                ),
              ),
              SizedBox(height: 20.h),
              _buildPackageInfoSection(
                package: package,
                packageTranslation: packageTranslation,
                durationText: durationText,
                themeController: themeController,
              ),
              SizedBox(height: 25.h),
              _buildFeaturesSection(
                  package: package,
                  locale: locale,
                  themeController: themeController),
              SizedBox(height: 10.h),
              _buildCategorySelectionSection(
                package: package,
                homeController: homeController,
                subscriptionController: subscriptionController,
                themeController: themeController,
              ),
              SizedBox(height: 10.h),
              _buildNoteSection(themeController),
              SizedBox(height: 30.h),
              _buildActionButtons(
                  loadingController: loadingController,
                  sub: subscriptionController,
                  package: package,
                  themeController: themeController,
                  context: context),
            ],
          ),
        ),
      ),
    );
  }

// قسم يعرض معلومات الباقة بأسلوب راقٍ
  Widget _buildPackageInfoSection({
    required PackageModel package,
    required dynamic packageTranslation,
    required String durationText,
    required ThemeController themeController,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            packageTranslation.translatedName,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "${package.price} ${"دولار".tr}",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              fontFamily: AppTextStyles.DinarOne,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "${"لمدة".tr} $durationText".tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

// قسم يعرض مميزات الباقة بنكهة حماسية
  Widget _buildFeaturesSection({
    required PackageModel package,
    required String locale,
    required ThemeController themeController,
  }) {
    return Column(
      children: package.features.map((feature) {
        final featureTranslation = feature.featureTranslations.firstWhere(
          (t) => t.language == locale,
          orElse: () => feature.featureTranslations.first,
        );
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 20.w,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  featureTranslation.translatedText,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 15.sp,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

// قسم اختيار القسم المناسب للاشتراك بطريقة تفاعلية
  Widget _buildCategorySelectionSection({
    required PackageModel package,
    required HomeController homeController,
    required SubscriptionController subscriptionController,
    required ThemeController themeController,
  }) {
    List<int> commercialCategoryIds = [
      1,
      3,
      6,
      9,
      11,
      14,
      15,
      17,
      20,
      21,
      22,
      23,
      25,
      26,
      27,
      28
    ]; // المعرفات الخاصة بالباقة التجارية
    List<int> economicCategoryIds = [
      2,
      4,
      5,
      8,
      12,
      13,
      16,
      19,
      24
    ]; // المعرفات الخاصة بالباقة الاقتصادية
    List<int> freeCategoryIds = [18]; // المعرفات الخاصة بالأقسام المجانية
    List<int> unavailableCategoryIds = [
      9,
      10
    ]; // المعرفات الخاصة بالأقسام غير المتوفرة

    List<String> filteredCategories = [];

    // تصفية الأقسام بناءً على الباقة المختارة
    if (package.packageType == "commercial") {
      filteredCategories = homeController.categoriesList
          .where((cat) =>
              commercialCategoryIds.contains(cat.id) &&
              !unavailableCategoryIds
                  .contains(cat.id)) // تصفية الأقسام التجارية
          .map((cat) => cat.translations.first.name)
          .toList();
    } else if (package.packageType == "economic") {
      filteredCategories = homeController.categoriesList
          .where((cat) =>
              economicCategoryIds.contains(cat.id) &&
              !unavailableCategoryIds
                  .contains(cat.id)) // تصفية الأقسام الاقتصادية
          .map((cat) => cat.translations.first.name)
          .toList();
    }

    // إضافة "غير مدخل" فقط إذا كانت القائمة تحتوي على أقسام
    if (filteredCategories.isNotEmpty) {
      filteredCategories.insert(0, "غير مدخل".tr);
    }

    return filteredCategories.isNotEmpty
        ? DropdownFieldApi(
            label: "اختر القسم".tr,
            items: filteredCategories,
            selectedItem: filteredCategories.isNotEmpty ? "غير مدخل".tr : null,
            onChanged: (value) {
              if (value != "غير مدخل".tr) {
                final selected = homeController.categoriesList.firstWhere(
                  (cat) => cat.translations.first.name == value,
                );
                subscriptionController.selectedTheSections =
                    selected.translations.first.name.toString();
                subscriptionController.IdTheSections = selected.id;
              }
            },
          )
        : Text(
            "هذا العرض يشمل جميع الأقسام".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          );
  }

// قسم التنبيه بأسلوب صريح وواضح
  Widget _buildNoteSection(ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(Icons.error_outlined, size: 20.w, color: AppColors.redColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "ملاحظة: يتم مراجعة طلب الإشتراك من طرف الإدارة وفي حال الموافقة سيتم إنشاء الباقة"
                  .tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 15.sp,
                color: AppColors.redColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

// أزرار الإجراء لتأكيد أو إلغاء الطلب بروح جريئة
  Widget _buildActionButtons(
      {required LoadingController loadingController,
      required SubscriptionController sub,
      required PackageModel package,
      required ThemeController themeController,
      required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.3),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () => Get.back(),
            child: Text(
              "إلغاء".tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () async {
              if (loadingController.currentUser == null) {
                // عرض Snackbar إذا لم يتم العثور على بيانات المستخدم
                Get.snackbar(
                  '', // اترك العنوان فارغًا لأنك ستستخدم titleText
                  '',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  titleText: Text(
                    "ليس لديك الإذن".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  messageText: Text(
                    'لاتستطيع القيام بهذه العملية قم بتسجيل دخولك اولاً'.tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  mainButton: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>()
                              .isDarkMode
                              .value), // لون الخلفية
                      foregroundColor: Colors.white, // لون النص
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // شكل الزر
                      ),
                    ),
                    onPressed: () {
                      // التوجيه إلى شاشة تسجيل الدخول
                      Get.to(LoginScreen());
                    },
                    child: Text(
                      'تسجيل الدخول'.tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                );
              } else {
                sub.createSubscriptionRequest(
                    packageId: package.packageId,
                    selectedSections: sub.selectedTheSections,
                    sectionId: sub.IdTheSections,
                    context: context);
                await Future.delayed(Duration(milliseconds: 2750));
                await sub.isDoneSub.value == true
                    ? _processPayment(package, context)
                    : null;
              }
            },
            child: Text(
              "الطلب".tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

// نافذة معالجة الدفع برسالة تأكيد جذابة
  void _processPayment(PackageModel package, BuildContext context) {
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
        backgroundColor:
            AppColors.backgroundColor(themeController.isDarkMode.value),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.check_circle_outline_rounded,
                size: 70.w,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            SizedBox(height: 25.h),
            Text(
              "تم الإضافة في قائمة الطلب سيتم المراجعة".tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "${package.packageName} ${"الباقة التى طلبتها:".tr}".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.7),
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () {
                Get.back();
                Navigator.of(context, rootNavigator: true).pop();
                Get.find<Settingscontroller>().showPack.value = false;
              },
              child: Text(
                "حسناً".tr,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

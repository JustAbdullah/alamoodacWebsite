import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/addPostControllerAll.dart';
import '../../controllers/addPostControllerAuction.dart';
import '../../controllers/addPostControllerCar.dart';
import '../../controllers/addPostControllerCompany.dart';
import '../../controllers/addPostControllerEducational.dart';
import '../../controllers/addPostControllerProfessions.dart';
import '../../controllers/addPostControllerRealEstate.dart';
import '../../controllers/addPostControllerUsed.dart';
import '../../controllers/addPostDailyWorkerController.dart';
import '../../controllers/addPostRestaurantController.dart';
import '../../controllers/addPostSalonsController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/subscriptionController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/category.dart';
import '../../customWidgets/custom_container.dart';

import '../AuthDeskTop/login_screen_desktop.dart';
import '../SettingsDeskTop/show_packages_desktop.dart';
import '../SidePopup.dart';
import '../homeDeskTop/top_section_desktop.dart';

class AddListDeskTop extends StatelessWidget {
  const AddListDeskTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers
    SubscriptionController scriptionController =
        Get.put(SubscriptionController());

    /////////////................Two.............//////////////

    AddpostUsedController addpostUsedController =
        Get.put(AddpostUsedController());

    AddpostCarController addpostCarController = Get.put(AddpostCarController());
    /////////////................Four.............//////////////

    AddpostProfessionController addpostProfessionController =
        Get.put(AddpostProfessionController());

    /////////.........................Seven..................../
    Addpostcontrollerrealestate addpostcontrollerrealestate =
        Get.put(Addpostcontrollerrealestate());

    Addpostcontrollerauction addpostcontrollerauction =
        Get.put(Addpostcontrollerauction());

    Addpostcontrollerall addpostcontrollerall = Get.put(Addpostcontrollerall());
    ////////////////////العمــال اليومين.....18......//////////////////
    Addpostdailyworkercontroller addpostdailyworkercontroller =
        Get.put(Addpostdailyworkercontroller());
    /////////////////14......................المطاعم.......................////////
    Addpostrestaurantcontroller addpostrestaurantcontroller =
        Get.put(Addpostrestaurantcontroller());

////////////////////..............15...............دليل الشركات .....///////////////////
    Addpostcontrollercompany addpostcontrollercompany =
        Get.put(Addpostcontrollercompany());
    ////////////////////..............17............... التعليمية.....///////////////////
    Addpostcontrollereducational addpostcontrollereducational =
        Get.put(Addpostcontrollereducational());
//////.............................23 صالونات...........//////////
    Addpostsalonscontroller addpostsalonscontroller =
        Get.put(Addpostsalonscontroller());

    final ThemeController themeController = Get.find();
    final loadingController = Get.find<LoadingController>();
    final homeController = Get.find<HomeController>();

    final Map<int, String> singlePostPrice = {
      1: '\$100',
      2: '\$20',
      3: '\$100',
      4: '\$20',
      5: '\$20',
      6: '\$100',
      7: '\$20',
      8: '\$20',
      9: 'غير متوفر'.tr,
      10: 'غير متوفر'.tr,
      11: '\$100',
      12: '\$20',
      13: '\$20',
      14: '\$100',
      15: '\$100',
      16: '\$20',
      17: '\$100',
      18: 'مجاني'.tr,
      19: '\$20',
      20: '\$100',
      21: '\$100',
      22: '\$100',
      23: '\$100',
      24: '\$20',
      25: '\$100',
      26: '\$100',
      27: '\$100',
      28: '\$100',
    };

    void _openCategory(Category category) {
      final name = category.translations.first.name;
      switch (category.id) {
        case 2:
          addpostUsedController
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 3:
          addpostCarController
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 4:
          addpostProfessionController
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddProfession.value = true;
          break;
        case 6:
          addpostcontrollerrealestate
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 8:
          addpostcontrollerauction
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 9:
        case 10:
          // هذه الفئات مخصصة للأدمِن فقط، وقد تجاوزها بالفعل بالأعلى
          addpostcontrollerall
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddAllPost.value = true;
          break;
        case 14:
          addpostrestaurantcontroller
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 15:
          addpostcontrollercompany
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 17:
          addpostcontrollereducational
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        case 23:
          addpostsalonscontroller
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          break;
        default:
          addpostcontrollerall
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddAllPost.value = true;
      }
    }

    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor(themeController.isDarkMode.value),
      body: Column(
        children: [
          // ===== Header =====
          const TopSectionDeskTop(),
          SizedBox(height: 12.h),

          // ===== Subtitle =====
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Text(
                  "اختر قسم من الأقسام التالية".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // ===== Categories List =====
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                // 1. Loading Skeleton
                if (homeController.isLoadingCategories.value) {
                  return ListView.separated(
                    itemCount: 8,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) => Skeletonizer(
                      child: ListTile(
                        leading: Container(
                            width: 56.w, height: 56.h, color: Colors.grey[300]),
                        title: Container(
                            width: 200.w,
                            height: 16.h,
                            color: Colors.grey[300]),
                        subtitle: Container(
                            width: 150.w,
                            height: 12.h,
                            color: Colors.grey[300]),
                      ),
                    ),
                  );
                }

                // 2. Empty State
                if (homeController.categoriesList.isEmpty) {
                  return Center(
                    child: Text(
                      "المعــذرة البيانات حاليًا غير متاحة للعرض ..حاول مجددًا"
                          .tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppTextStyles.DinarOne,
                        color: AppColors.redColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // 3. Actual ListView
                return ListView.separated(
                  itemCount: homeController.categoriesList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final category = homeController.categoriesList[index];
                    final price = singlePostPrice[category.id] ?? '';

                    return InkWell(
                      onTap: () {
                        final loadingCtrl = Get.find<LoadingController>();
                        final user = loadingCtrl.currentUser;

                        // 1️⃣ التأكد من تسجيل الدخول
                        if (user == null) {
                          Get.snackbar(
                            '',
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
                              'لا تستطيع القيام بهذه العملية قم بتسجيل دخولك أولاً'
                                  .tr,
                              style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            mainButton: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.TheMain,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => const LoginPopup(),
                              ),
                              child: Text('تسجيل الدخول'.tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        // 2️⃣ حالة daily worker (category 18)
                        if (homeController.showMessage.value) return;
                        if (category.id == 18) {
                          addpostdailyworkercontroller.idCate = category.id;
                          addpostdailyworkercontroller.nameOfCatee.value =
                              category.translations.first.name;
                          addpostdailyworkercontroller
                              .fetchSubcategories(category.id);
                          addpostdailyworkercontroller.showAdd.value = true;
                          return;
                        }

                        // 3️⃣ إذا كان الأدمِن (id == 80) يمر بلا قيود ويُفتح أي قسم
                        if (user.id == 80) {
                          _openCategory(category);
                          return;
                        }

                        // 4️⃣ لمستخدم عادي: جلب الاشتراكات وتصفية النشطة
                        final subs = scriptionController.subscriptions;
                        if (subs.isEmpty) {
                          Get.snackbar(
                            'ليس لديك باقة نشطة'.tr,
                            'يجب الاشتراك لإنشاء منشور'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            mainButton: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.TheMain,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () => showSidePopup(
                                context: context,
                                child: const ShowPackagesDeskTopPage(),
                                widthPercent: 0.75,
                                useSideAlignment: false,
                              ),
                              child: Text('اشتري باقة'.tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        final now = DateTime.now();
                        final activeSubs = subs
                            .where((sub) =>
                                sub.endDate.isAfter(now) &&
                                sub.usedAds < sub.adsLimit)
                            .toList();

                        if (activeSubs.isEmpty) {
                          Get.snackbar(
                            'لا يوجد باقات سارية'.tr,
                            'انتهت باقاتك أو استنفدت عدد المنشورات'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            mainButton: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.TheMain,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () => showSidePopup(
                                context: context,
                                child: const ShowPackagesDeskTopPage(),
                                widthPercent: 0.75,
                                useSideAlignment: false,
                              ),
                              child: Text('تجديد الباقة'.tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        final hasAccess = activeSubs.any((sub) =>
                            sub.selectedTheId == null ||
                            sub.selectedTheId == 99 ||
                            sub.selectedTheId == category.id);

                        if (!hasAccess) {
                          Get.snackbar(
                            'غير مسموح'.tr,
                            'باقتك لا تسمح بالنشر في هذا القسم'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            mainButton: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.oragne,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () => showSidePopup(
                                context: context,
                                child: const ShowPackagesDeskTopPage(),
                                widthPercent: 0.75,
                                useSideAlignment: false,
                              ),
                              child: Text('الباقات'.tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        // 5️⃣ منع المستخدم العادي من الأقسام 9 و10 (للأدمِن فقط)
                        if ((category.id == 9 || category.id == 10) &&
                            user.id != 80) {
                          Get.snackbar(
                            'غير مسموح'.tr,
                            'هذا القسم للأدمِن فقط'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        // 6️⃣ كل الشروط تمام، افتح القسم
                        _openCategory(category);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor(
                              themeController.isDarkMode.value),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            // صورة القسم
                            CachedNetworkImage(
                              imageUrl: category.image,
                              width: 56.w,
                              height: 56.h,
                              fit: BoxFit.cover,
                              imageBuilder: (ctx, img) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: img, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (ctx, url) => ContainerCustom(
                                colorContainer:
                                    AppColors.backgroundColorIconBack(
                                        themeController.isDarkMode.value),
                                widthContainer: 56.w,
                                heigthContainer: 56.h,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)),
                              ),
                              errorWidget: (ctx, url, err) => Container(
                                width: 56.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.backgroundColor(
                                      themeController.isDarkMode.value),
                                ),
                                child: Icon(Icons.broken_image,
                                    size: 24.sp,
                                    color: AppColors.textColorOne(
                                        themeController.isDarkMode.value)),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // نص القسم
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.translations.first.name,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor(
                                          themeController.isDarkMode.value),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    category.translations.first.description,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColorOne(
                                          themeController.isDarkMode.value),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // عرض السعر
                            if (price.isNotEmpty)
                              Column(
                                children: [
                                  Text(
                                    "السعر".tr,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.DinarOne,
                                      fontSize: 12.sp,
                                      color: AppColors.textColorOne(
                                          themeController.isDarkMode.value),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: price == 'مجاني'.tr
                                          ? Colors.green.withOpacity(0.2)
                                          : price == 'غير متوفر'.tr
                                              ? Colors.red.withOpacity(0.2)
                                              : price == '\$20'
                                                  ? Colors.orange
                                                      .withOpacity(0.2)
                                                  : Colors.blue
                                                      .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      price,
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.DinarOne,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: price == 'مجاني'.tr
                                            ? Colors.green
                                            : price == 'غير متوفر'.tr
                                                ? Colors.red
                                                : price == '\$20'
                                                    ? Colors.orange
                                                    : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

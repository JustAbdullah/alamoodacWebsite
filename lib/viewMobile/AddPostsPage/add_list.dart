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
import '../../controllers/subscriptionController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/category.dart';
import '../../customWidgets/custom_container.dart';
import '../../customWidgets/custom_flag.dart';
import '../../customWidgets/custom_logo.dart';
import '../../controllers/settingsController.dart';
import '../Auth/login_screen.dart';
import '../OnAppPages/menu.dart';
import '../Settings/show_packages.dart';
import '../show_message_info.dart';
import 'AddAllPost/add_post.dart';
import 'AddAuctionsPage/add_auctions.dart';
import 'AddCar/add_car.dart';
import 'AddCompany/add_company.dart';
import 'AddDailyWorker/add_daily_worker.dart';
import 'AddEducational/add_educational.dart';
import 'AddProfessions/add_professions.dart';
import 'AddRealEstate/add_real_estates.dart';
import 'AddRestaurant/add_restaurant.dart';
import 'AddSalons/add_salons.dart';
import 'AddUsedFurniture/add_used.dart';

class AddList extends StatelessWidget {
  const AddList({super.key});

  @override
  Widget build(BuildContext context) {
     // === Controllers (ثبات كما هو) ===
    final SubscriptionController scriptionController =
        Get.put(SubscriptionController());
    final addpostUsedController = Get.put(AddpostUsedController());
    final addpostCarController = Get.put(AddpostCarController());
    final addpostProfessionController = Get.put(AddpostProfessionController());
    final addpostcontrollerrealestate = Get.put(Addpostcontrollerrealestate());
    final addpostcontrollerauction = Get.put(Addpostcontrollerauction());
    final addpostcontrollerall = Get.put(Addpostcontrollerall());
    final addpostdailyworkercontroller =
        Get.put(Addpostdailyworkercontroller());
    final addpostrestaurantcontroller = Get.put(Addpostrestaurantcontroller());
    final addpostcontrollercompany = Get.put(Addpostcontrollercompany());
    final addpostcontrollereducational =
        Get.put(Addpostcontrollereducational());
    final addpostsalonscontroller = Get.put(Addpostsalonscontroller());
    final themeController = Get.find<ThemeController>();
    final loadingController = Get.find<LoadingController>();

    final Map<int, String> singlePostPrice = {
      1: 'باقة تجارية',
      2: 'باقة اقتصادية',
      3: 'باقة تجارية',
      4: 'باقة اقتصادية',
      5: 'باقة اقتصادية',
      6: 'باقة تجارية',
      7: 'باقة اقتصادية',
      8: 'باقة اقتصادية',
      9: 'غير متوفر'.tr,
      10: 'غير متوفر'.tr,
      11: 'باقة تجارية',
      12: 'باقة اقتصادية',
      13: 'باقة اقتصادية',
      14: 'باقة تجارية',
      15: 'باقة تجارية',
      16: 'باقة اقتصادية',
      17: 'باقة تجارية',
      18: 'مجاني'.tr,
      19: 'باقة اقتصادية',
      20: 'باقة تجارية',
      21: 'باقة تجارية',
      22: 'باقة تجارية',
      23: 'باقة تجارية',
      24: 'باقة اقتصادية',
      25: 'باقة تجارية',
      26: 'باقة تجارية',
      27: 'باقة تجارية',
      28: 'باقة تجارية',
          29: 'باقة تجارية',
      30: 'باقة تجارية',

      // أضف باقي المعرفات حسب الحاجة
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
          Get.to(() => AddUsed());
          break;
        case 3:
          addpostCarController
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddCar());
          break;
        case 4:
          addpostProfessionController
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddProfession.value = true;
          Get.to(() => AddProfessions());
          break;
        case 6:
          addpostcontrollerrealestate
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddRealEstates());
          break;
           case 30:
          addpostcontrollerrealestate
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddRealEstates());
          break;
        case 8:
          addpostcontrollerauction
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddAuction(
                onConfirm: (DateTime startDateTime, DateTime endDateTime) {},
              ));
          break;
        case 9:
        case 10:
          // هذه الفئات مخصصة للأدمِن فقط، وقد تجاوزها بالفعل بالأعلى
          addpostcontrollerall
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddAllPost.value = true;
          Get.to(() => AddPostAll());
          break;
        case 14:
          addpostrestaurantcontroller
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddRestaurant());
          break;
        case 15:
          addpostcontrollercompany
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddCompany());
          break;
        case 17:
          addpostcontrollereducational
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddEducational());
          break;
        case 23:
          addpostsalonscontroller
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAdd.value = true;
          Get.to(() => AddSalons());
          break;
        default:
          addpostcontrollerall
            ..idCate = category.id
            ..nameOfCatee.value = name
            ..fetchSubcategories(category.id)
            ..showAddAllPost.value = true;
          Get.to(() => AddPostAll());
      }
    }

    return GetX<HomeController>(
        builder: (controller) => Visibility(
              visible: controller.addPost.value,
              child: Scaffold(
                backgroundColor:
                    AppColors.backgroundColor(themeController.isDarkMode.value),
                body: Stack(children: [
                  Column(
                    children: [
                      // --- الشعار والراية ---
                      Container(
                        width: double.infinity,
                        height: 70.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [CustomLogo(), CustomFlag()],
                        ),
                      ),

                      SizedBox(height: 5.h),

                      // --- عنوان الصفحة ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "اختر قسم من الأقسام التالية".tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.textColor(
                                themeController.isDarkMode.value),
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // --- نص توضيحي لسعر الباقة المنفردة ---

                      // --- قائمة الأقسام ---
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Obx(() {
                            if (controller.isLoadingCategories.value) {
                              return ListView.builder(
                                itemCount: 9,
                                itemBuilder: (_, i) => Skeletonizer(
                                  child: ListTile(
                                    title: Container(
                                        width: 200,
                                        height: 20,
                                        color: Colors.grey[300]),
                                    subtitle: Container(
                                        width: 150,
                                        height: 15,
                                        color: Colors.grey[300]),
                                  ),
                                ),
                              );
                            } else if (controller.categoriesList.isEmpty) {
                              return Center(
                                child: Text(
                                  "المعـذرة، البيانات غير متاحة حالياً".tr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppTextStyles.DinarOne,
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: controller.categoriesList.length,
                                itemBuilder: (context, idx) {
                                  final category =
                                      controller.categoriesList[idx];
                                  final price =
                                      singlePostPrice[category.id] ?? '';

                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.h),
                                    child: InkWell(
                                      onTap: () {
                                        final loadingCtrl =
                                            Get.find<LoadingController>();
                                        final user = loadingCtrl.currentUser;
                                       print("One In InkWell");

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
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            messageText: Text(
                                              'لا تستطيع القيام بهذه العملية قم بتسجيل دخولك أولاً'
                                                  .tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            mainButton: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.TheMain,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                              ),
                                              onPressed: () =>
                                                  Get.to(() => LoginScreen()),
                                              child: Text('تسجيل الدخول'.tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          return;
                                        } // ➕ 1.1️⃣ شرط الإضافة المجانية: إذا لم يستخدم المستخدم فرصته المجانية بعد
if (user.free_post_used == 0) {
    // نعلم أنه استخدم الفرصة
    // نفتح القسم مباشرة
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
    return;
  }
print("Two In InkWell");
                                        // 2️⃣ حالة daily worker (category 18)
                                        if (controller.showMessage.value)
                                          return;
                                       
                                       print("Three In InkWell");
                                        if (category.id == 18) {
                                          addpostdailyworkercontroller.idCate =
                                              category.id;
                                          addpostdailyworkercontroller
                                                  .nameOfCatee.value =
                                              category.translations.first.name;
                                          addpostdailyworkercontroller
                                              .fetchSubcategories(category.id);
                                          addpostdailyworkercontroller
                                              .showAdd.value = true;
                                          Get.to(() => AddDailyWorker());
                                          return;
                                        }

                                        // 3️⃣ إذا كان الأدمِن (id == 80) يمر بلا قيود ويُفتح أي قسم
                                        if (user.id == 80) {
                                          _openCategory(category);
                                          return;
                                        }
                                        // 4️⃣ لمستخدم عادي: جلب الاشتراكات وتصفية النشطة
                                        final subs =
                                            scriptionController.subscriptions;
                                        if (subs.isEmpty) {
                                          Get.snackbar(
                                            'ليس لديك باقة نشطة'.tr,
                                            'يجب الاشتراك لإنشاء منشور'.tr,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            mainButton: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.TheMain,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                              ),
                                              onPressed: () {
                                                Get.find<Settingscontroller>()
                                                    .showPack
                                                    .value = true;
                                                Get.to(() => ShowPackages());
                                              },
                                              child: Text('اشتري باقة'.tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
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
                                            'انتهت باقاتك أو استنفدت عدد المنشورات'
                                                .tr,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                            mainButton: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.TheMain,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                              ),
                                              onPressed: () {
                                                Get.find<Settingscontroller>()
                                                    .showPack
                                                    .value = true;
                                                Get.to(() => ShowPackages());
                                              },
                                              child: Text('تجديد الباقة'.tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          return;
                                        }

                                        final hasAccess = activeSubs.any(
                                            (sub) =>
                                                sub.selectedTheId == null ||
                                                sub.selectedTheId == 99 ||
                                                sub.selectedTheId ==
                                                    category.id);

                                        if (!hasAccess) {
                                          Get.snackbar(
                                            'غير مسموح'.tr,
                                            'باقتك لا تسمح بالنشر في هذا القسم'
                                                .tr,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                            mainButton: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.oragne,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                              ),
                                              onPressed: () {
                                                Get.find<Settingscontroller>()
                                                    .showPack
                                                    .value = true;
                                                Get.to(() => ShowPackages());
                                              },
                                              child: Text('الباقات'.tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          return;
                                        }

                                        // 5️⃣ منع المستخدم العادي من الأقسام 9 و10 (للأدمِن فقط)
                                        if ((category.id == 9 ||
                                                category.id == 10) &&
                                            user.id != 80) {
                                          Get.snackbar(
                                            'غير مسموح'.tr,
                                            'هذا القسم للأدمِن فقط'.tr,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                            duration:
                                                const Duration(seconds: 3),
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
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 6,
                                                offset: Offset(0, 2))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 10.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // صورة القسم
                                              CachedNetworkImage(
                                                imageUrl: category.image,
                                                width: 50.w,
                                                height: 50.h,
                                                fit: BoxFit.cover,
                                                imageBuilder: (ctx, img) =>
                                                    Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    image: DecorationImage(
                                                        image: img,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (ctx, url) =>
                                                    ContainerCustom(
                                                  colorContainer: AppColors
                                                      .backgroundColorIconBack(
                                                          themeController
                                                              .isDarkMode
                                                              .value),
                                                  widthContainer: 50.w,
                                                  heigthContainer: 50.h,
                                                  child: Center(
                                                      child: Text("على مودك".tr,
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontFamily:
                                                                  AppTextStyles
                                                                      .DinarOne,
                                                              color: AppColors.textColor(
                                                                  themeController
                                                                      .isDarkMode
                                                                      .value)),
                                                          textAlign: TextAlign
                                                              .center)),
                                                ),
                                                errorWidget: (ctx, url, err) =>
                                                    Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  color:
                                                      AppColors.backgroundColor(
                                                          themeController
                                                              .isDarkMode
                                                              .value),
                                                  child: Icon(
                                                      Icons.broken_image,
                                                      color: AppColors
                                                          .backgroundColorIconBack(
                                                              themeController
                                                                  .isDarkMode
                                                                  .value),
                                                      size: 30.sp),
                                                ),
                                              ),

                                              SizedBox(width: 12.w),

                                              // اسم ووصف القسم
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      category.translations
                                                          .first.name,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTextStyles
                                                                .DinarOne,
                                                        color:
                                                            AppColors.textColor(
                                                                themeController
                                                                    .isDarkMode
                                                                    .value),
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      category.translations
                                                          .first.description,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppTextStyles
                                                                .DinarOne,
                                                        color: AppColors
                                                            .textColorOne(
                                                                themeController
                                                                    .isDarkMode
                                                                    .value),
                                                        fontSize: 14.sp,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 10.w),

                                              // توضيح السعر كباقة منفردة
                                              if (price.isNotEmpty)
                                                   Visibility(
                                          visible: scriptionController.isHaveSubscriptions.value,
                                         
                                                  child: Column(
                                                    children: [
                                                       
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 8.w,
                                                                vertical: 4.h),
                                                        decoration: BoxDecoration(
                                                          color: price ==
                                                                  'مجاني'.tr
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      0.2)
                                                              : price ==
                                                                      'غير متوفر'
                                                                          .tr
                                                                  ? Colors.red
                                                                      .withOpacity(
                                                                          0.2)
                                                                  : price ==
                                                                          'باقة اقتصادية'
                                                                              .tr
                                                                      ? Colors
                                                                          .orange
                                                                          .withOpacity(
                                                                              0.2)
                                                                      : Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                              0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8.r),
                                                        ),
                                                        child: Text(
                                                          price,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppTextStyles
                                                                    .DinarOne,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: price ==
                                                                    'مجاني'.tr
                                                                ? Colors.green
                                                                : price ==
                                                                        'غير متوفر'
                                                                            .tr
                                                                    ? Colors.red
                                                                    : price ==
                                                                            'باقة اقتصادية'
                                                                                .tr
                                                                        ? Colors
                                                                            .orange
                                                                        : Colors
                                                                            .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                  PublisherInfoDialog(),
                  _BottomNavigationSection(),
                ]),
              ),
            ));
  }
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

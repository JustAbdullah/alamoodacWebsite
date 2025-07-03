import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:latlong2/latlong.dart'; // استخدم latlong2 للتعامل مع إحداثيات الخريطة.

import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../customWidgets/custom_container.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/userDahsboardController.dart';
import 'top_section_details_post_user_desktop.dart';

class PostDetailsEdit extends StatelessWidget {
  PostDetailsEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<Userdahsboardcontroller>(
        builder: (controller) => Visibility(
            visible: controller.showDetailsPost.value,
            child: SafeArea(
              child: controller.selectedPost.value == null
                  ? SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: AppColors.whiteColorTypeOne,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopSectionDetailsPostUserDeskTop(),
                            // عرض الصور
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200.h,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    itemCount: controller
                                        .selectedPost.value?.images
                                        .split(',')
                                        .length,
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: controller
                                            .selectedPost.value!.images
                                            .split(',')[index],
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) => SizedBox(
                                          child: ContainerCustom(
                                            colorContainer: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                            heigthContainer: 200,
                                            widthContainer:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            child: Text(
                                              "على مودك".tr,
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: 200.w,
                                            height: 70.h,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                                size: 30.sp,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onPageChanged: (index) {
                                      controller.currentPageIndex.value = index;
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        controller.selectedPost.value!.images
                                            .split(',')
                                            .length,
                                        (index) => Obx(() {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3.w),
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.currentPageIndex
                                                          .value ==
                                                      index
                                                  ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)
                                                  : Colors.grey,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // تفاصيل المنشور
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200.w,
                                        child: Text(
                                          controller.postTitle,
                                          style: TextStyle(
                                            fontSize: 19.sp,
                                            fontFamily: AppTextStyles.DinarOne,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            controller.selectedPost.value!
                                                    .views ??
                                                "0",
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors
                                                    .balckColorTypeThree,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Image.asset(
                                            ImagesPath.views,
                                            width: 18.h,
                                            height: 18.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Text(
                                        controller.categoryName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                        ),
                                      ),
                                      Text(
                                        "/",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                        ),
                                      ),
                                      Text(
                                        controller.subcategoryName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                        ),
                                      ),
                                      Text(
                                        "/",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                        ),
                                      ),
                                      Text(
                                        controller.subcategoryLevelTwoName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.balckColorTypeFour,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 170.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.balckColorTypeFour,
                                    ),
                                    child: Text(
                                      "التفاصيل العامة".tr,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 5.h),
                                    child: controller
                                            .selectedPost.value!.details
                                            .where((detail) =>
                                                detail.detailName !=
                                                "تفاصيل اضافية")
                                            .isEmpty
                                        ? Center(
                                            child: Text(
                                              "لا توجد تفاصيل متوفرة".tr,
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors
                                                    .balckColorTypeFour,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: controller
                                                .selectedPost.value!.details
                                                .where((detail) =>
                                                    detail.detailName !=
                                                    "تفاصيل اضافية")
                                                .map((detail) {
                                              final translatedDetail =
                                                  detail.translations.first;

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        translatedDetail
                                                            .translatedDetailName,
                                                        style: TextStyle(
                                                          fontSize: 17.sp,
                                                          fontFamily:
                                                              AppTextStyles
                                                                  .DinarOne,
                                                          color: AppColors
                                                              .balckColorTypeFour,
                                                        ),
                                                      ),
                                                      Text(
                                                        translatedDetail
                                                            .translatedDetailValue,
                                                        style: TextStyle(
                                                          fontSize: 17.sp,
                                                          fontFamily:
                                                              AppTextStyles
                                                                  .DinarOne,
                                                          color: AppColors
                                                              .balckColorTypeFour,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 0.2.h,
                                                    color: AppColors
                                                        .balckColorTypeFour,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 170.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.balckColorTypeFour,
                                    ),
                                    child: Text(
                                      "الموقع الجغرافي للمنشور".tr,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150.h,
                                    child: Stack(
                                      children: [
                                        FlutterMap(
                                          options: MapOptions(
                                            initialCenter: LatLng(
                                              double.tryParse(controller
                                                      .selectedPost
                                                      .value
                                                      ?.lat) ??
                                                  0.0,
                                              double.tryParse(controller
                                                      .selectedPost
                                                      .value
                                                      ?.lon) ??
                                                  0.0,
                                            ),
                                            initialZoom: 15.0,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // بدون النطاقات الفرعية
                                            ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: LatLng(
                                                    double.tryParse(controller
                                                            .selectedPost
                                                            .value
                                                            ?.lat) ??
                                                        0.0,
                                                    double.tryParse(controller
                                                            .selectedPost
                                                            .value
                                                            ?.lon) ??
                                                        0.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                    size: 60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 170.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.balckColorTypeFour,
                                    ),
                                    child: Text(
                                      "التفاصيل الإضافية".tr,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 5.h),
                                    child: controller
                                            .selectedPost.value!.details
                                            .where((detail) =>
                                                detail.detailName ==
                                                "تفاصيل اضافية")
                                            .isEmpty
                                        ? Center(
                                            child: Text(
                                              "لا توجد تفاصيل إضافية"
                                                  .tr, // يمكنك استخدام الترجمة إذا كنت تدعم اللغات
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors
                                                    .balckColorTypeFour,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: controller
                                                .selectedPost.value!.details
                                                .where((detail) =>
                                                    detail.detailName ==
                                                    "تفاصيل اضافية")
                                                .map((detail) {
                                              final translatedDetail =
                                                  detail.translations.first;

                                              return Column(
                                                children: [
                                                  Text(
                                                    translatedDetail
                                                        .translatedDetailValue,
                                                    style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontFamily: AppTextStyles
                                                          .DinarOne,
                                                      color: AppColors
                                                          .balckColorTypeFour,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                  SizedBox(height: 25.h),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 170.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.balckColorTypeFour,
                                    ),
                                    child: Text(
                                      "ناشر المنشور".tr,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.selectedPost.value!.user!
                                                  .name ??
                                              "غير متوفر",
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontFamily:
                                                  AppTextStyles.DinarOne,
                                              color:
                                                  AppColors.balckColorTypeFour,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              ImagesPath.whatsapp,
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                            Text(
                                              controller.selectedPost.value!
                                                      .user!.phone ??
                                                  "غير متوفر",
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors
                                                    .balckColorTypeFour,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )));
  }
}

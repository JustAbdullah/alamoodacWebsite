
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // استخدم latlong2 للتعامل مع إحداثيات الخريطة.

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

class ChoseLocation extends StatelessWidget {
  const ChoseLocation({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingController loadingController = Get.put(LoadingController());
    final ThemeController themeController = Get.find();

    return GetX<Settingscontroller>(
      builder: (controller) => Visibility(
        visible: controller.showLocation.value,
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.backgroundColor(themeController.isDarkMode.value),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
              child: Column(
                children: [
                  // العودة إلى الشاشة السابقة
                  InkWell(
                    onTap: () {
                      controller.showLocation.value = false;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          ImagesPath.back,
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "العودة".tr,
                          style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              color: AppColors.textColor(
                                  themeController.isDarkMode.value),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // العنوان
                  Text(
                    "الموقع الجغرافي".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "يتم أخذ موقعك الجغرافي تلقائيًا وبدقة عالية".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color:
                          AppColors.textColor(themeController.isDarkMode.value),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  // عرض الخريطة أو رسالة النص
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350.h,
                    child: (controller.latitude.value != null &&
                            controller.longitude.value != null)
                        ? FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                controller.latitude.value!,
                                controller.longitude.value!,
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
                                      controller.latitude.value!,
                                      controller.longitude.value!,
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : (loadingController.currentUser?.latitude != null &&
                                loadingController.currentUser!.latitude !=
                                    0.0 &&
                                loadingController.currentUser?.longitude !=
                                    null &&
                                loadingController.currentUser!.longitude != 0.0)
                            ? FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    loadingController.currentUser!.latitude!,
                                    loadingController.currentUser!.longitude!,
                                  ),
                                  initialZoom: 15.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    subdomains: ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(
                                          loadingController
                                              .currentUser!.latitude!,
                                          loadingController
                                              .currentUser!.longitude!,
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  "لم يتم إدخال الموقع الجغرافي بعد".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textColor(
                                        themeController.isDarkMode.value),
                                  ),
                                ),
                              ),
                  ),

                  SizedBox(height: 20.h),
                  // زر أخذ الموقع الجغرافي
                  Obx(() {
                    return controller.isLoadingLocation.value
                        ? CircularProgressIndicator(
                            color: AppColors.TheMain,
                            backgroundColor: AppColors.textColor(
                                themeController.isDarkMode.value),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await controller.ensureLocationPermission();
                              if (await controller.isLocationServiceEnabled()) {
                                await controller.fetchCurrentLocation();
                              } else {
                                Get.snackbar(
                                  "خطأ".tr,
                                  "يرجى تفعيل خدمة الموقع الجغرافي".tr,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.balckColorTypeFour,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 15.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "أخذ الموقع الجغرافي".tr,
                              style: TextStyle(
                                fontFamily: AppTextStyles.DinarOne,
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/searchController.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/localization/changelanguage.dart';
import '../../controllers/LoadingController.dart';
import '../../controllers/settingsController.dart';


class MapSearchDesktop extends StatefulWidget {
  const MapSearchDesktop({Key? key}) : super(key: key);

  @override
  State<MapSearchDesktop> createState() => _MapSearchDesktopState();
}

class _MapSearchDesktopState extends State<MapSearchDesktop> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // الحصول على المتحكمات المطلوبة من GetX
    LoadingController loadingController = Get.put(LoadingController());
    final ThemeController themeController = Get.find();
    Settingscontroller settingscontroller = Get.put(Settingscontroller());
    Searchcontroller searchcontroller = Get.put(Searchcontroller());
    return GetX<Searchcontroller>(
      builder: (controller) {
        // تحديد مركز الخريطة بناءً على الموقع المُحدث:
        LatLng center;
        if (settingscontroller.latitude.value != null &&
            settingscontroller.longitude.value != null) {
          center = LatLng(
            settingscontroller.latitude.value ?? 0.0,
            settingscontroller.longitude.value ?? 0.0,
          );
        } else if (loadingController.currentUser?.latitude != null &&
            loadingController.currentUser?.latitude != 0.0 &&
            loadingController.currentUser?.longitude != null &&
            loadingController.currentUser?.longitude != 0.0) {
          center = LatLng(
            loadingController.currentUser?.latitude ?? 0.0,
            loadingController.currentUser?.longitude ?? 0.0,
          );
        } else {
          // موقع افتراضي (مثلاً موقع العراق)
          center = const LatLng(33.3128, 44.3615);
        }

        // تحديث مركز الخريطة بعد رسم الواجهة
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              _mapController.move(center, 15.0);
            }
          });
        });

        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    // إضافة Marker بحسب توفر بيانات الموقع
                    if (settingscontroller.latitude.value != null &&
                        settingscontroller.longitude.value != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 30,
                            height: 30,
                            point: LatLng(
                              settingscontroller.latitude.value ?? 0.0,
                              settingscontroller.longitude.value ?? 0.0,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      )
                    else if (loadingController.currentUser?.latitude !=
                            null &&
                        loadingController.currentUser?.latitude != 0.0 &&
                        loadingController.currentUser?.longitude != null &&
                        loadingController.currentUser?.longitude != 0.0)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 30,
                            height: 30,
                            point: LatLng(
                              loadingController.currentUser?.latitude ?? 0.0,
                              loadingController.currentUser?.longitude ?? 0.0,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
              // زر إغلاق الخريطة في أعلى الواجهة
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  width: 60.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 30),
                    onPressed: () {
                     Get.back();
                    },
                  ),
                ),
              ),
              // أزرار اتخاذ الموقع والبحث
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return settingscontroller.isLoadingLocation.value
                              ? CircularProgressIndicator(
                                  color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                  backgroundColor: AppColors.textColor(
                                      themeController.isDarkMode.value),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await settingscontroller
                                        .ensureLocationPermission();
                                    if (await settingscontroller
                                        .isLocationServiceEnabled()) {
                                      await settingscontroller
                                          .fetchMapSearching();
                                    } else {
                                      Get.snackbar(
                                        "خطأ".tr,
                                        "يرجى تفعيل خدمة الموقع الجغرافي".tr,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.balckColorTypeFour,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on_sharp,
                                          color: Colors.white, size: 24),
                                      const SizedBox(width: 10),
                                      Text(
                                        "أخذ موقعك".tr,
                                        style:  TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                        ElevatedButton(
                          onPressed: () async {
                            // التحقق مما إذا لم يتم أخذ الموقع بشكل مباشر
                            bool directLocationNotAvailable =
                                settingscontroller.latitude.value == null ||
                                    settingscontroller.longitude.value ==
                                        null;
                            // التحقق مما إذا لم يتوفر الموقع في قاعدة البيانات
                            bool dbLocationNotAvailable = loadingController
                                        .currentUser ==
                                    null ||
                                loadingController.currentUser?.latitude ==
                                    null ||
                                loadingController.currentUser?.latitude ==
                                    0.0 ||
                                loadingController.currentUser?.longitude ==
                                    null ||
                                loadingController.currentUser?.longitude ==
                                    0.0;
        
                            // إذا لم يتوفر أي من الموقعين (المباشر والقاعدة) نعرض رسالة الخطأ
                            if (directLocationNotAvailable &&
                                dbLocationNotAvailable) {
                              Get.snackbar(
                                "خطأ".tr,
                                "لايمكنك البحـث! قم بفحص موقعك للحصول على المنشورات القريبة"
                                    .tr,
                                backgroundColor: Colors.red,
                              );
                            } else {
                              // في حال توفر الموقع المباشر، يتم استخدامه لجلب المنشورات
                              if (!directLocationNotAvailable) {
                                await controller.fetchNearbyPosts(
                                  latitude:
                                      settingscontroller.latitude.value ??
                                          0.0,
                                  longitude:
                                      settingscontroller.longitude.value ??
                                          0.0,
                                  language:
                                      Get.find<ChangeLanguageController>()
                                          .currentLocale
                                          .value
                                          .languageCode,
                                  context: context,
                                );
                              } else {
                                // وإلا، إذا كان الموقع محفوظًا في قاعدة البيانات يتم استخدامه لجلب المنشورات
                                await controller.fetchNearbyPosts(
                                  latitude: loadingController
                                          .currentUser!.latitude ??
                                      0.0,
                                  longitude: loadingController
                                          .currentUser!.longitude ??
                                      0.0,
                                  language:
                                      Get.find<ChangeLanguageController>()
                                          .currentLocale
                                          .value
                                          .languageCode,
                                  context: context,
                                );
                              }
                            }
                          },
                          child: Text(
                            "بحث قريب".tr,
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

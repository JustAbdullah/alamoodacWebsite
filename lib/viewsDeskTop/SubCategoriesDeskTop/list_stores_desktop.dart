import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../customWidgets/custom_container.dart';
import '../../core/data/model/Stores.dart';

class ListStoresDesktop extends StatelessWidget {
  ListStoresDesktop({super.key});
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        if (controller.isLoadingApprovedStores.value) {
          return ListView.builder(
            scrollDirection: Axis.vertical,

            shrinkWrap: true, // لضبط حجم الـ GridView بناءً على المحتوى
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Skeletonizer(
                child: ListTile(
                  title: Container(
                    width: 200,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                  subtitle: Container(
                    width: 150,
                    height: 15,
                    color: Colors.grey[300],
                  ),
                ),
              );
            },
          );
        } else if (controller.approvedStoresList.isEmpty) {
          return Center(
            child: Text(
              "لايوجــد متاجر ..",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.redColor,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true, // لضبط حجم الـ GridView بناءً على المحتوى
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: controller.approvedStoresList.length,
            itemBuilder: (context, index) {
              Stores store = controller.approvedStoresList[index];
              List<String> images = store.image.split(',');

              // استخدام المتغير `RxInt` الخاص بكل منشور من `controller.postPageIndexes`
              RxInt currentPagePost = controller.storesPageIndexes[index];
              PageController pageController = PageController();

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 17.w),
                child: GestureDetector(
                  onTap: () {
                    //   controller.setSelectedStores(store);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // لون الظل
                          blurRadius: 8, // درجة التمويه (الانتشار)
                          offset: Offset(4,
                              0), // إزاحة الظل لليمين فقط (يمين 4، لا شيء للأسفل)
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 100.h,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: pageController,
                                    itemCount: images.length,
                                    onPageChanged: (index) {
                                      currentPagePost.value = index;
                                    },
                                    itemBuilder: (context, pageIndex) {
                                      return CachedNetworkImage(
                                        imageUrl: images[pageIndex],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit
                                            .cover, // ملائمة الصورة لتغطية الحاوية بشكل كامل
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width, // عرض الكونتير
                                            height: 100.h, // ارتفاع الكونتير
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit
                                                    .cover, // ملائمة الصورة لتغطية الحاوية
                                              ),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) => SizedBox(
                                          child: ContainerCustom(
                                            colorContainer: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                            heigthContainer: 30.h,
                                            widthContainer: 30.w,
                                            child: Text(
                                              "على مودك".tr,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          // عرض شيء مخصص في حال كان الرابط خاطئًا أو لم تظهر الصورة
                                          return Container(
                                            width: 200.w,
                                            height: 70.h,
                                            color: Colors.grey[
                                                300], // يمكنك تخصيص اللون الخلفي عند حدوث خطأ
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .broken_image, // أيقونة خطأ الصورة
                                                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                                size:
                                                    30.sp, // تخصيص حجم الأيقونة
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 5.h, // المسافة من أسفل الصورة
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        images.length,
                                        (index) => Obx(() {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3.w),
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  currentPagePost.value == index
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
                            SizedBox(
                              height: 3.h,
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                store.translations.first.name.toString(),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: AppTextStyles.DinarOne,
                                  color: AppColors.balckColorTypeFour,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // عرض قيمة السعر
                            SizedBox(
                              width: 150.w,
                              child: Row(
                                children: [
                                  Text(
                                    store.translations.first.description
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppTextStyles.DinarOne,
                                      color: AppColors.balckColorTypeFour,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            bottom: 20.h, // المسافة من أسفل الصورة

                            left: 10.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.views.toString(), // عرض السعر
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: AppTextStyles.DinarOne,
                                    color: AppColors.balckColorTypeFour,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Image.asset(
                                  ImagesPath.views,
                                  width: 18.h,
                                  height: 18.h,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

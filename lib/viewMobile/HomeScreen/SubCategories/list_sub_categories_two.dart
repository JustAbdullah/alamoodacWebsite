import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/data/model/subcategory_level_two.dart';

class ListSubCategoriesTwo extends StatelessWidget {
  ListSubCategoriesTwo({super.key});
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        builder: (controller) => Container(
            width: MediaQuery.of(context).size.width,
            height: 35.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          controller.numberOfSubTwo.value = 0;
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: controller.numberOfSubTwo.value == 0
                                  ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                "الكل".tr,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: AppTextStyles.DinarOne,
                                    color: controller.numberOfSubTwo.value == 0
                                        ? AppColors.whiteColor
                                        : AppColors.blackColorTypeTeo),
                              ),
                            ))),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 35.h,
                      child: Obx(() {
                        if (controller.isLoadingSubcategoryLevelTwo.value) {
                          return ListView.builder(
                            itemCount: 5,
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
                        } else if (controller.subcategoriesLevelTwo.isEmpty) {
                          return Center(child: Text('No sub found'));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.subcategoriesLevelTwo.length,
                            itemBuilder: (context, index) {
                              SubcategoryLevelTwo sub =
                                  controller.subcategoriesLevelTwo[index];

                              return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: GestureDetector(
                                      onTap: () {
                                        controller.numberOfSubTwo.value =
                                            sub.id;
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller
                                                        .numberOfSubTwo.value ==
                                                    sub.id
                                                ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)
                                                : AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Text(
                                              sub.translations.first.name,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontFamily:
                                                    AppTextStyles.DinarOne,
                                                color: controller.numberOfSubTwo
                                                            .value ==
                                                        sub.id
                                                    ? AppColors.whiteColor
                                                    : AppColors
                                                        .blackColorTypeTeo,
                                              ),
                                            ),
                                          ))));
                            },
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            )));
  }
}

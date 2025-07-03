import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';

class RatePostSheet {
  static void show(BuildContext context, int postId, double initialRating) {
    final HomeController controller = Get.put(HomeController());
    double currentRating = initialRating;
    final ThemeController themeController = Get.find();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الصف العلوي يحتوي على زر الإغلاق وشريط السحب
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor(
                            themeController.isDarkMode.value),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          size: 24, color: AppColors.redColor),
                      onPressed: () => Get.back(), // إغلاق النافذة عند الضغط
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // عنوان التقييم
                Text(
                  "قيّم هذا المنشور ⭐".tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),

                // تقييم النجوم
                RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: AppColors.yellowColor,
                  ),
                  onRatingUpdate: (rating) {
                    currentRating = rating;
                  },
                ),
                SizedBox(height: 20),

                // زر الإرسال
                Obx(() => GestureDetector(
                      onTap: controller.isSubmitting.value
                          ? null
                          : () {
                              controller.ratePost(
                                  postId, currentRating, context);
                              Get.back(); // إغلاق الـ Bottom Sheet بعد الإرسال
                            },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        decoration: BoxDecoration(
                          color: controller.isSubmitting.value
                              ? Colors.grey
                              : AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: controller.isSubmitting.value
                            ? CircularProgressIndicator(color: Colors.red)
                            : Text(
                                "إرسال التقييم".tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: AppTextStyles.DinarOne,
                                  color: AppColors.textColor(
                                      themeController.isDarkMode.value),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

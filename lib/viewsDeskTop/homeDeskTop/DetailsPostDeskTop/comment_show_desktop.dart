import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';

class CommentShowDesktop extends StatelessWidget {
  const CommentShowDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    HomeController controller = Get.put(HomeController());
    return Obx(() {
      if (controller.isLoadingComments.value) {
        return ListView.builder(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // يمنع التمرير أثناء تحميل البيانات
          itemCount: 5, // عدد العناصر الوهمية أثناء التحميل
          itemBuilder: (context, index) {
            return Skeletonizer(
              child: ListTile(
                title: Container(
                  width: double.infinity,
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
      } else if (controller.commentsList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Text(
              "ليس هنالك تعليقات..ابدا التعليق الان".tr,
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.commentsList.length,
        physics:
            NeverScrollableScrollPhysics(), // منع التمرير أثناء عرض التعليقات
        itemBuilder: (context, index) {
          final comment = controller.commentsList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
              child: Text(
                comment.userName != null
                    ? comment.userName![0] // أول حرف من اسم المستخدم
                    : 'م', // إذا لم يكن هناك اسم، عرض حرف افتراضي
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            title: Text(
              comment.userName ??
                  'مجهول', // في حالة عدم وجود userName يتم عرض "مجهول"
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
                color: AppColors.textColor(themeController.isDarkMode.value),
              ),
            ),
            subtitle: Text(comment.commentText,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontSize: 15.sp)),
          );
        },
      );
    });
  }
}

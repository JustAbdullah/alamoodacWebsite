
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/localization/changelanguage.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

class TopSectionDetailsPostUser extends StatelessWidget {
  TopSectionDetailsPostUser({super.key});

  final userDash = Get.find<Userdahsboardcontroller>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70.h,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      userDash.currentPageIndex.value = 0;
                      userDash.showDetailsPost.value = false;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          ImagesPath.back,
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "العودة".tr,
                          // ignore: deprecated_member_use
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            color: AppColors.balckColorTypeFour,
                            fontSize: 20.sp,
                          ),

                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.w,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImagesPath.logo,
                  width: 80.w,
                  height: 30.h,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  Get.find<ChangeLanguageController>()
                      .currentLocale
                      .value
                      .languageCode,

                  // ignore: deprecated_member_use
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: AppColors.balckColorTypeFour,
                    fontSize: 16.sp,
                  ),

                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:alamoadac_website/viewsDeskTop/AddPageDeskTop/add_list_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/app_text_styles.dart';

class CallToActionBannerDesktop extends StatelessWidget {
  const CallToActionBannerDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 105.w, vertical: 20.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [
              AppColors.TheMain.withOpacity(0.9),
              AppColors.TheMainLight.withOpacity(0.7),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.TheMain.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // يسار: استعراض الباقات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "هل ترغب بزيادة ظهور منشورك؟",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                  SizedBox(height: 10.h),
               
                ],
              ),
            ),
            SizedBox(width: 40.w),
            // يمين: إنشاء إعلان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "ابدأ عملية التمويل  الآن!",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                Get.to(AddListDeskTop());
                    },
                    child: Text(
                      "البدء الان ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

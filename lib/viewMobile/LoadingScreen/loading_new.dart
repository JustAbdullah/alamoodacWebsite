import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/LoadingController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/images_path.dart';

class LoadingNew extends StatelessWidget {
  const LoadingNew({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingController loading = Get.put(LoadingController());

    loading.onInit();
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 31, 30, 30),
      backgroundColor: const Color.fromARGB(255, 1, 11, 45),

      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70.h),
          // الشعار
          Image.asset(
            ImagesPath.logoText,
            width: MediaQuery.of(context).size.width,
            height: 40.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20.h),
          Lottie.asset(ImagesPath.loading, width: 100.w, height: 40.h),
          SizedBox(height: 0.h),
          Text(
            "الرجاء الإنتظار قليلاً".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: const Color.fromARGB(255, 250, 167, 58),
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}

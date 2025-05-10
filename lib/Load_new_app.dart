// Load_new_app.dart

import 'dart:async';
import 'package:alamoadac_website/core/constant/images_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';
import 'controllers/searchController.dart';
import 'core/constant/app_text_styles.dart';
import 'core/constant/appcolors.dart';

class LoadTheWeb extends StatefulWidget {
  const LoadTheWeb({Key? key}) : super(key: key);

  @override
  State<LoadTheWeb> createState() => _LoadTheWebState();
}

class _LoadTheWebState extends State<LoadTheWeb> {
  @override
  void initState() {
    super.initState();

    // 1) جلب البيانات مرة واحدة
    Get.find<HomeController>().initializeData();
    Get.find<Searchcontroller>().onInit();

    // 2) بعد 10 ثوانٍ انتقل لأي حال
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed('/Decider');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(ImagesPath.logo),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              backgroundColor: AppColors.oragne,
              color: AppColors.balckColorTypeFour,
            ),
            const SizedBox(height: 20),
            Text(
              'جاري التحميل، يرجى الانتظار...',
              style: TextStyle(
                color: AppColors.blackColorTypeTeo,
                fontSize: 15,
                fontFamily: AppTextStyles.DinarOne,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

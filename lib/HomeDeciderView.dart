import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/LoadingController.dart';
import '../viewsDeskTop/homeDeskTop/home_screen_desktop.dart';

class HomeDeciderView extends StatelessWidget {
  const HomeDeciderView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCtrl = Get.find<HomeController>();
    final loadingCtrl = Get.find<LoadingController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // يتم تحديث القيم في كل إعادة بناء
        HomeCtrl.isDesktop.value = width >= 1024;
        HomeCtrl.isTablet.value = width >= 600 && width < 1024;
        HomeCtrl.isMobile.value = width < 600;

        return Obx(() {
          if (HomeCtrl.isDesktop.value || HomeCtrl.isTablet.value) {
            return const ScreenUtilInit(
              designSize: const Size(1440, 900),
              child: const HomeScreenDesktop(),
            );
          } else {
            loadingCtrl.isMobile.value = true;
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              child: const HomeScreen(),
            );
          }
        });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/LoadingController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final List<String> images = [
    ImagesPath.allProductOne,
    ImagesPath.allProductOne,
    ImagesPath.allProductOne,
  ];
  final List<String> title = [
    "كل ما تحتاجه في مكان واحد!".tr,
    "التقط، شارك، وحقق التفاعل!".tr,
    "منشوراتك تثير الاهتمام!".tr,
  ];
  final List<String> texts = [
    "استعرض أقسام متنوعة في تطبيقنا. خدمات، منتجات، وعروض خاصة. كل ما تحتاجه في مكان واحد."
        .tr,
    "التقط صورة، أضف التفاصيل، وانشرها بسهولة. مع أدوات تخصيص تمنحك أفضل طريقة لعرض منشورك."
        .tr,
    "منشوراتك ستصل لأكبر عدد من الناس بسرعة، مع تفاعل متزايد ومشاهدات عالية في الوقت الفعلي."
        .tr,
  ];

  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    startImageSlider();
  }

  void startImageSlider() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % images.length;
        });
        _pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        );
        startImageSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LoadingController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.blueLight),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ALAMODAC",
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: const Color.fromARGB(255, 182, 34, 34),
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.2.w),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 260.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      physics: BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.9,
                              end: 1.0,
                            ).animate(animation),
                            child: FadeInUp(child: child),
                          ),
                          child: ClipRRect(
                            key: ValueKey(images[index]),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              images[index],
                              width: MediaQuery.of(context).size.width,
                              height: 260.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 45.h),
                FadeIn(
                  key: ValueKey(title[currentIndex]),
                  duration: Duration(seconds: 2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      title[currentIndex],
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: const Color.fromARGB(255, 247, 198, 0),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                FadeIn(
                  key: ValueKey(texts[currentIndex]),
                  duration: Duration(seconds: 2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      texts[currentIndex],
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: AppColors.whiteColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black45,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
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
            ),
          ),
        ),
      ),
    );
  }
}

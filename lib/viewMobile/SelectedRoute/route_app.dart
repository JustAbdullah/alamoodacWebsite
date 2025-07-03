import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/localization/changelanguage.dart';

class RouteTheApp extends StatelessWidget {
  const RouteTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.blueLight,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft, child: _AnimatedImageSide()),
              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: _MainTitle(),
              ),
              _StepsContent(controller: homeController),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedImageSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(-200 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Image.asset(
        width: 170.w,
        ImagesPath.langTrak,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _StepsContent extends StatelessWidget {
  final HomeController controller;
  const _StepsContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          _StepIndicator(controller: controller),
          Expanded(
            child: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.5, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                  child: controller.currentStep == 1
                      ? _CountrySelection(controller: controller)
                      : _LanguageSelection(controller: controller),
                )),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final HomeController controller;
  const _StepIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StepDot(isActive: controller.currentStep == 1),
            SizedBox(width: 10.w),
            _StepDot(isActive: controller.currentStep == 2),
          ],
        ));
  }
}

class _MainTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h, right: 20.w),
            child: Text(
              "صفحة التخصيص".tr,
              style: TextStyle(
                fontSize: 28.sp,
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.yellowColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;
  const _StepDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.whiteColor : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CountrySelection extends StatelessWidget {
  final HomeController controller;
  const _CountrySelection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10.w), // تحريك النص لليسار بمقدار محدد
          alignment: Alignment.centerRight,
          child: _AnimatedTitle("اختر الدولة".tr),
        ),
        Container(
            width: 200.w,
            margin:
                EdgeInsets.only(left: 120.w), // تحريك النص لليسار بمقدار محدد
            alignment: Alignment.centerRight,
            child: _AnimatedDesc("قم بإختيار الدولة المخصصة لك".tr)),
        SizedBox(height: 20.h),
        Obx(() => Container(
              width: 200.w,
              margin:
                  EdgeInsets.only(left: 120.w), // تحريك النص لليسار بمقدار محدد
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 10.w,
                runSpacing: 20.h,
                children: [
                  _OptionCard(
                      title: "العراق".tr,
                      isSelected: controller.selectedCountry == "العراق",
                      onTap: () {
                        controller.selectCountry("العراق");
                        controller.saveSelectedRoute('العراق');
                      }),
                  _OptionCard(
                      title: "سوريا".tr,
                      isSelected: controller.selectedCountry == "سوريا",
                      onTap: () {
                        controller.selectCountry("سوريا");
                        controller.saveSelectedRoute('سوريا');
                      }),
                  _OptionCard(
                      title: "تركيا".tr,
                      isSelected: controller.selectedCountry == "تركيا",
                      onTap: () {
                        controller.selectCountry("تركيا");
                        controller.saveSelectedRoute('تركيا');
                      }),
                ],
              ),
            )),
        SizedBox(height: 40.h),
        Container(
            width: 200.w,
            margin:
                EdgeInsets.only(left: 120.w), // تحريك النص لليسار بمقدار محدد
            alignment: Alignment.centerRight,
            child: _ContinueButton(controller: controller)),
      ],
    );
  }
}

class _LanguageSelection extends StatelessWidget {
  final HomeController controller;
  const _LanguageSelection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10.w), // تحريك النص لليسار بمقدار محدد
          alignment: Alignment.centerRight,
          child: _AnimatedTitle("اختر اللغة".tr),
        ),
        Container(
            width: 200.w,
            margin:
                EdgeInsets.only(left: 120.w), // تحريك النص لليسار بمقدار محدد
            alignment: Alignment.centerRight,
            child: _AnimatedDesc("قم بإختيار اللغة المخصصة لك".tr)),
        SizedBox(height: 20.h),
        Obx(
          () => Container(
              width: 200.w,
              margin:
                  EdgeInsets.only(left: 150.w), // تحريك النص لليسار بمقدار محدد
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 10.w,
                runSpacing: 20.h,
                children: [
                  _OptionCard(
                      title: "العربية".tr,
                      isSelected: controller.selectedLang == "العربية",
                      onTap: () {
                        controller.selectLanguage("العربية");
                        Get.find<ChangeLanguageController>()
                            .changeLanguage('ar');
                      }),
                  _OptionCard(
                      title: "التركية".tr,
                      isSelected: controller.selectedLang == "التركية",
                      onTap: () {
                        controller.selectCountry("التركية");
                        controller.selectLanguage("التركية");
                        Get.find<ChangeLanguageController>()
                            .changeLanguage('tr');
                      }),
                  _OptionCard(
                      title: "الكردية".tr,
                      isSelected: controller.selectedLang == "الكردية",
                      onTap: () {
                        controller.selectLanguage("الكردية");

                        Get.find<ChangeLanguageController>()
                            .changeLanguage('ku');
                      }),
                  _OptionCard(
                      title: "الانجليزية".tr,
                      isSelected: controller.selectedLang == "الانجليزية",
                      onTap: () {
                        controller.selectLanguage("الانجليزية");
                        Get.find<ChangeLanguageController>()
                            .changeLanguage('en');
                      }),
                ],
              )),
        ),
        SizedBox(height: 40.h),
        Container(
          width: 200.w,
          margin: EdgeInsets.only(left: 120.w), // تحريك النص لليسار بمقدار محدد
          alignment: Alignment.centerRight,
          child: _ContinueButton(controller: controller),
        )
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final HomeController controller;
  const _ContinueButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.scale(scale: value, child: child),
      ),
      child: Obx(() => ElevatedButton(
            onPressed: controller.selectedLang.isNotEmpty
                ? () {
                    controller.isGetDataFirstTime.value = false;
                    controller.onInit();
                    controller.goToNextStep();
                  }
                : null,
            child: Text(
              controller.selectedCountry.isEmpty
                  ? "1/2"
                  : controller.selectedLang.isNotEmpty
                      ? "التاكيد".tr
                      : "2/2".tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.balckColorTypeThree,
                fontFamily: AppTextStyles.DinarOne,
              ),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: AppColors.yellowColor,
              foregroundColor: Colors.white,
            ),
          )),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _OptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.whiteColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.whiteColor,
            width: isSelected ? 0 : 1,
          ),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black26, blurRadius: 10)]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: isSelected ? AppColors.blueDark : AppColors.whiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final String text;
  const _AnimatedTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Text(
        text.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.whiteColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AnimatedDesc extends StatelessWidget {
  final String text;
  const _AnimatedDesc(this.text);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Text(
        text.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.whiteColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/*
  _OptionCard(
                    title: "العراق".tr,
                    isSelected: controller.selectedCountry == "العراق",
                    onTap: () => controller.saveSelectedRoute('العراق'),
                  ),
                  _OptionCard(
                    title: "سوريا".tr,
                    isSelected: controller.selectedCountry == "سوريا",
                    onTap: () => controller.saveSelectedRoute('سوريا'),
                  ),
                  _OptionCard(
                    title: "تركيا".tr,
                    isSelected: controller.selectedCountry == "تركيا",
                    onTap: () => controller.saveSelectedRoute('تركيا'),
                  ),*/
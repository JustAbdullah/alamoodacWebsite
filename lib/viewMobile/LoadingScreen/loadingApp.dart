import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/images_path.dart';
import '../../core/localization/changelanguage.dart';

class LoadingApp extends StatefulWidget {
  const LoadingApp({super.key});

  @override
  _LoadingAppState createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  late AnimationController _controller;
  late Animation<int> _languageIndex;

  final List<String> languages = [
    'الرجاء إختيار اللغة',
    'تکایە زمانێک هەڵبژێرە',
    'Please select a language',
    // الكوردية الكرمانجية
  ];
  final List<String> languageNames = [
    'العربية',
    'Kurdî', // الكردي الكرمانجي
    'English',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 7), // مدة الانتقال بين اللغات
      vsync: this,
    )..repeat(); // لا تكرار الحركة في الاتجاه العكسي

    _languageIndex = IntTween(begin: 0, end: 2).animate(_controller);

    // حركة التلاشي السلسة
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 31, 30, 30),
      backgroundColor: const Color.fromARGB(255, 1, 11, 45),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80.h),
            // الشعار
            Image.asset(
              ImagesPath.logoText,
              width: MediaQuery.of(context).size.width,
              height: 40.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 50.h),

            // نص اختيار اللغة مع التلاشي
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  languages[_languageIndex.value],
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            SizedBox(height: 40.h),

            // أعلام اللغات
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  languageItem(
                    ImagesPath.flagArLe,
                    'العربية',
                    () {
                      controller.selectCountry("العراق");
                      controller.saveSelectedRoute('العراق');
                      controller.selectLanguage("العربية");
                      Get.find<ChangeLanguageController>().changeLanguage('ar');
                      controller.isGetDataFirstTime.value = false;
                      setState(() {});
                      Get.to(() => HomeScreen());
                    },
                  ),
                  languageItem(
                    ImagesPath.flagKuLe,
                    'Kurdî',
                    () {
                      controller.selectCountry("العراق");
                      controller.saveSelectedRoute('العراق');
                      controller.selectLanguage("الكردية");

                      Get.find<ChangeLanguageController>().changeLanguage('ku');
                      controller.isGetDataFirstTime.value = false;
                      setState(() {});
                      Get.to(() => HomeScreen());
                    },
                  ), //
                  languageItem(
                    ImagesPath.flagEnLe,
                    'English',
                    () {
                      controller.selectCountry("العراق");
                      controller.saveSelectedRoute('العراق');
                      controller.selectLanguage("الانجليزية");

                      Get.find<ChangeLanguageController>().changeLanguage('en');
                      controller.isGetDataFirstTime.value = false;
                      setState(() {});
                      Get.to(() => HomeScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget languageItem(
      String flagPath, String languageName, void Function()? onTap) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  flagPath,
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              languageName,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ));
  }
}

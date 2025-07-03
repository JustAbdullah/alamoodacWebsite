import 'dart:async';
import 'package:alamoadac_website/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/home_controller.dart';

class DetailsLoadLink extends StatefulWidget {
  const DetailsLoadLink({Key? key}) : super(key: key);

  @override
  _DetailsLoadLinkState createState() => _DetailsLoadLinkState();
}

class _DetailsLoadLinkState extends State<DetailsLoadLink> {
  String? postId;
  bool _timedOut = false;
  Timer? _timeoutTimer;
  // تسجيل وقت بدء عرض الصفحة
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // بعد اكتمال بناء الواجهة نبدأ عملية تحميل البيانات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  /// دالة تنتظر مرور 5 ثوانٍ على الأقل قبل الانتقال
  void _navigateAfterDelay(Function navigationCallback) {
    const minimumDelay = Duration(seconds: 3);
    final elapsed = DateTime.now().difference(_startTime);
    final remainingDelay = minimumDelay - elapsed;
    if (remainingDelay <= Duration.zero) {
      navigationCallback();
    } else {
      Future.delayed(remainingDelay, () {
        navigationCallback();
      });
    }
  }

  void _initializeData() {
    // قراءة حجم الشاشة لتحديد نوع الجهاز
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;

    // جلب معرف المنشور من المعاملات
    postId = Get.parameters['id'] ??
        (Get.arguments is Map ? Get.arguments['id']?.toString() : null);
    if (postId != null) {
      final controller = Get.find<HomeController>();
      controller.isGoFromLink.value = 1;
      // بدء تايمر لمدة 45 ثانية للتأكد من تحميل البيانات
      _timeoutTimer = Timer(const Duration(seconds: 20), () {
        if (controller.selectedPost.value == null) {
          setState(() {
            _timedOut = true;
          });
        }
      });

      // إذا لم يكن المنشور الحالي هو المطلوب، نجلب البيانات
      if (controller.selectedPost.value?.id.toString() != postId) {
        controller.fetchPostDetails(int.parse(postId!)).whenComplete(() {
          _timeoutTimer?.cancel();
          if (controller.selectedPost.value != null) {
            _navigateAfterDelay(() {
              if (isDesktop) {
                Get.offNamed('/post/$postId',
                    arguments: controller.selectedPost.value);
              } else {
                Get.offNamed('/post-mobile/$postId',
                    arguments: controller.selectedPost.value);
              }
            });
          } else {
            setState(() {
              _timedOut = true;
            });
          }
        });
      } else {
        _navigateAfterDelay(() {
          if (isDesktop) {
            Get.offNamed('/post/$postId',
                arguments: controller.selectedPost.value);
          } else {
            Get.offNamed('/post-mobile/$postId',
                arguments: controller.selectedPost.value);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام LayoutBuilder للحصول على القيود وتحديد designSize وفقًا للجهاز
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0) return const SizedBox();
        final width = constraints.maxWidth;
        final Size designSize =
            width >= 1024 ? const Size(1440, 900) : const Size(375, 812);
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: width < 1024,
          builder: (context, child) {
            return Scaffold(
              // خلفية شفافة مع AppBar بسيط
              backgroundColor: Colors.transparent,

              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.TheMain, AppColors.TheMainLightUse],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: _timedOut
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 80.sp, color: Colors.white),
                            SizedBox(height: 20.h),
                            Text(
                              "فشل تحميل المنشور.\nربما لم يعد موجوداً.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            ElevatedButton(
                              onPressed: () => Get.offNamed('/Decider'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.w, vertical: 15.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "عودة للصفحة الرئيسية",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              "يرجى الانتظار...\nجاري تحميل المنشور",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/ThemeController.dart';
import '../core/constant/appcolors.dart';

class ImagesViewerWidth extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImagesViewerWidth({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<ImagesViewerWidth> createState() => _ImagesViewerWidthState();
}

class _ImagesViewerWidthState extends State<ImagesViewerWidth> {
  late final PageController _pageController;
  int _currentIndex = 0;
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    // Preload images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var url in widget.images) {
        precacheImage(CachedNetworkImageProvider(url), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            // صورة بعرض الشاشة، بدون اقتصاص أو تمديد
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (idx) => setState(() => _currentIndex = idx),
              itemBuilder: (_, idx) {
                return Container(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  color: Colors.grey.withOpacity(0.1), // خلفية رمادية شفافة
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: widget.images[idx],
                    fit: BoxFit.cover, // يحافظ على الأبعاد الأصلية
                    placeholder: (_, __) =>
                        Icon(Icons.image, size: 40.sp, color: Colors.grey),
                    errorWidget: (_, __, ___) => Icon(Icons.broken_image,
                        size: 40.sp, color: Colors.red),
                  ),
                );
              },
            ),

            // المؤشر
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.images.length,
                  effect: ScrollingDotsEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    spacing: 6,
                    activeDotColor: AppColors.backgroundColorIconBack(
                        themeController.isDarkMode.value), // لون النقطة النشطة
                    dotColor:
                        Colors.grey.withOpacity(0.6), // لون النقاط غير النشط
                  ),
                ),
              ),
            ),

            // أزرار التبديل
            Positioned(
              top: constraints.maxHeight / 2 - 24.h,
              left: 8.w,
              child: _navButton(Icons.chevron_left, () => _navigate(-1)),
            ),
            Positioned(
              top: constraints.maxHeight / 2 - 24.h,
              right: 8.w,
              child: _navButton(Icons.chevron_right, () => _navigate(1)),
            ),
          ],
        );
      },
    );
  }

  void _navigate(int delta) {
    final newIndex =
        (_currentIndex + delta + widget.images.length) % widget.images.length;
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(icon, size: 32.sp, color: Colors.white)),
      ),
    );
  }
}

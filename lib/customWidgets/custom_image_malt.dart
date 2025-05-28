import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/ThemeController.dart';
import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';

class ImagesViewer extends StatefulWidget {
  final List<String> images;
  final bool fullWidth;
  final double minHeight;
  final double maxHeight;
  final bool enableZoom;

  const ImagesViewer({
    required this.images,
    this.fullWidth = false,
    this.minHeight = 250,
    this.maxHeight = 450,
    this.enableZoom = true,
    Key? key,
  }) : super(key: key);

  @override
  _ImagesViewerState createState() => _ImagesViewerState();
}

class _ImagesViewerState extends State<ImagesViewer> {
  final ThemeController themeController = Get.find();

  late final PageController _pageController;
  late final PhotoViewController _photoController;
  late final PhotoViewScaleStateController _scaleController;

  // هذا مثال لتعريف متغير _data وتخزين قائمة الصور فيه
  late final List<String> _data;

  static const double _zoomStep = 1.2;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // تهيئة _data باستخدام البيانات المُمرّرة من الـ widget
    _data = widget.images;
    _pageController = PageController(viewportFraction: 0.9999)
      ..addListener(_updateCurrentPage);
    _photoController = PhotoViewController();
    _scaleController = PhotoViewScaleStateController();
  }

  void _updateCurrentPage() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPageIndex) {
      setState(() => _currentPageIndex = newPage);
    }
  }

  void _zoomIn() {
    final current = _photoController.scale ?? 1.0;
    final minAllowed = PhotoViewComputedScale.contained.multiplier * 0.8;
    final maxAllowed = PhotoViewComputedScale.covered.multiplier * 2.5;
    final next = (current * _zoomStep).clamp(minAllowed, maxAllowed);
    _photoController.scale = next;
  }

  void _zoomOut() {
    final current = _photoController.scale ?? 1.0;
    final minAllowed = PhotoViewComputedScale.contained.multiplier * 0.8;
    final maxAllowed = PhotoViewComputedScale.covered.multiplier * 2.5;
    final next = (current / _zoomStep).clamp(minAllowed, maxAllowed);
    _photoController.scale = next;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _photoController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Text(
            "لا توجد صور متاحة",
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 17.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'عارض الصور، ${_data.length} صور',
      child: SizedBox(
        height: widget.maxHeight.h,
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              pageController: _pageController,
              itemCount: _data.length,
              scrollPhysics: const ClampingScrollPhysics(),
              allowImplicitScrolling: true,
              gaplessPlayback: true,
              backgroundDecoration: BoxDecoration(
                color: themeController.isDarkMode.value
                    ? AppColors.balckColorTypeFour
                    : AppColors.whiteColor,
              ),
              builder: (context, index) {
                final initialScale = widget.fullWidth
                    ? PhotoViewComputedScale.covered
                    : PhotoViewComputedScale.contained;
                return PhotoViewGalleryPageOptions.customChild(
                  controller: widget.enableZoom ? _photoController : null,
                  scaleStateController:
                      widget.enableZoom ? _scaleController : null,
                  child: CachedNetworkImage(
                    imageUrl: _data[index],
                    imageBuilder: (ctx, img) => Image(
                      image: img,
                      fit: widget.fullWidth ? BoxFit.cover : BoxFit.contain,
                      filterQuality: FilterQuality.low,
                    ),
                    placeholder: (ctx, url) => const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (ctx, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40.sp,
                          color: AppColors.blueLight,
                        ),
                      ),
                    ),
                  ),
                  initialScale: initialScale,
                  minScale: widget.enableZoom
                      ? PhotoViewComputedScale.contained * 0.8
                      : PhotoViewComputedScale.contained,
                  maxScale: widget.enableZoom
                      ? PhotoViewComputedScale.covered * 2.5
                      : PhotoViewComputedScale.contained,
                );
              },
            ),
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _data.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.oragne,
                    dotColor: Colors.grey.shade400,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                  onDotClicked: (idx) => _pageController.animateToPage(
                    idx,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
            if (widget.enableZoom)
              Positioned(
                bottom: 16.h,
                right: 16.w,
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: AppColors.backgroundColor(
                          themeController.isDarkMode.value),
                      mini: true,
                      heroTag: 'zoomIn',
                      onPressed: _zoomIn,
                      child: Icon(
                        Icons.add,
                        size: 15.sp,
                        color: AppColors.backgroundColorIconBack(
                            themeController.isDarkMode.value),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    FloatingActionButton(
                      backgroundColor: AppColors.backgroundColor(
                          themeController.isDarkMode.value),
                      mini: true,
                      heroTag: 'zoomOut',
                      onPressed: _zoomOut,
                      child: Icon(
                        Icons.remove,
                        size: 15.sp,
                        color: AppColors.backgroundColorIconBack(
                            themeController.isDarkMode.value),
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

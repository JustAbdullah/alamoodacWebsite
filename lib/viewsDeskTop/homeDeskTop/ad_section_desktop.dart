import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/home_controller.dart';
import '../../core/data/model/BannerAd.dart';

class AdSectionWebPage extends StatefulWidget {
  const AdSectionWebPage({super.key});

  @override
  State<AdSectionWebPage> createState() => _AdSectionWebPageState();
}

class _AdSectionWebPageState extends State<AdSectionWebPage> {
  final HomeController controller = Get.find<HomeController>();
  int _currentPage = 0;
  Timer? _timer;
  bool _isUserScrolling = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initPageController();
    _startAutoPlay();
  }

  void _initPageController() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    const itemWidthFraction = 0.39;
    const horizontalMargin = 16.0;
    final viewportFraction =
        (itemWidthFraction * screenWidth + horizontalMargin) / screenWidth;

    _pageController = PageController(
      viewportFraction: viewportFraction.clamp(0.1, 0.9),
    );
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted ||
          controller.latestBannerAdsList.isEmpty ||
          _isUserScrolling) return;

      final nextPage =
          (_currentPage + 1) % controller.latestBannerAdsList.length;
      if (_pageController.hasClients) {
        _pageController
            .animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuint,
        )
            .then((_) {
          if (mounted) setState(() => _currentPage = nextPage);
        });
      }
    });
  }

  void _resetAutoPlay() {
    _timer?.cancel();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.latestBannerAdsList.isEmpty) return _buildSkeletonLoader();
      if (controller.latestBannerAdsList.isEmpty)
        return _buildEmptyPlaceholder();
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            _buildBannersPageView(),
            SizedBox(height: 24.h),
            _buildIndicatorDots(),
          ],
        ),
      );
    });
  }

  Widget _buildBannersPageView() {
    return SizedBox(
      height: 300.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _isUserScrolling = notification.direction != ScrollDirection.idle;
            if (!_isUserScrolling) _resetAutoPlay();
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          padEnds: false,
          onPageChanged: (page) => setState(() => _currentPage = page),
          itemCount: controller.latestBannerAdsList.length,
          itemBuilder: (context, index) => _BannerCard(
            banner: controller.latestBannerAdsList[index],
            isActive: index == _currentPage,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorDots() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.latestBannerAdsList.length,
          (index) => GestureDetector(
            onTap: () {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage == index ? 32.w : 16.w,
              height: 6.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Get.theme.primaryColor
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        padEnds: false,
        controller:
            PageController(viewportFraction: _pageController.viewportFraction),
        itemCount: 3,
        itemBuilder: (_, index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Skeletonizer(
            enabled: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.grey[300]),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "إعلان ممول".tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 100.w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 48.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد إعلانات متاحة حالياً".tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerAd banner;
  final bool isActive;

  const _BannerCard({
    required this.banner,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.2 : 0.1),
            blurRadius: isActive ? 12 : 6,
            offset: Offset(0, isActive ? 4 : 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // التعديل الأساسي هنا
            CachedNetworkImage(
              imageUrl: banner.bannerImage,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[500],
                  size: 40.sp,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "إعلان ممول".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "إعلان جديد..!".tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

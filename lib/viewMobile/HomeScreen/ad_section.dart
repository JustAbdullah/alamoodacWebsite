import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/home_controller.dart';

class AdSection extends StatefulWidget {
  const AdSection({super.key});

  @override
  State<AdSection> createState() => _AdSectionState();
}

class _AdSectionState extends State<AdSection>
    with AutomaticKeepAliveClientMixin {
  final HomeController controller = Get.find<HomeController>();
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final int count = controller.latestBannerAdsList.length;
      if (count == 0) return;

      final int nextIndex = (controller.currentAdIndex.value + 1) % count;
      controller.currentAdIndex.value = nextIndex;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مهم لـ AutomaticKeepAliveClientMixin

    return Obx(() {
      if (controller.isLoadingLatestBannerAds.value) {
        return _buildLoadingIndicator();
      }
      if (controller.latestBannerAdsList.isEmpty) {
        return _buildPlaceholder();
      }
      return _buildAdCarousel();
    });
  }

  Widget _buildAdCarousel() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isRTL = Get.locale?.languageCode == 'ar';
    final int adCount = controller.latestBannerAdsList.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: screenWidth,
        height: 160.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                reverse: isRTL,
                onPageChanged: (int index) =>
                    controller.currentAdIndex.value = index,
                itemCount: adCount,
                itemBuilder: (context, index) {
                  final String imageUrl =
                      controller.latestBannerAdsList[index].bannerImage;
                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    memCacheHeight: 500,
                    placeholder: (context, url) => _buildShimmerEffect(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),
              Positioned(
                bottom: 15.h,
                left: 0,
                right: 0,
                child: Obx(() {
                  final int current = controller.currentAdIndex.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      adCount,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: current == index ? 20.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: current == index
                              ? Colors.amber
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[100]!],
                ).createShader(rect);
              },
              child: Container(
                width: 320.w,
                height: 120.h,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 200.w,
            height: 8.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Colors.white10,
        highlightColor: Colors.white,
        duration: Duration(seconds: 2),
      ),
      child: Skeleton.leaf(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

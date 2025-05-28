import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/PromotedAdController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../customWidgets/custom_image_malt.dart';

class PromotedadpageDeskTopPage extends StatefulWidget {
  const PromotedadpageDeskTopPage({super.key});

  @override
  _PromotedadpageDeskTopPageState createState() =>
      _PromotedadpageDeskTopPageState();
}

class _PromotedadpageDeskTopPageState extends State<PromotedadpageDeskTopPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<PromotedadController>();
  final homeController = Get.find<HomeController>();
  final ThemeController themeController = Get.find();
  late AnimationController _animationController;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAutoScroll();
  }

  void _initAnimations() {
    _pageController = PageController(
      viewportFraction: 0.08,
      initialPage: 0,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (controller.adsList.isEmpty) return;
      if (_currentPage >= controller.adsList.length - 1) {
        _pageController.jumpToPage(0);
      } else {
        _currentPage++;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCirc,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 380.h,
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWebHeader(),
              SizedBox(height: 15.h),
              Expanded(child: _buildContentSection()),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWebHeader() {
    return Row(
      children: [
        Icon(
          Icons.rocket_launch_rounded,
          color: AppColors.backgroundColorIconBack(
              themeController.isDarkMode.value),
          size: 30.sp,
        ),
        SizedBox(width: 12.w),
        Text(
          "المنشورات الممولة".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Obx(() {
      if (controller.loadingAds.value) return _buildWebShimmerLoader();
      if (controller.adsList.isEmpty) return _buildWebEmptyState();
      return _buildWebPromotedAdsList();
    });
  }

  Widget _buildWebShimmerLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: Skeletonizer(
          child: Container(
            width: 260.w,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode.value
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 120.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
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

  Widget _buildWebEmptyState() {
    return Center(
      child: Container(
        width: 450.w,
        padding: EdgeInsets.all(25.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.ads_click_rounded,
              size: 60.sp,
              color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value),
            ),
            SizedBox(height: 15.h),
            Column(
              children: [
                Text(
                  "لا توجد إعلانات ممولة حالياً".tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'يمكنك التحقق لاحقاً أو تصفح المنشورات العادية'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textColor(themeController.isDarkMode.value)
                        .withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    themeController.isDarkMode.value),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: AppColors.backgroundColorIconBack(
                            themeController.isDarkMode.value)
                        .withOpacity(0.3),
                  ),
                ),
                elevation: 4,
              ),
              onPressed: () async {
                controller.loadingAds.value = false;
                controller.onInit();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'إعادة المحاولة'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppTextStyles.DinarOne,
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

  Widget _buildWebPromotedAdsList() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.adsList.length,
        itemBuilder: (context, index) {
          final promotedAd = controller.adsList[index];
          final post = promotedAd.post;
          final priceDetails = _getPriceDetails(post);
          final isHovered = false.obs;

          return Obx(() => MouseRegion(
                onEnter: (_) => isHovered.value = true,
                onExit: (_) => isHovered.value = false,
                cursor: SystemMouseCursors.click,
                child: AnimatedScale(
                  scale: isHovered.value ? 1.04 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 260.w,
                    margin: EdgeInsets.only(right: 15.w),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: AppColors.cardColor(
                              themeController.isDarkMode.value),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () => _handlePostTap(post),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildWebImageSection(post)),
                                _buildWebPostInfo(post, priceDetails),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.h,
                          left: 12.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColorIconBack(
                                  themeController.isDarkMode.value),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium_rounded,
                                    color: Colors.white, size: 16.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  'ممول'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTextStyles.DinarOne,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _buildWebImageSection(Post post) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ImagesViewer(
              fullWidth: true,
              images: post.images.split(','),
            ),
          ),
        ),
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: _buildWebInfoBadge(
            Icons.remove_red_eye,
            post.views.toString(),
          ),
        ),
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: _buildWebInfoBadge(
            Icons.star_rate_rounded,
            post.rating,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildWebPostInfo(Post post, PriceDetails priceDetails) {
    final isDarkMode = themeController.isDarkMode.value;
    final hasValidPrice =
        priceDetails.hasPrice && priceDetails.priceValue != '0';

    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 230.w),
            child: Text(
              post.translations.first.title.toString(),
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(isDarkMode),
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hasValidPrice
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.yellowColor.withOpacity(0.1)
                          : AppColors.backgroundColorIconBack(isDarkMode)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          size: 18.sp,
                          color: isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.backgroundColorIconBack(isDarkMode),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          homeController
                              .getConvertedPrice(priceDetails.priceValue),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.backgroundColorIconBack(isDarkMode),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16.sp, color: Colors.grey),
                        SizedBox(width: 6.w),
                        Text(
                          'بدون سعر'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppTextStyles.DinarOne,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebInfoBadge(IconData icon, String value, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color ?? Colors.white),
          SizedBox(width: 5.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  PriceDetails _getPriceDetails(Post post) {
    try {
      final priceDetail = post.details.firstWhere(
        (detail) => detail.detailName == "السعر",
      );
      final hasPrice =
          priceDetail.detailValue.isNotEmpty && priceDetail.detailValue != '0';
      return PriceDetails(
        priceValue: hasPrice ? priceDetail.detailValue : '',
        hasPrice: hasPrice,
      );
    } catch (e) {
      return PriceDetails(priceValue: '', hasPrice: false);
    }
  }

  void _handlePostTap(Post post) {
    homeController.setSelectedPost(post);
    homeController.showDetailsPost.value = true;
    Get.toNamed(
      '/post/${post.id}', // المسار مع المعلمة الديناميكية

      arguments: post, // إرسال الكائن كامل
    );
  }
}

class PriceDetails {
  final String priceValue;
  final bool hasPrice;

  PriceDetails({required this.priceValue, required this.hasPrice});
}

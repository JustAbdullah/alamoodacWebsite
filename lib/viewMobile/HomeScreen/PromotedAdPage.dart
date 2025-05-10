import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/PromotedAdController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/PromotedAd.dart';
import '../../core/data/model/post.dart';
import '../../customWidgets/custom_image_malt.dart';

class PromotedAdPage extends StatefulWidget {
  const PromotedAdPage({super.key});

  @override
  State<PromotedAdPage> createState() => _PromotedAdPageState();
}

class _PromotedAdPageState extends State<PromotedAdPage>
    with AutomaticKeepAliveClientMixin {
  final PromotedadController controller = Get.find();
  final HomeController homeController = Get.find();
  final ThemeController themeController = Get.find();

  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initComponents();
    _loadDataIfNeeded();
  }

  void _initComponents() {
    _pageController = PageController(viewportFraction: 0.8);
    if (controller.adsList.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _loadDataIfNeeded() {
    if (controller.adsList.isEmpty && !controller.loadingAds.value) {}
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _animateToNextPage(),
    );
  }

  void _animateToNextPage() {
    final count = controller.adsList.length;
    if (count == 0) return;
    final newPage = (_currentPage + 1) % count;
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant PromotedAdPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.adsList.isNotEmpty && !_autoScrollTimer!.isActive) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildMainContainer();
  }

  Widget _buildMainContainer() {
    final isDark = themeController.isDarkMode.value;
    return Container(
      width: double.infinity,
      height: 340.h,
      color: AppColors.backgroundColor(isDark),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 4),
          Expanded(child: _buildContentSection()),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Obx(() {
      if (controller.loadingAds.value) {
        return const _ShimmerLoader();
      }
      if (controller.adsList.isEmpty) {
        return const _EmptyState();
      }
      return _PromotedCarousel(
        pageController: _pageController,
        currentPage: _currentPage,
        ads: controller.adsList,
        onPageChanged: (i) => setState(() => _currentPage = i),
      );
    });
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          const _SpinningIcon(),
          SizedBox(width: 8.w),
          Text(
            "المنشورات الممولة".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinningIcon extends StatefulWidget {
  const _SpinningIcon();

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (ctx, child) => Transform.rotate(
        angle: _anim.value * 0.2,
        child: child,
      ),
      child: Icon(
        Icons.rocket_launch_rounded,
        size: 28.sp,
        color: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value),
      ),
    );
  }
}

class _PromotedCarousel extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<PromotedAd> ads;
  final ValueChanged<int> onPageChanged;

  const _PromotedCarousel({
    required this.pageController,
    required this.currentPage,
    required this.ads,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: ads.length,
      padEnds: false,
      allowImplicitScrolling: true,
      onPageChanged: onPageChanged,
      itemBuilder: (ctx, idx) => _PromotedAdCard(ad: ads[idx]),
    );
  }
}

class _PromotedAdCard extends StatelessWidget {
  final PromotedAd ad;

  const _PromotedAdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    final homeController = Get.find<HomeController>();
    final post = ad.post;
    final price = post.details
        .firstWhereOrNull(
            (d) => d.detailName == "السعر" && d.detailValue != '0')
        ?.detailValue;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: RepaintBoundary(
        child: Card(
          elevation: 2,
          shape: _buildCardShape(isDark),
          color: AppColors.cardColor(isDark),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _handlePostTap(post),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(post),
                  _buildPostInfo(post, price, homeController, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder _buildCardShape(bool isDark) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: isDark
            ? AppColors.yellowColor
            : AppColors.backgroundColorIconBack(isDark),
        width: 1.2,
      ),
    );
  }

  void _handlePostTap(Post post) {
    final home = Get.find<HomeController>();
    home.setSelectedPost(post);
    home.showDetailsPost.value = true;
    Get.toNamed('/post-mobile/${post.id}', arguments: post);
  }
}

Widget _buildImageSection(Post post) {
  return Expanded(
    flex: 2,
    child: Stack(
      children: [
        ImagesViewer(
          fullWidth: true,
          images: post.images.split(','),
        ),
        _Badge(
          icon: Icons.remove_red_eye_outlined,
          text: post.views.toString(),
          alignLeft: true,
        ),
        _Badge(
          icon: Icons.star_rate_rounded,
          text: post.rating,
          alignLeft: false,
          color: Colors.amber,
        ),
      ],
    ),
  );
}

Widget _buildPostInfo(
    Post post, String? price, HomeController controller, bool isDark) {
  return Padding(
    padding: EdgeInsets.all(12.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostTitle(post),
        const SizedBox(height: 8),
        _buildPriceInfo(price, controller, isDark),
      ],
    ),
  );
}

Widget _buildPostTitle(Post post) {
  return Text(
    post.translations.first.title!,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: AppTextStyles.DinarOne,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
    ),
  );
}

Widget _buildPriceInfo(String? price, HomeController controller, bool isDark) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: price != null
        ? _PriceTag(price: price, controller: controller, isDark: isDark)
        : const _NoPriceTag(),
  );
}

class _PriceTag extends StatelessWidget {
  final String price;
  final HomeController controller;
  final bool isDark;

  const _PriceTag({
    required this.price,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.yellowColor.withOpacity(0.1)
            : AppColors.backgroundColorIconBack(isDark).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_money_rounded,
            size: 15.sp,
            color: isDark
                ? AppColors.whiteColor
                : AppColors.backgroundColorIconBack(isDark),
          ),
          SizedBox(width: 4.w),
          Text(
            controller.getConvertedPrice(price),
            style: TextStyle(
              fontSize: 15.sp,
              color: isDark
                  ? AppColors.whiteColor
                  : AppColors.backgroundColorIconBack(isDark),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoPriceTag extends StatelessWidget {
  const _NoPriceTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline_rounded, size: 14.sp, color: Colors.grey),
          SizedBox(width: 4.w),
          Text(
            'بدون سعر'.tr,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool alignLeft;
  final Color? color;

  const _Badge({
    required this.icon,
    required this.text,
    required this.alignLeft,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.h,
      left: alignLeft ? 10.w : null,
      right: alignLeft ? null : 10.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14.sp, color: color ?? Colors.white),
            SizedBox(width: 4.w),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}

class _ShimmerLoader extends StatelessWidget {
  const _ShimmerLoader();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Skeletonizer(
          child: Container(
            width: 290.w,
            decoration: BoxDecoration(
              color: AppColors.cardColor(isDark),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    return Center(
      child: Text(
        'لا توجد إعلانات ممولة حالياً'.tr,
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 18.sp,
          color: AppColors.textColor(isDark),
        ),
      ),
    );
  }
}

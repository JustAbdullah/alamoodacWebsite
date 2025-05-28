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
  // استرداد الـ Controllers مرة واحدة لتفادي الاستدعاءات المتكررة
  final PromotedadController promotedController = Get.find();
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
    _loadDataIfNeeded(); // حالياً لا يحتوي على منطق؛ يمكن تطويره لاحقاً إذا لزم الأمر
  }

  void _initComponents() {
    // viewportFraction أقل من الواحد لإظهار جزء من البطاقة المجاورة، مما يعطي تأثير رائع
    _pageController = PageController(viewportFraction: 0.8);
    if (promotedController.adsList.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _loadDataIfNeeded() {
    // في حال كان الإعلان فارغ وغير قيد التحميل، يمكن تنفيذ منطق لتحميل البيانات هنا.
    if (promotedController.adsList.isEmpty &&
        !promotedController.loadingAds.value) {
      // منطق تحميل البيانات هنا إذا لزم
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final int count = promotedController.adsList.length;
      if (count == 0) return;
      final int newPage = (_currentPage + 1) % count;
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  void _animateToNextPage() {
    final int count = promotedController.adsList.length;
    if (count == 0) return;
    final int newPage = (_currentPage + 1) % count;
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant PromotedAdPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (promotedController.adsList.isNotEmpty &&
        !(_autoScrollTimer?.isActive ?? false)) {
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
    super.build(context); // مهم لعمل AutomaticKeepAliveClientMixin
    return _buildMainContainer();
  }

  Widget _buildMainContainer() {
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      width: double.infinity,
      height: 340.h,
      color: AppColors.backgroundColor(isDark),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          SizedBox(height: 4.h),
          Expanded(child: _buildContentSection()),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Obx(() {
      if (promotedController.loadingAds.value) {
        return const _ShimmerLoader();
      }
      if (promotedController.adsList.isEmpty) {
        return const _EmptyState();
      }
      return _PromotedCarousel(
        pageController: _pageController,
        currentPage: _currentPage,
        ads: promotedController.adsList,
        onPageChanged: (int i) => setState(() => _currentPage = i),
      );
    });
  }
}

// قسم رأس الصفحة مع أيقونة دوارة وعنوان ثابت
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    // تخزين قيمة الوضع الداكن محلياً لتقليل استدعاءات Get.find
    final bool isDark = Get.find<ThemeController>().isDarkMode.value;
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
    // استخدام AnimatedBuilder لتجنب إعادة بناء الأيقونة بالكامل عند تغير القيمة
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
          Get.find<ThemeController>().isDarkMode.value,
        ),
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
  final HomeController homeController = Get.find();
  final ThemeController themeController = Get.find();

  _PromotedAdCard({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeController.isDarkMode.value;
    final Post post = ad.post;
    final String? price = post.details
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
                  _buildPostInfo(post, price, isDark),
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
    // استخدام الـ homeController المخزّن مسبقاً لتجنب استدعاء Get.find مجددًا
    homeController.setSelectedPost(post);
    homeController.showDetailsPost.value = true;
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

Widget _buildPostInfo(Post post, String? price, bool isDark) {
  return Padding(
    padding: EdgeInsets.all(12.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostTitle(post, isDark),
        const SizedBox(height: 8),
        _buildPriceInfo(price, isDark),
      ],
    ),
  );
}

Widget _buildPostTitle(Post post, bool isDark) {
  return Text(
    post.translations.first.title!,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: AppTextStyles.DinarOne,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textColor(isDark),
    ),
  );
}

Widget _buildPriceInfo(String? price, bool isDark) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: price != null
        ? _PriceTag(price: price, isDark: isDark)
        : const _NoPriceTag(),
  );
}

class _PriceTag extends StatelessWidget {
  final String price;
  final bool isDark;

  const _PriceTag({
    Key? key,
    required this.price,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // يُفترض أن المعالجة في الدالة getConvertedPrice تُجرى عبر الـ HomeController،
    // ويمكن دمجها هنا إذا كان ذلك مناسبًا، أو تمرير السعر المحوّل مُسبقًا.
    final String convertedPrice =
        Get.find<HomeController>().getConvertedPrice(price);

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
            convertedPrice,
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
  const _NoPriceTag({Key? key}) : super(key: key);

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
          Icon(
            Icons.info_outline_rounded,
            size: 14.sp,
            color: Colors.grey,
          ),
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
    Key? key,
    required this.icon,
    required this.text,
    required this.alignLeft,
    this.color,
  }) : super(key: key);

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
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerLoader extends StatelessWidget {
  const _ShimmerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.find<ThemeController>().isDarkMode.value;
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
  const _EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.find<ThemeController>().isDarkMode.value;
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

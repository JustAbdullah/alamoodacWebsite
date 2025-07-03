import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../customWidgets/custom_image_malt.dart';

class CustomCardPost extends StatefulWidget {
  final String title; // عنوان القسم
  final RxBool isLoading; // حالة التحميل
  final RxList<Post> postsList; // قائمة المنشورات
  final void Function()? onTap;

  const CustomCardPost({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.postsList,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomCardPost> createState() => _CustomCardPostState();
}

class _CustomCardPostState extends State<CustomCardPost>
    with AutomaticKeepAliveClientMixin {
  // استدعاء الـ Controllers مرة واحدة لتقليل التكرار
  final HomeController controller = Get.find();
  final ThemeController themeController = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // استخراج عرض الشاشة لتقليل استدعاءات MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    return _buildMainContainer(screenWidth);
  }

  Widget _buildMainContainer(double screenWidth) {
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      width: screenWidth,
      height: 300.h,
      color: AppColors.backgroundColor(isDark),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    // نستخدم القيمة المحفوظة (isDark) بدلاً من استدعاء Get.find مجددًا
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          children: [
            Icon(
              Icons.category,
              color: AppColors.backgroundColorIconBack(isDark),
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              widget.title.tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(isDark),
                fontSize: 21.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Obx(() {
        if (widget.isLoading.value) {
          return _buildShimmerLoader();
        }
        if (widget.postsList.isEmpty) {
          return _EmptyState(controller: controller);
        }
        return _PostsList(
          posts: widget.postsList,
          themeController: themeController,
        );
      }),
    );
  }

  Widget _buildShimmerLoader() {
    final bool isDark = themeController.isDarkMode.value;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemExtent: 185.w,
      cacheExtent: 1000.w,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Skeletonizer(
          child: _SkeletonPostItem(isDarkMode: isDark),
        ),
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  final List<Post> posts;
  final ThemeController themeController;

  const _PostsList({
    Key? key,
    required this.posts,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: posts.length,
      itemExtent: 185.w,
      cacheExtent: 1000.w,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => _PostItem(
        post: posts[index],
        themeController: themeController,
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  final Post post;
  final ThemeController themeController;

  const _PostItem({
    Key? key,
    required this.post,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PriceDetails priceDetails = _getPriceDetails(post);
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handlePostTap(post),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.cardColor(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _PostImageSection(
                  post: post,
                  themeController: themeController,
                ),
              ),
              _PostInfoSection(
                post: post,
                priceDetails: priceDetails,
                themeController: themeController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PriceDetails _getPriceDetails(Post post) {
    try {
      final priceDetail = post.details.firstWhere(
        (detail) => detail.detailName == "السعر",
      );
      final bool hasPrice =
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
    final HomeController controller = Get.find<HomeController>();
    controller.setSelectedPost(post);
    controller.showDetailsPost.value = true;
    Get.toNamed(
      '/post-mobile/${post.id}',
      arguments: post,
    );
  }
}

class _PostImageSection extends StatelessWidget {
  final Post post;
  final ThemeController themeController;

  const _PostImageSection({
    Key? key,
    required this.post,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
          bottom: 6.h,
          left: 6.w,
          child: _InfoBadge(
            icon: Icons.remove_red_eye,
            value: post.views.toString(),
          ),
        ),
        Positioned(
          bottom: 6.h,
          right: 6.w,
          child: _InfoBadge(
            icon: Icons.star_rate_rounded,
            value: post.rating,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}

/// نموذج بيانات السعر.
class PriceDetails {
  final String priceValue;
  final bool hasPrice;

  PriceDetails({required this.priceValue, required this.hasPrice});
}

//////////////////
class _PostInfoSection extends StatelessWidget {
  final Post post;
  final PriceDetails priceDetails;
  final ThemeController themeController;

  const _PostInfoSection({
    Key? key,
    required this.post,
    required this.priceDetails,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخرج حالة الوضع الداكن مرة واحدة
    final bool isDarkMode = themeController.isDarkMode.value;
    final bool hasValidPrice =
        priceDetails.hasPrice && priceDetails.priceValue != '0';

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: Text(
              post.translations.first.title.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(isDarkMode),
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hasValidPrice
                ? _PriceTag(priceDetails: priceDetails)
                : const _NoPriceTag(),
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final PriceDetails priceDetails;

  const _PriceTag({Key? key, required this.priceDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخرج الـ HomeController وThemeController مرة واحدة
    final HomeController homeController = Get.find<HomeController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    final String convertedPrice =
        homeController.getConvertedPrice(priceDetails.priceValue);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.yellowColor.withOpacity(0.1)
            : AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_money_rounded,
            size: 15.sp,
            color: isDarkMode
                ? AppColors.whiteColor
                : AppColors.backgroundColorIconBack(isDarkMode),
          ),
          SizedBox(width: 4.w),
          Text(
            convertedPrice,
            style: TextStyle(
              fontSize: 15.sp,
              color: isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.backgroundColorIconBack(isDarkMode),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? color;

  const _InfoBadge({
    Key? key,
    required this.icon,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color ?? Colors.white),
          SizedBox(width: 3.w),
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
}

class _EmptyState extends StatelessWidget {
  final HomeController controller;

  const _EmptyState({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تخزين حجم الشاشة وحالة الوضع الداكن محلياً
    final double screenWidth = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 50.sp,
            color: AppColors.backgroundColorIconBack(isDark),
          ),
          SizedBox(height: 4.h),
          Column(
            children: [
              Text(
                "لايوجد محتوى بهذا القسـم".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(isDark),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'يمكنك المحاولة لاحقاً أو التحقق من اتصالك بالإنترنت'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textColor(isDark).withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          _RetryButton(controller: controller),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final HomeController controller;

  const _RetryButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.find<ThemeController>().isDarkMode.value;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundColorIconBack(isDark),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.backgroundColorIconBack(isDark).withOpacity(0.2),
          ),
        ),
        elevation: 3,
        shadowColor: AppColors.backgroundColorIconBack(isDark).withOpacity(0.3),
      ),
      onPressed: () async {
        controller.isGetDataFirstTime.value = false;
        controller.onInit();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh_rounded, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            'إعادة المحاولة'.tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: AppTextStyles.DinarOne,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPostItem extends StatelessWidget {
  final bool isDarkMode;

  const _SkeletonPostItem({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: 100.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
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

/// نموذج بيانات السعر.

/////////////////////////////////

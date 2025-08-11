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

class MostRatingPost extends StatefulWidget {
  const MostRatingPost({super.key});

  @override
  _MostRatingPostState createState() => _MostRatingPostState();
}

class _MostRatingPostState extends State<MostRatingPost>
      {
  final HomeController controller = Get.find();
  final ThemeController themeController = Get.find();

  

  @override
  Widget build(BuildContext context) {
    return _buildMainContainer();
  }

  Widget _buildMainContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300.h,
      color: AppColors.backgroundColor(themeController.isDarkMode.value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.rate_review_sharp,
            color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value),
            size: 28.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            "المنشورات الأعلى تقييم".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Obx(() {
        if (controller.LoadingPostsMostRating.value) {
          return _buildShimmerLoader();
        }
        if (controller.postsListMostRating.isEmpty) {
          return _EmptyState(controller: controller);
        }
        return _postsListMostRating(
          posts: controller.postsListMostRating,
          themeController: themeController,
        );
      }),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemExtent: 185.w,
      cacheExtent: 1000.w,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Skeletonizer(
          child:
              _SkeletonPostItem(isDarkMode: themeController.isDarkMode.value),
        ),
      ),
    );
  }
}

class _postsListMostRating extends StatelessWidget {
  final List<Post> posts;
  final ThemeController themeController;

  const _postsListMostRating({
    required this.posts,
    required this.themeController,
  });

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
    required this.post,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final priceDetails = _getPriceDetails(post);

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
          color: AppColors.cardColor(themeController.isDarkMode.value),
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
    final controller = Get.find<HomeController>();
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
    required this.post,
    required this.themeController,
  });

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

class _PostInfoSection extends StatelessWidget {
  final Post post;
  final PriceDetails priceDetails;
  final ThemeController themeController;

  const _PostInfoSection({
    required this.post,
    required this.priceDetails,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode.value;
    final hasValidPrice =
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
                : _NoPriceTag(),
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final PriceDetails priceDetails;

  const _PriceTag({required this.priceDetails});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDarkMode = Get.find<ThemeController>().isDarkMode.value;

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
            controller.getConvertedPrice(priceDetails.priceValue),
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
    required this.icon,
    required this.value,
    this.color,
  });

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

  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor(themeController.isDarkMode.value),
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
            color: AppColors.backgroundColorIconBack(
                themeController.isDarkMode.value),
          ),
          SizedBox(height: 4.h),
          Column(
            children: [
              Text(
                "لايوجد محتوى بهذا القسـم".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'يمكنك المحاولة لاحقاً أو التحقق من اتصالك بالإنترنت'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textColor(themeController.isDarkMode.value)
                      .withOpacity(0.8),
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

  const _RetryButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.2)),
        ),
        elevation: 3,
        shadowColor: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            .withOpacity(0.3),
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

  const _SkeletonPostItem({required this.isDarkMode});

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

class PriceDetails {
  final String priceValue;
  final bool hasPrice;

  PriceDetails({required this.priceValue, required this.hasPrice});
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' as intl;

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../customWidgets/custom_image_malt.dart';

Searchcontroller controller = Get.put(Searchcontroller());

class PostSearchingList extends StatelessWidget {
  const PostSearchingList({super.key});

  String _getFormattedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final currentLocale = Get.locale?.languageCode;
      final effectiveLocale = (currentLocale == 'ar') ? 'ar' : 'en';

      return intl.DateFormat("dd MMM yyyy, hh:mm a", effectiveLocale)
          .format(date);
    } catch (e) {
      return intl.DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: GetBuilder<Searchcontroller>(
        id: 'posts_list',
        builder: (controller) {
          if (controller.loadingSearchPosts.value) {
            return _buildSkeletonLoader();
          } else if (controller.searchPostsList.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildPostsList(controller);
          }
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
        child: Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.h,
                width: double.infinity,
                color: Colors.grey[400],
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.sp,
                      width: 120.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 14.sp,
                      width: 80.w,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList(Searchcontroller controller) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.searchPostsList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final post = controller.searchPostsList[index];
        return _PostCard(
          key: ValueKey(post.id), // مفتاح فريد لكل منشور
          post: post,
          formattedDate: _getFormattedDate(post.createdAt),
        );
      },
    );
  }

  void _showPostDetails(Post post) {
    final homeController = Get.find<HomeController>();
    homeController.setSelectedPost(post);
    homeController.showDetailsPost.value = true;
    Get.toNamed('/post-mobile/${post.id}', arguments: post);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 60.sp,
            color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value),
          ),
          SizedBox(height: 20.h),
          Text(
            "لا توجد منشورات متاحة حالياً".tr,
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "يمكنك المحاولة لاحقًا أو تحديث الصفحة".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final String formattedDate;

  const _PostCard({
    required Key key,
    required this.post,
    required this.formattedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      child: Material(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showPostDetails(post),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostImages(post: post),
              _PostContent(
                post: post,
                formattedDate: formattedDate,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostDetails(Post post) {
    final homeController = Get.find<HomeController>();
    homeController.setSelectedPost(post);
    homeController.showDetailsPost.value = true;
    Get.toNamed('/post-mobile/${post.id}', arguments: post);
  }
}

class _PostImages extends StatelessWidget {
  final Post post;

  const _PostImages({required this.post});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            height: 320.h,
            width: double.infinity,
            child: ImagesViewer(images: post.images.split(',')),
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

class _PostContent extends StatelessWidget {
  final Post post;
  final String formattedDate;
  final bool isDarkMode;

  const _PostContent({
    required this.post,
    required this.formattedDate,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final priceDetails = _getPriceDetails(post);
    final cityName = _getCityName(post);
    final subCategoryName = _getSubCategoryName(post);

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostTitle(post: post, isDarkMode: isDarkMode),
          SizedBox(height: 12.h),
          _PostDate(formattedDate: formattedDate),
          SizedBox(height: 12.h),
          _LocationAndCategory(
            cityName: cityName,
            subCategoryName: subCategoryName,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 12.h),
          _PriceTag(priceDetails: priceDetails, isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  String _getCityName(Post post) {
    return post.city.slug.trim().isEmpty
        ? "الموقع غير متوفر".tr
        : post.city.translations.isNotEmpty
            ? post.city.translations.first.name
            : post.city.slug;
  }

  String _getSubCategoryName(Post post) {
    return post.subcategory.translations.isNotEmpty
        ? post.subcategory.translations.first.name
        : post.subcategory.slug;
  }

  PriceDetails _getPriceDetails(Post post) {
    final priceDetail = post.details.firstWhere(
      (d) => d.detailName == "السعر",
      orElse: () => Detail(
        id: 0,
        postId: '',
        detailName: '',
        detailValue: '',
        translations: [],
      ),
    );

    final hasPrice =
        priceDetail.detailValue.isNotEmpty && priceDetail.detailValue != '0';
    return PriceDetails(
      priceValue: hasPrice ? priceDetail.detailValue : '',
      hasPrice: hasPrice,
    );
  }
}

class _PostTitle extends StatelessWidget {
  final Post post;
  final bool isDarkMode;

  const _PostTitle({required this.post, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      post.translations.first.title.toString(),
      style: TextStyle(
        fontSize: 19.sp,
        fontFamily: AppTextStyles.DinarOne,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.grey[800],
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _PostDate extends StatelessWidget {
  final String formattedDate;

  const _PostDate({required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
        SizedBox(width: 4.w),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 16.sp,
            color: Get.find<ThemeController>().isDarkMode.value
                ? Colors.white70
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _LocationAndCategory extends StatelessWidget {
  final String cityName;
  final String subCategoryName;
  final bool isDarkMode;

  const _LocationAndCategory({
    required this.cityName,
    required this.subCategoryName,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 17.sp, color: Colors.grey),
        SizedBox(width: 4.w),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 120.w),
          child: Text(
            cityName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Icon(Icons.category, size: 17.sp, color: Colors.grey),
        SizedBox(width: 4.w),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150.w),
          child: Text(
            subCategoryName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  final PriceDetails priceDetails;
  final bool isDarkMode;

  const _PriceTag({required this.priceDetails, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: priceDetails.hasPrice
            ? (isDarkMode
                ? AppColors.yellowColor.withOpacity(0.2)
                : AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.1))
            : Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priceDetails.hasPrice
                ? Icons.currency_lira_rounded
                : Icons.info_outline_rounded,
            size: 20.sp,
            color: priceDetails.hasPrice
                ? AppColors.textColor(isDarkMode)
                : Colors.grey,
          ),
          SizedBox(width: 6.w),
          Text(
            priceDetails.hasPrice
                ? Get.find<HomeController>()
                    .getConvertedPrice(priceDetails.priceValue)
                : 'بدون سعر'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: AppTextStyles.DinarOne,
              fontWeight: FontWeight.w700,
              color: priceDetails.hasPrice
                  ? AppColors.textColor(isDarkMode)
                  : Colors.grey,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
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

class PriceDetails {
  final String priceValue;
  final bool hasPrice;

  PriceDetails({required this.priceValue, required this.hasPrice});
}

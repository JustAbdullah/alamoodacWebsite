import 'dart:ui';

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

class MostRatingPostDesktop extends StatefulWidget {
  const MostRatingPostDesktop({super.key});

  @override
  _MostRatingPostDesktopState createState() => _MostRatingPostDesktopState();
}

class _MostRatingPostDesktopState extends State<MostRatingPostDesktop> {
  final controller = Get.find<HomeController>();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 380.h, // تم تقليل الارتفاع قليلاً
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWebHeader(),
              SizedBox(height: 15.h), // تقليل المسافة هنا
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
        )
      ],
    );
  }

  Widget _buildContentSection() {
    return Obx(() {
      if (controller.LoadingPostsMostRating.value)
        return _buildWebShimmerLoader();
      if (controller.postsListMostRating.isEmpty) return _buildWebEmptyState();
      return _buildWebpostsListMostRating();
    });
  }

  Widget _buildWebShimmerLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(right: 15.w), // تقليل المسافة بين العناصر
        child: Skeletonizer(
          child: Container(
            width: 260.w, // تصغير عرض الكرت
            margin:
                EdgeInsets.symmetric(vertical: 8.h), // تقليل المسافة الرأسية
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // تصغير زوايا الكرت
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
                          top: Radius.circular(15), // تصغير زوايا الصورة
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.w), // تقليل الحشو الداخلي
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w, // تصغير عرض العنصر
                          height: 18.h, // تصغير الارتفاع
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 10.h), // تقليل المسافة
                        Container(
                          width: 120.w, // تصغير العرض
                          height: 16.h, // تصغير الارتفاع
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
        width: 450.w, // تصغير العرض
        padding: EdgeInsets.all(25.w), // تقليل الحشو
        decoration: BoxDecoration(
          color: AppColors.cardColor(themeController.isDarkMode.value),
          borderRadius: BorderRadius.circular(20), // تصغير الزوايا
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15, // تقليل التظليل
              offset: Offset(0, 8), // تقليل الإزاحة
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 60.sp, // تصغير حجم الأيقونة
              color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value),
            ),
            SizedBox(height: 15.h), // تقليل المسافة
            Column(
              children: [
                Text(
                  "لا يوجد محتوى حالياً".tr,
                  style: TextStyle(
                    fontSize: 20.sp, // تصغير حجم النص
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h), // تقليل المسافة
                Text(
                  'يمكنك المحاولة لاحقاً أو التحقق من اتصالك بالإنترنت'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp, // تصغير حجم النص
                    color: AppColors.textColor(themeController.isDarkMode.value)
                        .withOpacity(0.8),
                    height: 1.4, // تقليل ارتفاع السطر
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h), // تقليل المسافة
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    themeController.isDarkMode.value),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 30.w, vertical: 12.h), // تصغير الحشو
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // تصغير الزوايا
                  side: BorderSide(
                    color: AppColors.backgroundColorIconBack(
                            themeController.isDarkMode.value)
                        .withOpacity(0.3),
                  ),
                ),
                elevation: 4, // تقليل الارتفاع
              ),
              onPressed: () async {
                controller.isGetDataFirstTime.value = false;
                controller.onInit();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded,
                      size: 20.sp), // تصغير حجم الأيقونة
                  SizedBox(width: 10.w), // تقليل المسافة
                  Text(
                    'إعادة المحاولة'.tr,
                    style: TextStyle(
                      fontSize: 16.sp, // تصغير حجم النص
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

  Widget _buildWebpostsListMostRating() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.postsListMostRating.length,
        itemBuilder: (context, index) {
          final post = controller.postsListMostRating[index];
          final priceDetails = _getPriceDetails(post);

          // نستخدم RxBool لحالة التمرير للماوس
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
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color:
                          AppColors.cardColor(themeController.isDarkMode.value),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => _handlePostTap(post),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2, child: _buildWebImageSection(post)),
                            _buildWebPostInfo(post, priceDetails),
                          ],
                        ),
                      ),
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
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(15)), // تصغير زوايا الصورة
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
          bottom: 12.h, // تقليل المسافة من الأسفل
          left: 12.w, // تقليل المسافة من اليسار
          child: _buildWebInfoBadge(
            Icons.remove_red_eye,
            post.views.toString(),
          ),
        ),
        Positioned(
          bottom: 12.h, // تقليل المسافة من الأسفل
          right: 12.w, // تقليل المسافة من اليمين
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
      padding: EdgeInsets.all(15.w), // تقليل الحشو الداخلي
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 230.w), // تصغير العرض الأقصى
            child: Text(
              post.translations.first.title.toString(),
              style: TextStyle(
                fontSize: 18.sp, // تصغير حجم النص
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(isDarkMode),
                fontWeight: FontWeight.bold,
                height: 1.3, // تقليل ارتفاع السطر
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.h), // تقليل المسافة
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hasValidPrice
                ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h), // تصغير الحشو
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.yellowColor.withOpacity(0.1)
                          : AppColors.backgroundColorIconBack(isDarkMode)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10), // تصغير الزوايا
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          size: 18.sp, // تصغير حجم الأيقونة
                          color: isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.backgroundColorIconBack(isDarkMode),
                        ),
                        SizedBox(width: 6.w), // تقليل المسافة
                        Text(
                          controller.getConvertedPrice(priceDetails.priceValue),
                          style: TextStyle(
                            fontSize: 16.sp, // تصغير حجم النص
                            color: isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.backgroundColorIconBack(isDarkMode),
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTextStyles.Cairo,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h), // تصغير الحشو
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10), // تصغير الزوايا
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16.sp,
                            color: Colors.grey), // تصغير حجم الأيقونة
                        SizedBox(width: 6.w), // تقليل المسافة
                        Text(
                          'بدون سعر'.tr,
                          style: TextStyle(
                            fontSize: 14.sp, // تصغير حجم النص
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
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), // تصغير الحشو
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20), // تصغير الزوايا
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6, // تقليل التظليل
            spreadRadius: 0.5, // تقليل الانتشار
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16.sp, color: color ?? Colors.white), // تصغير حجم الأيقونة
          SizedBox(width: 5.w), // تقليل المسافة
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp, // تصغير حجم النص
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.Cairo,
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
    final controller = Get.find<HomeController>();

    controller.setSelectedPost(post);

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

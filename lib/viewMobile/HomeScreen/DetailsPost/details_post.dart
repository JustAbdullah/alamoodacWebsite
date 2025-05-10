import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/LoadingController.dart';
import '../../../controllers/PromotedAdController.dart';
import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/data/model/PromotedAd.dart';
import '../../../core/data/model/post.dart';
import '../../../customWidgets/custom_image_malt.dart';
import '../../../viewsDeskTop/homeDeskTop/DetailsPostDeskTop/show_auc_desktop.dart';
import '../../Auth/login_screen.dart';
import 'add_bid.dart';
import 'add_comment.dart';
import 'comment_show.dart';
import 'rate_post_screen.dart';
import 'top_section_details_post.dart';

class PostDetails extends StatelessWidget {
  PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    final textColor = AppColors.textColor(isDark);
    final cardColor = AppColors.cardColor(isDark);
    final backgroundColor = AppColors.backgroundColor(isDark);
    final borderColor = AppColors.borderColor(isDark);
    HomeController controller = Get.find<HomeController>();
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: backgroundColor,
            child: Column(
              children: [
                TopSectionDetailsPost(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: controller.scrollController, // ربط الكونترولر

                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ConstrainedBox(
                      // أضف هذا
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // مهم جدًا
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(context, controller),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // أضف هذا
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTitleSection(controller, textColor),
                                SizedBox(height: 12.h),
                                _buildCategoryBreadcrumbs(
                                    controller, textColor, cardColor),
                                _buildRatingSection(
                                    controller, textColor, context, isDark),
                                SizedBox(height: 2.h),
                                _buildSponsoredPostsSection(),
                                SizedBox(height: 2.h),
                                _buildExpandableSections(
                                    context,
                                    controller,
                                    themeController,
                                    textColor,
                                    cardColor,
                                    borderColor,
                                    isDark),
                                if (_isAuctionPost(controller))
                                  Column(
                                    children: [
                                      _buildAuctionSection(
                                          controller,
                                          cardColor,
                                          borderColor,
                                          isDark,
                                          textColor),
                                      _buildBidButton(controller, isDark),
                                    ],
                                  ),
                                SizedBox(height: 2.h),
                                _buildSectionCard(
                                    title: "ناشر المنشور",
                                    content: _buildPublisherInfo(
                                        controller, textColor, themeController),
                                    cardColor: cardColor,
                                    borderColor: borderColor,
                                    isDark: isDark,
                                    textColor: textColor),
                                _buildPublisher(),
                                _buildCommentsSection(controller, textColor,
                                    cardColor, borderColor, isDark),
                                _buildCommentButton(isDark),
                              ],
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
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, HomeController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: ConstrainedBox(
        // أضف هذا
        constraints: BoxConstraints(
          minHeight: 350.h,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: ImagesViewer(
          images: controller.selectedPost.value!.images.split(','),
        ),
      ),
    );
  }

  Widget _buildTitleSection(HomeController controller, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                controller.postTitle,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: AppTextStyles.DinarOne,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildViewCounter(controller, textColor),
          ],
        ),
        Divider(color: textColor.withOpacity(0.2), height: 24.h),
        ElevatedButton.icon(
            onPressed: () {
              controller.sharePost(controller.selectedPost.value?.id ?? 0);
            },
            icon: const Icon(Icons.share, color: Colors.white),
            label: Text(
              "مشاركة".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // اللون الأخضر الأساسي

              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
            )),
      ],
    );
  }

  Widget _buildRatingSection(HomeController controller, Color textColor,
      BuildContext context, final isDark) {
    final LoadingController loadingController = Get.find();

    final rating =
        double.tryParse(controller.selectedPost.value!.rating) ?? 0.0;
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor(isDark).withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "التقييم العام".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppTextStyles.DinarOne,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildRatingBadge(rating, textColor),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                _buildStarRating(fullStars, hasHalfStar),
              ],
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                  icon: Icon(Icons.star_rate_rounded,
                      color: AppColors.yellowColor, size: 18.sp),
                  label: Text(
                    "أضف تقييمك".tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.blueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    backgroundColor: AppColors.cardColor(isDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: AppColors.blueDark.withOpacity(0.3)),
                    ),
                  ),
                  onPressed: () {
                    if (loadingController.currentUser == null) {
                      // عرض Snackbar إذا لم يتم العثور على بيانات المستخدم
                      Get.snackbar(
                        '', // اترك العنوان فارغًا لأنك ستستخدم titleText
                        '',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        titleText: Text(
                          "ليس لديك الإذن".tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        messageText: Text(
                          'لاتستطيع القيام بهذه العملية قم بتسجيل دخولك اولاً'
                              .tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.DinarOne,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        mainButton: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.backgroundColorIconBack(
                                Get.find<ThemeController>()
                                    .isDarkMode
                                    .value), // لون الخلفية
                            foregroundColor: Colors.white, // لون النص
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // شكل الزر
                            ),
                          ),
                          onPressed: () {
                            // التوجيه إلى شاشة تسجيل الدخول
                            Get.to(LoginScreen());
                          },
                          child: Text(
                            'تسجيل الدخول'.tr,
                            style: TextStyle(
                              fontFamily: AppTextStyles.DinarOne,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                      );
                    } else {
                      RatePostSheet.show(
                        context,
                        controller.selectedPost.value!.id,
                        rating,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(double rating, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)),
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.star_rounded, color: AppColors.yellowColor, size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildStarRating(int fullStars, bool hasHalfStar) {
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star_rounded,
              color: AppColors.yellowColor, size: 20.sp);
        } else if (hasHalfStar && index == fullStars) {
          return Icon(Icons.star_half_rounded,
              color: AppColors.yellowColor, size: 20.sp);
        } else {
          return Icon(Icons.star_border_rounded,
              color: AppColors.yellowColor.withOpacity(0.3), size: 20.sp);
        }
      }),
    );
  }

  Widget _buildViewCounter(HomeController controller, Color textColor) {
    return Row(
      children: [
        Text(
          controller.selectedPost.value!.views,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppTextStyles.DinarOne,
            color: textColor.withOpacity(0.8),
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.remove_red_eye,
            size: 19.sp, color: textColor.withOpacity(0.8)),
      ],
    );
  }

  Widget _buildCategoryBreadcrumbs(
      HomeController controller, Color textColor, Color backGround) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 7.h,
      children: [
        _buildBreadcrumbItem(controller.categoryName, textColor, backGround),
        _buildBreadcrumbItem(controller.subcategoryName, textColor, backGround),
        _buildBreadcrumbItem(
            controller.subcategoryLevelTwoName, textColor, backGround),
      ],
    );
  }

  Widget _buildBreadcrumbItem(String text, Color color, Color backGround) {
    return Chip(
      label: Text(text),
      backgroundColor: backGround.withOpacity(0.1),
      labelStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.balckColorTypeFour,
        fontFamily: AppTextStyles.DinarOne,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildExpandableSections(
    BuildContext context,
    HomeController controller,
    ThemeController theme,
    Color textColor,
    Color cardColor,
    Color borderColor,
    final isDark,
  ) {
    return Column(
      children: [
        _buildSectionCard(
            title: "التفاصيل العامة",
            content: _buildGeneralDetails(controller, textColor),
            cardColor: cardColor,
            borderColor: borderColor,
            isDark: isDark,
            textColor: textColor),
        _buildSectionCard(
            title: "التفاصيل الإضافية",
            content: _buildAdditionalDetails(controller, textColor),
            cardColor: cardColor,
            borderColor: borderColor,
            isDark: isDark,
            textColor: textColor),
        _buildSectionCard(
            title: "الموقع الجغرافي",
            content: _buildLocationMap(controller),
            cardColor: cardColor,
            borderColor: borderColor,
            isDark: isDark,
            textColor: textColor),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    required Color cardColor,
    required Color borderColor,
    required bool isDark,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor.withOpacity(0.15),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            spreadRadius: 1.5,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 18.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 18.w,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    title.tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            // Dynamic Divider
            Container(
              margin: EdgeInsets.symmetric(vertical: 14.h),
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    borderColor.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Content Section
            DefaultTextStyle.merge(
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 16.sp,
                color: textColor.withOpacity(0.85),
                height: 1.5,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralDetails(HomeController controller, Color textColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final details = controller.selectedPost.value!.details
            .where((d) => d.detailName != "تفاصيل اضافية")
            .toList();

        return details.isEmpty
            ? _buildEmptyState("لا توجد تفاصيل متوفرة".tr)
            : Wrap(
                runSpacing: 10.h,
                children: details.map((detail) {
                  final isPrice = detail.detailName == "السعر";
                  final translated = detail.translations.first;
                  final value = isPrice
                      ? controller
                          .getConvertedPrice(translated.translatedDetailValue)
                      : translated.translatedDetailValue;

                  return Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: textColor.withOpacity(isPrice ? 0.06 : 0.03),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            translated.translatedDetailName,
                            style: TextStyle(
                              fontSize: 16.5.sp,
                              color: textColor.withOpacity(0.75),
                              fontFamily: AppTextStyles.DinarOne,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            value,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: isPrice ? 18.sp : 16.5.sp,
                              color: isPrice
                                  ? AppColors.backgroundColorIconBack(
                                      Get.find<ThemeController>()
                                          .isDarkMode
                                          .value)
                                  : textColor,
                              fontFamily: AppTextStyles.DinarOne,
                              fontWeight:
                                  isPrice ? FontWeight.w800 : FontWeight.w700,
                              letterSpacing: isPrice ? 0.8 : 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
            fontFamily: AppTextStyles.DinarOne,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationMap(HomeController controller) {
    return SizedBox(
      height: 140.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              double.tryParse(controller.selectedPost.value?.lat) ?? 0.0,
              double.tryParse(controller.selectedPost.value?.lon) ?? 0.0,
            ),
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    double.tryParse(controller.selectedPost.value?.lat) ?? 0.0,
                    double.tryParse(controller.selectedPost.value?.lon) ?? 0.0,
                  ),
                  child: Icon(Icons.location_on,
                      color: AppColors.redColor, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetails(HomeController controller, Color textColor) {
    final details = controller.selectedPost.value!.details
        .where((d) => d.detailName == "تفاصيل اضافية")
        .toList();

    return details.isEmpty
        ? _buildEmptyState("لا توجد تفاصيل إضافية".tr)
        : Column(
            children: details
                .map((detail) => Text(
                      detail.translations.first.translatedDetailValue,
                      style: TextStyle(fontSize: 16.sp, color: textColor),
                    ))
                .toList(),
          );
  }

  Widget _buildAuctionSection(HomeController controller, Color cardColor,
      Color borderColor, final isDark, final textColor) {
    return Column(
      children: [
        _buildSectionCard(
            title: "المزاد".tr,
            content: AuctionDetailsScreenDeskTop(),
            cardColor: cardColor,
            borderColor: borderColor,
            isDark: isDark,
            textColor: textColor),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildCommentsSection(HomeController controller, Color textColor,
      Color cardColor, Color borderColor, bool isDark) {
    return ConstrainedBox(
        // أضف هذا
        constraints: BoxConstraints(
          minHeight: 200.h,
          maxHeight: 400.h,
        ),
        child: Stack(
          children: [
            _buildSectionCard(
              title: "التعليقات والردود".tr,
              content: Column(
                children: [
                  // إضافة تأثير زجاجي للمحتوى
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: CommentShow(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
              cardColor: cardColor.withOpacity(0.9),
              borderColor: borderColor.withOpacity(0.2),
              isDark: isDark,
              textColor: textColor,
            ),

            // زر الإضافة العائم
            Positioned(
              bottom: -20.h,
              left: 0,
              right: 0,
              child: _buildCommentButton(isDark),
            ),
          ],
        ));
  }

  Widget _buildCommentButton(bool isDark) {
    return Transform.translate(
      offset: Offset(0, 20.h),
      child: InkWell(
        onTap: () {
          Get.find<HomeController>().showTheComment.value = true;
          Get.to(() => AddComment());
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton.icon(
              icon: Icon(Icons.add_comment_rounded,
                  size: 22.sp, color: Colors.white),
              label: Text(
                "أضافة تعليق جديد".tr,
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontFamily: AppTextStyles.DinarOne,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: Colors.white.withOpacity(0.3), width: 1),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Get.find<HomeController>().showTheComment.value = true;
                Get.to(() => AddComment());
              }),
        ),
      ),
    );
  }

  Widget _buildBidButton(HomeController controller, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: ElevatedButton.icon(
          icon: Icon(Icons.gavel, size: 20.sp, color: Colors.white),
          label: Text(
            "بدء المزايدة".tr,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontFamily: AppTextStyles.DinarOne,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blueDark,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          onPressed: () {
            controller.showTheBid.value = true;
            Get.to(() => AddBid());
          }),
    );
  }

  bool _isAuctionPost(HomeController controller) {
    return int.parse(controller.selectedPost.value!.categoryId) == 8;
  }

  String _getCurrency(detail) {
    try {
      final currencyDetail = detail.translations.firstWhere(
        (translation) => translation.translatedDetailName == "العملة",
      );
      return currencyDetail.translatedDetailValue;
    } catch (e) {
      return "دينار"; // افتراضيًا نستخدم الدينار إذا لم يتم العثور على العملة
    }
  }

// دالة لتنسيق السعر مع العملة
  String _formatPrice(String priceValue, String currency) {
    if (currency.toLowerCase().contains("دولار")) {
      return "\$$priceValue"; // إذا كانت العملة دولار
    } else {
      return "$priceValue دينار"; // إذا كانت العملة دينار
    }
  }
}

///////////////////////////
Widget _buildPublisherInfo(
    HomeController controller, Color textColor, ThemeController theme) {
  final store = controller.selectedPost.value!.store;
  final currentLang = Get.locale?.languageCode ?? 'ar';
  final isCommercial = store.accountType == 'commercial';
  final isRTL = currentLang == 'ar';

  // 1. التحقق من وجود البيانات الأساسية
  final hasTranslations = store.translations.isNotEmpty;
  final mainTranslation = hasTranslations
      ? store.translations.firstWhere(
          (t) => t.language == currentLang,
          orElse: () => store.translations.first,
        )
      : null;

  // 2. التحقق من توفر بيانات الاتصال
  final hasContactInfo = store.phoneNumber.isNotEmpty ||
      store.whatsappNumber.isNotEmpty ||
      store.website.isNotEmpty;

  // 3. التحقق من وجود صور الشركة
  final hasCompanyImages = isCommercial &&
      store.companyImages != null &&
      store.companyImages!.isNotEmpty;

  // 4. التحقق من وجود بيانات وسائل التواصل الاجتماعي
  final hasSocialMedia = _hasSocialMedia(store);

  return Directionality(
    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: AppColors.cardColor(theme.isDarkMode.value),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: isCommercial
                  ? AppColors.backgroundColorIconBack(theme.isDarkMode.value)
                  : Colors.grey[600],
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCommercial ? Icons.store_rounded : Icons.person_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    isCommercial ? 'نشاط تجاري معتمد'.tr : 'مستخدم عادي'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                if (store.image != null && store.image.isNotEmpty)
                  _buildPublisherHero(store, isCommercial),

                // Title & Description
                if (hasTranslations && mainTranslation != null)
                  _buildTitleAndDescription(store, mainTranslation, textColor),

                // Commercial Details
                if (isCommercial && hasTranslations)
                  _buildCommercialDetailsSection(
                      store, mainTranslation!, textColor),

                // Contact Section
                if (hasContactInfo)
                  _buildContactSection(store, textColor, isRTL),

                // Social Media
                if (hasSocialMedia)
                  _buildSocialMediaSection(store, textColor, isRTL),

                // Gallery
                if (hasCompanyImages)
                  if (store.accountType == 'commercial' &&
                      store.companyImages != null &&
                      store.companyImages!.isNotEmpty)
                    _buildImageGallerySection(store.companyImages!)
                  else if (store.image != null && store.image!.isNotEmpty)
                    _buildImageGallerySection(store.image),
              ].where((child) => child != null).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPublisherHero(Store store, bool isCommercial) {
  final bool hasCompanyImages = isCommercial &&
      store.companyImages != null &&
      store.companyImages!.isNotEmpty;

  final bool hasUserImage = store.image != null && store.image!.isNotEmpty;

  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      // 1. خلفية النشاط التجاري (للحسابات التجارية فقط مع صور)
      if (isCommercial && hasCompanyImages)
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  store.companyImages!.split(',')[0],
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
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
            ),
          ),
        ),

      // 2. خلفية افتراضية للحسابات العادية
      if (!isCommercial)
        Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),

      // 3. صورة البروفايل لجميع الحسابات (إذا كانت موجودة)
      if (hasUserImage)
        Positioned(
          bottom: -10.h,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundImage: CachedNetworkImageProvider(store.image!),
            ),
          ),
        ),

      // 4. أيقونة افتراضية للحسابات العادية بدون صورة
      if (!isCommercial && !hasUserImage)
        Positioned(
          bottom: 20.h,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: Colors.white, width: 4.w),
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                size: 70.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
    ],
  );
}

Widget _buildTitleAndDescription(
    Store store, StoreTranslation translation, Color textColor) {
  return Padding(
    padding: EdgeInsets.only(top: 50.h),
    child: Column(
      children: [
        Text(
          translation.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: AppTextStyles.DinarOne,
          ),
        ),
        if (store.accountType == 'commercial' &&
            translation.description.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              translation.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: textColor.withOpacity(0.85),
                height: 1.5,
                fontFamily: AppTextStyles.DinarOne,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _buildCommercialDetailsSection(
    Store store, StoreTranslation translation, Color textColor) {
  final companySummary = translation.companySummary?.isNotEmpty ?? false
      ? translation.companySummary!
      : 'لا توجد معلومات متاحة'.tr;

  final companySpecialization =
      translation.companySpecialization?.isNotEmpty ?? false
          ? translation.companySpecialization!
          : 'غير محددة'.tr;

  return Column(
    children: [
      SizedBox(height: 25.h),
      _buildDetailCard(
        icon: Icons.business_center,
        title: 'نبذة عن النشاط'.tr,
        content: companySummary,
        textColor: textColor,
      ),
      SizedBox(height: 15.h),
      _buildDetailCard(
        icon: Icons.star_rate_rounded,
        title: 'التخصصات الرئيسية'.tr,
        content: companySpecialization,
        textColor: textColor,
      ),
      if (translation.workingHours != null &&
          translation.workingHours!.isNotEmpty)
        _buildWorkingHoursSection(translation.workingHours!, textColor),
    ],
  );
}

Widget _buildWorkingHoursSection(String hours, Color textColor) {
  final timeSlots = hours.split('\n').where((t) => t.isNotEmpty).toList();
  if (timeSlots.isEmpty) return SizedBox.shrink();

  return Padding(
    padding: EdgeInsets.only(top: 20.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time_filled,
                size: 28.sp,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            SizedBox(width: 12.w),
            Text(
              'أوقات العمل الرسمية'.tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        ...timeSlots.map((time) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle,
                      size: 10.sp,
                      color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value)),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: textColor.withOpacity(0.9),
                        fontFamily: AppTextStyles.DinarOne,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    ),
  );
}

Widget _buildContactSection(Store store, Color textColor, bool isRTL) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 25.h),
      Text(
        'طرق التواصل المباشر'.tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: AppTextStyles.DinarOne,
        ),
      ),
      SizedBox(height: 20.h),
      Wrap(
        spacing: 15.w,
        runSpacing: 15.h,
        children: [
          if (store.phoneNumber.isNotEmpty)
            _buildContactTile(
              icon: Icons.phone_android_rounded,
              label: store.phoneNumber,
              onTap: () => _launchUrl('tel:${store.phoneNumber}'),
            ),
          if (store.whatsappNumber.isNotEmpty)
            _buildContactTile(
              icon: Icons.wallet,
              label: '${'واتساب'.tr}${store.whatsappNumber}',
              onTap: () => _launchUrl('https://wa.me/${store.whatsappNumber}'),
            ),
          if (store.website.isNotEmpty)
            _buildContactTile(
              icon: Icons.language_rounded,
              label: 'زيارة الموقع الرسمي'.tr,
              isLink: true,
              onTap: () => _launchUrl(store.website),
            ),
        ],
      ),
    ],
  );
}

Widget _buildContactTile({
  required IconData icon,
  required String label,
  bool isLink = false,
  required Function() onTap,
}) {
  return Material(
    borderRadius: BorderRadius.circular(12.r),
    color: AppColors.backgroundColorIconBack(
            Get.find<ThemeController>().isDarkMode.value)
        .withOpacity(0.08),
    child: InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 24.sp,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: isLink
                    ? AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    : null,
                decoration: isLink ? TextDecoration.underline : null,
                fontFamily: AppTextStyles.DinarOne,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSocialMediaSection(Store store, Color textColor, bool isRTL) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 25.h),
      Text(
        'وسائل التواصل الاجتماعي'.tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: AppTextStyles.DinarOne,
        ),
      ),
      SizedBox(height: 20.h),
      Wrap(
        spacing: 15.w,
        runSpacing: 15.h,
        children: [
          if (store.facebookLink.isNotEmpty)
            _buildSocialMediaButton(
              icon: Icons.facebook_rounded,
              label: 'فيسبوك'.tr,
              url: store.facebookLink,
              color: Color(0xFF1877F2),
              isRTL: isRTL,
            ),
          if (store.instagramLink.isNotEmpty)
            _buildSocialMediaButton(
              icon: Icons.camera_alt_rounded,
              label: 'إنستجرام'.tr,
              url: store.instagramLink,
              color: Color(0xFFE1306C),
              isRTL: isRTL,
            ),
          if (store.youtubeLink != null)
            _buildSocialMediaButton(
              icon: Icons.youtube_searched_for_rounded,
              label: 'يوتيوب'.tr,
              url: store.youtubeLink!,
              color: Color(0xFFFF0000),
              isRTL: isRTL,
            ),
        ],
      ),
    ],
  );
}

Widget _buildSocialMediaButton({
  required IconData icon,
  required String label,
  required String url,
  required Color color,
  required bool isRTL,
}) {
  return Material(
    borderRadius: BorderRadius.circular(12.r),
    color: color.withOpacity(0.1),
    child: InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => _launchUrl(url),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: isRTL
              ? [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(icon, color: color, size: 24.sp),
                ]
              : [
                  Icon(icon, color: color, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTextStyles.DinarOne,
                    ),
                  ),
                ],
        ),
      ),
    ),
  );
}

Widget _buildImageGallerySection(String? images) {
  if (images == null || images.isEmpty) return SizedBox.shrink();

  final imageList = images.split(',').where((img) => img.isNotEmpty).toList();
  if (imageList.isEmpty) return SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 25.h),
      Text(
        'معرض الصور'.tr,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          fontFamily: AppTextStyles.DinarOne,
        ),
      ),
      SizedBox(height: 15.h),
      SizedBox(
        height: 220.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          separatorBuilder: (_, __) => SizedBox(width: 15.w),
          itemBuilder: (context, index) => _buildGalleryItem(imageList, index),
        ),
      ),
    ],
  );
}

Widget _buildGalleryItem(List<String> images, int index) {
  final isLast = index == images.length - 1;
  final remaining = images.length - 3;

  return GestureDetector(
    onTap: () => _showFullScreenGallery(images, index),
    child: Container(
      width: 280.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: CachedNetworkImageProvider(images[index]),
          fit: BoxFit.cover,
        ),
      ),
      child: isLast && remaining > 0
          ? Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  '+$remaining',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
              ),
            )
          : null,
    ),
  );
}

void _showFullScreenGallery(List<String> images, int initialIndex) {
  final filteredImages = images.where((img) => img.isNotEmpty).toList();
  if (filteredImages.isEmpty) return;

  Get.to(
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28.sp),
          onPressed: () => Get.toNamed('/mobile'),
        ),
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: filteredImages.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) => InteractiveViewer(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: filteredImages[index],
              fit: BoxFit.contain,
              progressIndicatorBuilder: (_, __, progress) =>
                  CircularProgressIndicator(
                value: progress.progress,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
              ),
              errorWidget: (_, __, ___) => Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _launchUrl(String url) async {
  final parsedUrl = Uri.parse(url);
  if (await canLaunchUrl(parsedUrl)) {
    await launchUrl(
      parsedUrl,
      mode: LaunchMode.externalApplication,
    );
  } else {
    Get.snackbar(
      'خطأ'.tr,
      'تعذر فتح الرابط'.tr,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }
}

bool _hasSocialMedia(Store store) {
  return store.facebookLink.isNotEmpty ||
      store.instagramLink.isNotEmpty ||
      (store.youtubeLink != null && store.youtubeLink!.isNotEmpty);
}

Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String content,
  required Color textColor,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value)
          .withOpacity(0.06),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 32.sp,
            color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: AppTextStyles.DinarOne,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor.withOpacity(0.85),
                  height: 1.6,
                  fontFamily: AppTextStyles.DinarOne,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/////
Widget _buildSponsoredPostsSection() {
  final themeController = Get.find<ThemeController>();
  return Container(
    height: 280.h,
    padding: EdgeInsets.symmetric(vertical: 5.h),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.03),
          AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.01),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 22.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "المنشورات الممولة".tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: AppTextStyles.DinarOne,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Carousel Section
        Expanded(
          child: GetBuilder<PromotedadController>(
            builder: (controller) {
              if (controller.loadingAds.value) return _buildSponsoredShimmer();
              if (controller.adsList.isEmpty) return _buildEmptyState();

              return _SponsoredPostsCarousel(adsList: controller.adsList);
            },
          ),
        ),
      ],
    ),
  );
}

class _SponsoredPostsCarousel extends StatefulWidget {
  final List<PromotedAd> adsList;

  const _SponsoredPostsCarousel({required this.adsList});

  @override
  __SponsoredPostsCarouselState createState() =>
      __SponsoredPostsCarouselState();
}

class __SponsoredPostsCarouselState extends State<_SponsoredPostsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: 0,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.adsList.isEmpty) return;
      if (_currentPage >= widget.adsList.length - 1) {
        _pageController.jumpToPage(0);
      } else {
        _currentPage++;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final homeController = Get.find<HomeController>();

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.adsList.length,
      padEnds: false,
      onPageChanged: (index) => _currentPage = index,
      itemBuilder: (context, index) {
        final post = widget.adsList[index].post;
        final priceDetails = _getPriceDetails(post);

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double pageOffset = _pageController.position.haveDimensions
                ? (_pageController.page! - index)
                : 0.0;
            return Transform.scale(
              scale: 1 - (pageOffset.abs() * 0.1),
              child: Opacity(
                opacity: (1 - pageOffset.abs()).clamp(0.8, 1.0),
                child: Container(
                  width: 240.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.backgroundColorIconBack(
                                  Get.find<ThemeController>().isDarkMode.value)
                              .withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      shadowColor: AppColors.backgroundColorIconBack(
                              Get.find<ThemeController>().isDarkMode.value)
                          .withOpacity(0.2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          homeController.setSelectedPost(post);
                          homeController.scrollToTop(); // إضافة هذه الدالة
                          Get.toNamed(
                            '/post-mobile/${post.id}', // المسار مع المعلمة الديناميكية
                            arguments: post, // إرسال الكائن كامل
                          );
                        },
                        child: Stack(
                          children: [
                            // Image with Gradient
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 160.h,
                                    width: double.infinity,
                                    child: ImagesViewer(
                                      fullWidth: true,
                                      images: post.images.split(','),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Promoted Badge
                            Positioned(
                              top: 12.h,
                              left: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColorIconBack(
                                      Get.find<ThemeController>()
                                          .isDarkMode
                                          .value),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
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
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppTextStyles.DinarOne,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Card Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  color: themeController.isDarkMode.value
                                      ? Colors.black.withOpacity(0.6)
                                      : Colors.white.withOpacity(0.9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      post.translations.first.title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppTextStyles.DinarOne,
                                        color: AppColors.textColor(
                                            themeController.isDarkMode.value),
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    // Price and Rating
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (priceDetails.hasPrice &&
                                              priceDetails.priceValue != '0')
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                        .backgroundColorIconBack(
                                                            Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                homeController
                                                    .getConvertedPrice(
                                                        priceDetails
                                                            .priceValue),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors
                                                      .backgroundColorIconBack(
                                                          Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                          // Rating
                                          Row(
                                            children: [
                                              Icon(Icons.star_rounded,
                                                  color: Colors.amber,
                                                  size: 16.sp),
                                              SizedBox(width: 4.w),
                                              Text(
                                                post.rating,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  PriceDetails _getPriceDetails(Post post) {
    try {
      final priceDetail = post.details.firstWhere(
        (detail) => detail.detailName == "السعر",
      );
      return PriceDetails(
        priceValue: priceDetail.detailValue,
        hasPrice: priceDetail.detailValue.isNotEmpty &&
            priceDetail.detailValue != '0',
      );
    } catch (e) {
      return PriceDetails(priceValue: '', hasPrice: false);
    }
  }
}

Widget _buildSponsoredShimmer() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 3,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    itemBuilder: (context, index) => Container(
      width: 240.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 160.w,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20.h,
                        width: 80.w,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 20.h,
                        width: 60.w,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.campaign_rounded,
            size: 40.sp,
            color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.5)),
        SizedBox(height: 12.h),
        Text(
          'لا توجد إعلانات ممولة حالياً'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textColor(
                Get.find<ThemeController>().isDarkMode.value),
          ),
        ),
      ],
    ),
  );
}

class PriceDetails {
  final String priceValue;
  final bool hasPrice;

  PriceDetails({required this.priceValue, required this.hasPrice});
}

/////////......منشورات ذات صلة للناشر.........../////
Widget _buildPublisher() {
  final controller = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();
  return Container(
    height: 280.h,
    padding: EdgeInsets.symmetric(vertical: 5.h),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.03),
          AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.01),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.oragne,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 22.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "منشورات الناشر".tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: AppTextStyles.DinarOne,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Carousel Section
        Expanded(
          child: Obx(
            () {
              if (controller.loadingPublisherData.value)
                return _buildShimmerPublisher();
              if (controller.PublisherListList.isEmpty)
                return _buildEmptyStatePublisher();

              return _PublisherPosts(
                  PublisherList: controller.PublisherListList);
            },
          ),
        ),
      ],
    ),
  );
}

class _PublisherPosts extends StatefulWidget {
  final List<Post> PublisherList;

  const _PublisherPosts({required this.PublisherList});

  @override
  ___PublisherPostsState createState() => ___PublisherPostsState();
}

class ___PublisherPostsState extends State<_PublisherPosts> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: 0,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.PublisherList.isEmpty) return;
      if (_currentPage >= widget.PublisherList.length - 1) {
        _pageController.jumpToPage(0);
      } else {
        _currentPage++;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final homeController = Get.find<HomeController>();

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.PublisherList.length,
      padEnds: false,
      onPageChanged: (index) => _currentPage = index,
      itemBuilder: (context, index) {
        final post = widget.PublisherList[index];
        final priceDetails = _getPriceDetails(post);

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double pageOffset = _pageController.position.haveDimensions
                ? (_pageController.page! - index)
                : 0.0;
            return Transform.scale(
              scale: 1 - (pageOffset.abs() * 0.1),
              child: Opacity(
                opacity: (1 - pageOffset.abs()).clamp(0.8, 1.0),
                child: Container(
                  width: 240.w,
                  margin: EdgeInsets.only(right: 2.w),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Card(
                      elevation: 8,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          homeController.setSelectedPost(post);

                          Get.toNamed(
                            '/post-mobile/${post.id}', // المسار مع المعلمة الديناميكية
                            arguments: post, // إرسال الكائن كامل
                          );
                        },
                        child: Stack(
                          children: [
                            // Image with Gradient
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 160.h,
                                    width: double.infinity,
                                    child: ImagesViewer(
                                      fullWidth: true,
                                      images: post.images.split(','),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Promoted Badge

                            // Card Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  color: themeController.isDarkMode.value
                                      ? Colors.black.withOpacity(0.6)
                                      : Colors.white.withOpacity(0.9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      post.translations.first.title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppTextStyles.DinarOne,
                                        color: AppColors.textColor(
                                            themeController.isDarkMode.value),
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    // Price and Rating
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (priceDetails.hasPrice &&
                                              priceDetails.priceValue != '0')
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                        .backgroundColorIconBack(
                                                            Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                homeController
                                                    .getConvertedPrice(
                                                        priceDetails
                                                            .priceValue),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors
                                                      .backgroundColorIconBack(
                                                          Get.find<
                                                                  ThemeController>()
                                                              .isDarkMode
                                                              .value),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                          // Rating
                                          Row(
                                            children: [
                                              Icon(Icons.star_rounded,
                                                  color: Colors.amber,
                                                  size: 16.sp),
                                              SizedBox(width: 4.w),
                                              Text(
                                                post.rating,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  PriceDetails _getPriceDetails(Post post) {
    try {
      final priceDetail = post.details.firstWhere(
        (detail) => detail.detailName == "السعر",
      );
      return PriceDetails(
        priceValue: priceDetail.detailValue,
        hasPrice: priceDetail.detailValue.isNotEmpty &&
            priceDetail.detailValue != '0',
      );
    } catch (e) {
      return PriceDetails(priceValue: '', hasPrice: false);
    }
  }
}

Widget _buildShimmerPublisher() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 3,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    itemBuilder: (context, index) => Container(
      width: 240.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 160.w,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20.h,
                        width: 80.w,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 20.h,
                        width: 60.w,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildEmptyStatePublisher() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.campaign_rounded,
            size: 40.sp,
            color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.5)),
        SizedBox(height: 12.h),
        Text(
          'لا توجد منشورات لهذا الناشر  حالياً'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textColor(
                Get.find<ThemeController>().isDarkMode.value),
          ),
        ),
      ],
    ),
  );
}

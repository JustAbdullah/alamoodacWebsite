
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // استيراد حزمة collection
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../core/localization/changelanguage.dart';
import '../../customWidgets/custom_image_malt.dart';
import 'package:intl/intl.dart' as intl;

class UsersPosts extends StatefulWidget {
  const UsersPosts({super.key});

  @override
  _UsersPostsState createState() => _UsersPostsState();
}

class _UsersPostsState extends State<UsersPosts> {
  String _getFormattedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final currentLocale = Get.locale?.languageCode;
      // استخدم الإنجليزية إذا كانت اللغة غير مدعومة (مثل الكردية)
      final effectiveLocale = (currentLocale == 'ar') ? 'ar' : 'en';
      return intl.DateFormat("dd MMM yyyy, hh:mm a", effectiveLocale).format(date);
    } catch (e) {
      return intl.DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now());
    }
  }

  final controller = Get.find<Userdahsboardcontroller>();
  final scontroller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.LoadingPosts.value) {
        return _buildSkeletonLoader();
      } else if (controller.postsList.isEmpty) {
        return _buildEmptyState();
      } else {
        return _buildPostsList();
      }
    });
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              )
            ],
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

  Widget _buildPostsList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: List.generate(
          controller.postsList.length,
          (index) {
            final post = controller.postsList[index];
            final images = post.images.split(',');
            final priceDetails = _getPriceDetails(post);
            final extraDetails = _getExtraDetails(post);
            return _buildPostCard(post, images, priceDetails, extraDetails);
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(
    Post post,
    List<String> images,
    PriceDetails priceDetails,
    String extraDetails,
  ) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode.value;
    final formattedDate = _getFormattedDate(post.createdAt);

    // الحصول على ترجمة المنشور باللغة الكردية
    final postTranslation = post.translations.firstWhereOrNull((t) => t.language ==  Get.find<ChangeLanguageController>().currentLocale.value.languageCode);
    final postTitle = postTranslation?.title?.toString() ?? "عنوان غير متوفر".tr;

    // الحصول على ترجمة المدينة
    final cityTranslation = post.city.translations.firstWhereOrNull((t) => t.language ==   Get.find<ChangeLanguageController>().currentLocale.value.languageCode);
    final cityName = (post.city.slug.trim().isEmpty)
        ? "الموقع غير متوفر".tr
        : (cityTranslation?.name ?? post.city.slug);

    // الحصول على ترجمة القسم الفرعي
    final subCategoryTranslation = post.subcategory.translations.firstWhereOrNull((t) => t.language ==  Get.find<ChangeLanguageController>().currentLocale.value.languageCode);
    final subCategoryName = subCategoryTranslation?.name ?? post.subcategory.slug;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      child: Material(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showPostDetails(post),
              splashColor: AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.1),
              highlightColor: AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.05),
              child: _buildImageSection(post),
            ),
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postTitle,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontFamily: AppTextStyles.DinarOne,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.grey[800],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 17.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 120.w),
                        child: Text(
                          cityName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: priceDetails.hasPrice
                              ? (isDarkMode
                                  ? AppColors.yellowColor.withOpacity(0.2)
                                  : AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.1))
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              priceDetails.hasPrice ? Icons.currency_lira_rounded : Icons.info_outline_rounded,
                              size: 20.sp,
                              color: priceDetails.hasPrice ? AppColors.textColor(isDarkMode) : Colors.grey,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              priceDetails.hasPrice
                                  ? Get.find<HomeController>().getConvertedPrice(priceDetails.priceValue)
                                  : 'بدون سعر'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: AppTextStyles.DinarOne,
                                fontWeight: FontWeight.w700,
                                color: priceDetails.hasPrice ? AppColors.textColor(isDarkMode) : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.h),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.deletePost(post.id);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: AppColors.redColor, size: 20.sp),
                                onPressed: () {
                                  controller.deletePost(post.id);
                                },
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "حذف المنشور",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppTextStyles.DinarOne,
                                  fontWeight: FontWeight.w700,
                                  color: priceDetails.hasPrice ? AppColors.textColor(isDarkMode) : Colors.grey,
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildImageSection(Post post) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            height: 320.h,
            width: double.infinity,
            child: ImagesViewer(images: post.images.split(',')),
          ),
        ),
        Positioned(
          bottom: 6.h,
          left: 6.w,
          child: _buildInfoBadge(Icons.remove_red_eye, post.views.toString()),
        ),
        Positioned(
          bottom: 6.h,
          right: 6.w,
          child: _buildInfoBadge(Icons.star_rate_rounded, post.rating, color: Colors.amber),
        ),
      ],
    );
  }

  Widget _buildInfoBadge(IconData icon, String value, {Color? color}) {
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

  void _showPostDetails(Post post) {
    final HomeController homeController = Get.find<HomeController>();
    homeController.setSelectedPost(post);
    homeController.showDetailsPost.value = true;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add_rounded,
            size: 80.sp,
            color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.5),
          ),
          SizedBox(height: 20.h),
          Text(
            "عذرًا، لا توجد منشورات لعرضها".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(Get.find<ThemeController>().isDarkMode.value),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            "يمكنك البدء بإنشاء منشور جديد الآن".tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.balckColorTypeFour.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
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

  final hasPrice = priceDetail.detailValue.isNotEmpty && priceDetail.detailValue != '0';
  return PriceDetails(
    priceValue: hasPrice ? priceDetail.detailValue : '',
    hasPrice: hasPrice,
  );
}

String _getExtraDetails(Post post) {
  final extraDetail = post.details.firstWhere(
    (d) => d.detailName == "تفاصيل اضافية",
    orElse: () => Detail(
      id: 0,
      postId: '',
      detailName: '',
      detailValue: '',
      translations: [],
    ),
  );
  return extraDetail.detailValue;
}

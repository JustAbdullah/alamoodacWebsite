import 'package:alamoadac_website/viewMobile/OnAppPages/on_app_pages%20-%20Copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/post.dart';
import '../../core/localization/changelanguage.dart';
import '../../customWidgets/custom_image_malt.dart';
import 'package:intl/intl.dart' as intl;

import '../Settings/show_packages.dart';

class UsersPosts extends StatefulWidget {
  const UsersPosts({super.key});

  @override
  _UsersPostsState createState() => _UsersPostsState();
}

class _UsersPostsState extends State<UsersPosts> {
  String _getFormattedDate(String dateString) {
    if (dateString.isEmpty) return "غير محدد";
    try {
      final date = DateTime.parse(dateString);
      final currentLocale = Get.locale?.languageCode;
      final effectiveLocale = (currentLocale == 'ar') ? 'ar' : 'en';
      return intl.DateFormat("dd MMM yyyy, hh:mm a", effectiveLocale).format(date);
    } catch (e) {
      return "غير محدد";
    }
  }

  final controller = Get.find<Userdahsboardcontroller>();
  final scontroller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.LoadingPosts.value) {
        return _buildSkeletonLoader();
      } else if (controller.postsList.isEmpty) {
        return _buildEmptyState();
      } else {
        return _buildHorizontalPostsList();
      }
    });
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, index) => Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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

  Widget _buildHorizontalPostsList() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: controller.postsList.length,
            itemBuilder: (context, index) {
              final post = controller.postsList[index];
              final images = post.images.split(',');
              final priceDetails = _getPriceDetails(post);
              final extraDetails = _getExtraDetails(post);
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: _buildPostCard(post, images, priceDetails, extraDetails),
              );
            },
          ),
        ),
        SizedBox(height: 15.h),
        _buildScrollHint(),
      ],
    );
  }

  Widget _buildScrollHint() {
    final isRTL = Get.locale?.languageCode == 'ar';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isRTL) ...[
          Icon(Icons.arrow_back_ios, size: 18.sp, color: Colors.grey),
          SizedBox(width: 5.w),
        ],
        Text(
          "قم بالتمرير ${isRTL ? 'يسارًا' : 'يمينًا'} لمشاهدة المزيد".tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        if (isRTL) ...[
          SizedBox(width: 5.w),
          Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
        ]
      ],
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
    final expiresDate = post.expires_at != null && post.expires_at!.isNotEmpty
        ? _getFormattedDate(post.expires_at!)
        : null;

    // حالة المنشور
    final statusInfo = _getPostStatusInfo(post.is_show);

    // الحصول على ترجمة المنشور
    final postTranslation = post.translations.firstWhereOrNull(
      (t) => t.language == Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
    );
    final postTitle = postTranslation?.title?.toString() ?? "عنوان غير متوفر".tr;

    // الحصول على ترجمة المدينة
    final cityTranslation = post.city.translations.firstWhereOrNull(
      (t) => t.language == Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
    );
    final cityName = (post.city.slug.trim().isEmpty)
        ? "الموقع غير متوفر".tr
        : (cityTranslation?.name ?? post.city.slug);

    // الحصول على ترجمة القسم الفرعي
    final subCategoryTranslation = post.subcategory.translations.firstWhereOrNull(
      (t) => t.language == Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
    );
    final subCategoryName = subCategoryTranslation?.name ?? post.subcategory.slug;

    return Material(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showPostDetails(post),
        splashColor: AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.1),
        highlightColor: AppColors.backgroundColorIconBack(isDarkMode).withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(post, statusInfo),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // حالة المنشور مع توضيح مفصل
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: statusInfo.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: statusInfo.color.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              statusInfo.icon,
                              size: 22.sp,
                              color: statusInfo.color,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    statusInfo.title,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontFamily: AppTextStyles.DinarOne,
                                      color: statusInfo.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (statusInfo.description.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        statusInfo.description,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // عنوان المنشور
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
                      SizedBox(height: 16.h),

                      // معلومات التاريخ
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        title: "تاريخ النشر:".tr,
                        value: formattedDate,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 10.h),

                      // تاريخ انتهاء العرض
                      if (expiresDate != null)
                        Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.timer_outlined,
                              title: "تاريخ انتهاء العرض:".tr,
                              value: expiresDate,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "بعد هذا التاريخ سيتم إخفاء المنشور تلقائيًا".tr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.orange,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                      )
                      else if (post.is_show == "1")
                        _buildInfoRow(
                          icon: Icons.all_inclusive,
                          title: "مدة العرض:".tr,
                          value: "لا يوجد تاريخ انتهاء - العرض دائم".tr,
                          isDarkMode: isDarkMode,
                        ),

                      // الموقع والفئة
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              icon: Icons.location_on,
                              value: cityName,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildInfoChip(
                              icon: Icons.category,
                              value: subCategoryName,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // السعر
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              priceDetails.hasPrice ? Icons.currency_lira_rounded : Icons.money_off,
                              size: 24.sp,
                              color: priceDetails.hasPrice ? AppColors.primaryColor : Colors.grey,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              priceDetails.hasPrice
                                  ? Get.find<HomeController>().getConvertedPrice(priceDetails.priceValue)
                                  : 'بدون سعر'.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: AppTextStyles.DinarOne,
                                fontWeight: FontWeight.w700,
                                color: priceDetails.hasPrice ? AppColors.primaryColor : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // قسم التجديد للحالة المخفية
                      if (post.is_show == "2")
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.visibility_off,
                                        size: 22.sp,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "المنشور مخفي حالياً".tr,
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "انتهت فترة عرض هذا المنشور ولم يعد مرئياً للجمهور. يمكنك تجديد فترة العرض لاستمرار الظهور في النتائج.".tr,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {    final settingsController = Get.put(Settingscontroller());

                                     homeController.isChosedMenu();
                              Get.offNamed(
                                '/settings-mobile', // المسار مع المعلمة الديناميكية
                                // إرسال الكائن كامل
                              ); settingsController.showPack.value = true;
                            Get.to(() => ShowPackages());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "تجديد فترة العرض".tr,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: AppTextStyles.DinarOne,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),

                      // زر الحذف
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => controller.deletePost(post.id),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "حذف المنشور".tr,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: AppTextStyles.DinarOne,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء قسم الصورة مع الحالة
  Widget _buildImageSection(Post post, PostStatusInfo statusInfo) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            height: 180.h,
            width: double.infinity,
            child: ImagesViewer(images: post.images.split(',')),
          ),
        ),
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: statusInfo.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusInfo.icon,
                  size: 18.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  statusInfo.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: _buildInfoBadge(Icons.remove_red_eye, post.views.toString()),
        ),
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: _buildInfoBadge(Icons.star_rate_rounded, post.rating, color: Colors.amber),
        ),
      ],
    );
  }

  // بناء بادج المعلومات
  Widget _buildInfoBadge(IconData icon, String value, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color ?? Colors.white),
          SizedBox(width: 4.w),
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

  // بناء صف المعلومات
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // بناء شريحة المعلومات
  Widget _buildInfoChip({
    required IconData icon,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: Colors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.grey[700],
              ),
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

  // معلومات حالة المنشور
  PostStatusInfo _getPostStatusInfo(String status) {
    switch (status) {
      case "0":
        return PostStatusInfo(
          title: "قيد المراجعة".tr,
          description: "المنشور قيد المراجعة من قبل الإدارة وسيظهر بعد الموافقة".tr,
          color: Colors.orange,
          icon: Icons.access_time,
        );
      case "1":
        return PostStatusInfo(
          title: "منشور".tr,
          description: "المنشور ظاهر للجمهور".tr,
          color: Colors.green,
          icon: Icons.visibility,
        );
      case "2":
        return PostStatusInfo(
          title: "مخفي".tr,
          description: "انتهت فترة العرض ولم يعد المنشور مرئيًا".tr,
          color: Colors.red,
          icon: Icons.visibility_off,
        );
      default:
        return PostStatusInfo(
          title: "حالة غير معروفة".tr,
          description: "",
          color: Colors.grey,
          icon: Icons.help_outline,
        );
    }
  }
}

class PostStatusInfo {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  PostStatusInfo({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
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
import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../controllers/ThemeController.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/constant/appcolors.dart';
import '../../../../core/data/model/Stores.dart';
import '../../../../core/data/model/post.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../OnAppPages/on_app_pages.dart';

class PublisherDetailsScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final HomeController homeController = Get.find();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final backgroundColor = AppColors.backgroundColor(isDark);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: _buildMasterContainer(homeController, themeController, context),
      );
    });
  }

  Widget _buildMasterContainer(HomeController controller,
      ThemeController themeController, BuildContext context) {
    return Obx(() {
      if (controller.LoadingStorePuscher.value) {
        return _buildLoadingIndicator();
      }

      if (!controller.showStorePusherUser.value ||
          controller.StorePuscherList.isEmpty) {
        return _buildNoDataView(controller, themeController);
      }

      return _buildMainContent(controller, themeController, context);
    });
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.TheMain),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل بيانات الناشر...'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.TheMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataView(
      HomeController controller, ThemeController themeController) {
    final isDark = themeController.isDarkMode.value;
    final textColor = AppColors.textColor(isDark);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(isDark),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(controller, textColor),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off_outlined,
                        size: 80.sp, color: textColor.withOpacity(0.3)),
                    SizedBox(height: 24.h),
                    Text(
                      '⚠️ لا يوجد بيانات لهذا الناشر'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: textColor,
                        fontFamily: AppTextStyles.DinarOne,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'لم يقم الناشر بإضافة معلومات شخصية بعد'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor.withOpacity(0.6),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(HomeController controller,
      ThemeController themeController, BuildContext context) {
    final isDark = themeController.isDarkMode.value;
    final textColor = AppColors.textColor(isDark);
    final cardColor = AppColors.cardColor(isDark);
    final borderColor = AppColors.borderColor(isDark);

    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(controller, textColor),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.StorePuscherList.isNotEmpty) ...[
                    _buildPublisherInfo(controller.StorePuscherList.first,
                        textColor, cardColor, borderColor),
                    SizedBox(height: 24.h),
                    _buildPublisherDescription(
                        controller.StorePuscherList.first, textColor),
                    SizedBox(height: 24.h),
                    _buildPublisherLocation(controller.StorePuscherList.first,
                        textColor, borderColor),
                    SizedBox(height: 24.h),
                    _buildPublisherContact(
                        controller.StorePuscherList.first, textColor, context),
                    SizedBox(height: 24.h),
                    _buildPublisherPosts(
                        controller, textColor, isDark, borderColor),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(HomeController controller, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blueLight.withOpacity(0.1),
              child: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => {Get.to(HomeScreen())}),
            ),
            SizedBox(width: 16.w),
            Text(
              "تفاصيل الناشر".tr,
              style: TextStyle(
                fontSize: 20.sp,
                color: textColor,
                fontFamily: AppTextStyles.DinarOne,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublisherInfo(
      Stores publisher, Color textColor, Color cardColor, Color borderColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.TheMain.withOpacity(0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPublisherLogo(publisher),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    publisher.translations.first.name ?? "بدون اسم".tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: AppTextStyles.DinarOne,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildPublisherMetaInfo(publisher, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublisherLogo(Stores publisher) {
    if (publisher.user?.logo == null || publisher.user!.logo!.isEmpty) {
      return Icon(Icons.person, size: 40.sp, color: AppColors.TheMain);
    }
    return CachedNetworkImage(
      imageUrl: publisher.image,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(color: AppColors.TheMain),
      ),
      errorWidget: (context, url, error) =>
          Icon(Icons.person, size: 40.sp, color: AppColors.TheMain),
      fit: BoxFit.cover,
    );
  }

  Widget _buildPublisherMetaInfo(Stores publisher, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }

  Widget _buildPublisherDescription(Stores publisher, Color textColor) {
    final description = publisher.translations.firstOrNull?.description;

    if (description == null || description.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "وصف الناشر".tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppTextStyles.DinarOne,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherLocation(
      Stores publisher, Color textColor, Color borderColor) {
    final lat = double.tryParse(publisher.latitude ?? '');
    final lng = double.tryParse(publisher.longitude ?? '');

    if (lat == null || lng == null) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            "الموقع على الخريطة".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, lng),
                initialZoom: 15,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(lat, lng),
                      child: Icon(
                        Icons.location_pin,
                        color: AppColors.redColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherContact(
      Stores publisher, Color textColor, BuildContext context) {
    final phone = publisher.phoneNumber;
    final phoneWh = publisher.whatsappNumber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            "طرق التواصل".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (phone == null || phone.isEmpty)
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.redColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.redColor),
                SizedBox(width: 8.w),
                Text(
                  "لا يوجد رقم تواصل متاح".tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.redColor,
                  ),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.phone, color: AppColors.blueDark),
                  label: Text("اتصال".tr),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: BorderSide(color: AppColors.blueDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _makePhoneCall(context, phone),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.chat, color: Colors.green),
                  label: Text("واتساب".tr),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _launchWhatsApp(
                    context,
                    phoneWh,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPublisherPosts(
    HomeController controller,
    Color textColor,
    bool isDark,
    Color borderColor,
  ) {
    if (controller.postsListStore.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Text(
            "لا يوجد منشورات متاحة حالياً".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            "منشورات الناشر".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppTextStyles.DinarOne,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.postsListStore.length,
            itemBuilder: (context, index) {
              final post = controller.postsListStore[index];
              return _buildPublisherPostItem(
                  post, textColor, isDark, borderColor, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherPostItem(Post post, Color textColor, bool isDark,
      Color borderColor, HomeController controller) {
    final imageUrl = post.images.split(',').firstOrNull;
    final price = _getPostPrice(post);

    return Container(
      width: 160.w,
      margin: EdgeInsets.only(left: 8.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handlePostTap(post, controller),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.cardColor(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: 160.w,
                      height: 120.h,
                      color: AppColors.blueLight.withOpacity(0.1),
                      child: imageUrl == null
                          ? Center(
                              child: Icon(Icons.photo_camera,
                                  size: 40.sp,
                                  color: textColor.withOpacity(0.3)),
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.TheMain,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(Icons.broken_image,
                                    color: textColor.withOpacity(0.3)),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 6.h,
                    left: 6.w,
                    child: _buildInfoBadge(
                      Icons.remove_red_eye,
                      post.views.toString(),
                      textColor: textColor,
                    ),
                  ),
                  Positioned(
                    bottom: 6.h,
                    right: 6.w,
                    child: _buildInfoBadge(
                      Icons.star_rate_rounded,
                      post.rating ?? '0.0',
                      color: Colors.amber,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.translations.firstOrNull?.title ?? 'بدون عنوان'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: AppTextStyles.DinarOne,
                        color: textColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (price != null && price.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "السعر:".tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                controller.getConvertedPrice(price),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.yellowColor
                                      : AppColors.TheMain,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildInfoBadge(
    IconData icon,
    String value, {
    Color? color,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color ?? Colors.white),
          SizedBox(width: 3.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String? _getPostPrice(Post post) {
    try {
      final priceDetail = post.details.firstWhere(
        (detail) => detail.detailName == "السعر",
      );
      return priceDetail.detailValue;
    } catch (e) {
      return null;
    }
  }

  void _handlePostTap(Post post, HomeController controller) {
    // أضف منطق التعامل مع النقر هنا
    controller.setSelectedPost(post);
    controller.showDetailsPost.value = true;
  }

  // دالة لإجراء مكالمة هاتفية
  Future<void> _makePhoneCall(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رقم الهاتف غير صالح")),
      );
      return;
    }

    // إنشاء رابط الاتصال باستخدام الـ scheme "tel"
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    // التحقق من إمكانية فتح الرابط ثم تنفيذه
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا يمكن فتح الرابط: $callUri")),
      );
    }
  }

// دالة لفتح واتساب مع رقم محدد بدون إذن إضافي
  Future<void> _launchWhatsApp(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رقم الهاتف غير صالح")),
      );
      return;
    }

    // تأكد من إدخال رمز الدولة مسبقًا في الرقم، مثل "966" للمملكة العربية السعودية.
    final String message = Uri.encodeComponent("مرحبًا، أرغب بالتواصل معك");

    // إنشاء رابط واتساب باستخدام الـ scheme "whatsapp://send"
    final Uri whatsappUri =
        Uri.parse("whatsapp://send?phone=$phone&text=$message");

    // التحقق من إمكانية فتح الرابط ثم تنفيذه
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا يمكن فتح واتساب للرابط: $whatsappUri")),
      );
    }
  }
}

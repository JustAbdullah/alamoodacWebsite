import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../controllers/ThemeController.dart';
import '../../../../core/constant/appcolors.dart';
import '../../../../core/data/model/Stores.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/userDahsboardController.dart';
import '../../core/localization/changelanguage.dart';

class InfoPushInUserDashBoardDeskTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.find<Userdahsboardcontroller>();
    return _Body(controller: controller, themeController: themeController);
  }
}

class _Body extends StatelessWidget {
  final Userdahsboardcontroller controller;
  final ThemeController themeController;

  const _Body({required this.controller, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.LoadingStorePuscher.value) return _LoadingIndicator();
      if (controller.StorePuscherList.isEmpty) return _EmptyState();
      return _PublishersList(controller: controller);
    });
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)),
          SizedBox(height: 16.h),
          Text('جاري تحميل البيانات...',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_rounded,
              size: 80.sp, color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 16.h),
          Text('لا توجد حسابات ناشرين',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor(isDark))),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _PublishersList extends StatelessWidget {
  final Userdahsboardcontroller controller;

  const _PublishersList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.fetchStroePuscher(
          Get.find<ChangeLanguageController>()
              .currentLocale
              .value
              .languageCode),
      child: GridView.builder(
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // عدد الأعمدة حسب التصميم
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.8, // تعديل النسبة حسب الحاجة
        ),
        itemCount: controller.StorePuscherList.length,
        itemBuilder: (context, index) {
          return _PublisherCard(publisher: controller.StorePuscherList[index]);
        },
      ),
    );
  }
}

class _PublisherCard extends StatelessWidget {
  final Stores publisher;

  const _PublisherCard({required this.publisher});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    final textColor = AppColors.textColor(isDark);

    return Card(
      color: AppColors.backgroundColor(
          Get.find<ThemeController>().isDarkMode.value),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageHeader(publisher: publisher),
          _ContentSection(publisher: publisher, textColor: textColor),
        ],
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  final Stores publisher;

  const _ImageHeader({required this.publisher});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: CachedNetworkImage(
            imageUrl: publisher.image,
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => Icon(Icons.business, size: 40.sp),
          ),
        ),
        Positioned(
          top: 8.w,
          right: 8.w,
          child: _AccountTypeChip(type: publisher.accountType),
        ),
        Positioned(
          top: 8.w,
          left: 8.w,
          child: _ActionButtons(
            idStore: publisher.id,
            type: publisher.accountType,
          ),
        ),
      ],
    );
  }
}

class _AccountTypeChip extends StatelessWidget {
  final String type;

  const _AccountTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: type == 'commercial'
            ? AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            : Colors.grey[600],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type == 'commercial' ? 'تجاري' : 'شخصي',
        style: TextStyle(
            fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final int idStore;
  final String type;

  const _ActionButtons({required this.idStore, required this.type});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*  _ActionButton(
          icon: Icons.edit,
          color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
          onPressed: () {
            Get.find<AddStorePushController>().idStoretoEdit = idStore;
            Get.find<AddStorePushController>().accountType.value = type;
            print("////////////////////////////////////////////////////");
            print(Get.find<AddStorePushController>().idStoretoEdit);
            print(Get.find<AddStorePushController>().accountType.value);
            print("////////////////////////////////////////////////////");
            print("////////////////////////////////////////////////////");
            print("////////////////////////////////////////////////////");
            Get.find<Userdahsboardcontroller>().isShowEditPusher.value = true;
          },
        ),*/
        SizedBox(width: 6.w),
        _ActionButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: () {
            Get.find<Userdahsboardcontroller>().deleteStore(idStore);
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  void Function()? onPressed;
  _ActionButton(
      {required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(
    BuildContext context,
  ) {
    return CircleAvatar(
      radius: 16.r,
      backgroundColor: color.withOpacity(0.2),
      child: IconButton(
        icon: Icon(icon, size: 18.sp, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final Stores publisher;
  final Color textColor;

  const _ContentSection({required this.publisher, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleSection(publisher: publisher, textColor: textColor),
          SizedBox(height: 8.h),
          _Description(publisher: publisher, textColor: textColor),
          SizedBox(height: 12.h),
          _SocialIcons(publisher: publisher),
        ],
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final Stores publisher;
  final Color textColor;

  const _TitleSection({required this.publisher, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(publisher.translations.first.name,
            style: TextStyle(
                fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        SizedBox(height: 4.h),
        Text(publisher.city.translations.first.name,
            style:
                TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.8))),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final Stores publisher;
  final Color textColor;

  const _Description({required this.publisher, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      publisher.translations.first.description ?? 'لا يوجد وصف',
      style: TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.7)),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SocialIcons extends StatelessWidget {
  final Stores publisher;

  const _SocialIcons({required this.publisher});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (publisher.instagramLink.isNotEmpty)
          _SocialIcon(Icons.camera_alt, Colors.pink, publisher.instagramLink),
        if (publisher.facebookLink.isNotEmpty)
          _SocialIcon(Icons.facebook, Colors.blue, publisher.facebookLink),
        if (publisher.website.isNotEmpty)
          _SocialIcon(Icons.language, Colors.blueGrey, publisher.website),
        if (publisher.whatsappNumber.isNotEmpty)
          _SocialIcon(Icons.wallet, Colors.green,
              'https://wa.me/${publisher.whatsappNumber}'),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String url;

  const _SocialIcon(this.icon, this.color, this.url);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20.sp),
      color: color,
      onPressed: () => _launchURL(url),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
    );
  }
}

Future<void> _launchURL(String url) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    Get.snackbar('خطأ', 'تعذر فتح الرابط', snackPosition: SnackPosition.BOTTOM);
  }
}

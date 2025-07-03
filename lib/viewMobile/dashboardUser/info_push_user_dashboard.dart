import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

// ملفات التحكم
import '../../../../controllers/ThemeController.dart';
import '../../../../controllers/userDahsboardController.dart';
import '../../core/localization/changelanguage.dart';

// النماذج والثوابت
import '../../../../core/constant/appcolors.dart';
import '../../../../core/data/model/Stores.dart';

class InfoPushInUserDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode.value;
    final textColor = AppColors.textColor(isDark);
    return _Body(
      controller: Get.find<Userdahsboardcontroller>(),
      themeController: Get.find<ThemeController>(),
      textColor: textColor,
    );
  }
}

class _Body extends StatelessWidget {
  final Userdahsboardcontroller controller;
  final ThemeController themeController;
  final Color textColor;
  const _Body(
      {required this.controller,
      required this.themeController,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.LoadingStorePuscher.value) return _LoadingIndicator();
      if (controller.StorePuscherList.isEmpty) return _EmptyState();
      return _PublishersList(
        controller: controller,
        textColor: textColor,
      );
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
          CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(
              AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل البيانات...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor(
                      Get.find<ThemeController>().isDarkMode.value),
                ),
          ),
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
  final Color textColor;

  const _PublishersList({required this.controller, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.fetchStroePuscher(
          Get.find<ChangeLanguageController>()
              .currentLocale
              .value
              .languageCode),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عنصرين في كل صف
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 0.75, // تعديل النسبة حسب المحتوى
          mainAxisExtent: 320.h, // تحديد ارتفاع ثابت للعنصر
        ),
        itemCount: controller.StorePuscherList.length,
        itemBuilder: (context, index) {
          return _PublisherCard(
              publisher: controller.StorePuscherList[index],
              textColor: textColor);
        },
      ),
    );
  }
}

class _PublisherCard extends StatelessWidget {
  final Stores publisher;
  final Color textColor;
  const _PublisherCard({required this.publisher, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {/* إضافة التفاعل المطلوب */},
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.backgroundColor(
              Get.find<ThemeController>().isDarkMode.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ImageHeader(publisher: publisher)),
              _ContentSection(publisher: publisher, textColor: textColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  final Stores publisher;

  const _ImageHeader({required this.publisher});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: publisher.image,
            placeholder: (_, __) => Container(
              color: Colors.grey[200],
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5, color: AppColors.primaryColor)),
            ),
            errorWidget: (_, __, ___) => Icon(Icons.business, size: 40.sp),
            fit: BoxFit.cover,
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
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
      ),
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
        color: type == 'commercial' ? AppColors.primaryColor : Colors.grey[600],
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
        _ActionButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: () =>
              Get.find<Userdahsboardcontroller>().deleteStore(idStore),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton(
      {required this.icon, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18.sp, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        splashRadius: 20,
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
    final isDark = Get.find<ThemeController>().isDarkMode.value;

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleSection(
            publisher: publisher,
            textColor: textColor,
          ),
          SizedBox(height: 8.h),
          _Description(
            publisher: publisher,
            textColor: textColor,
          ),
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
    final isDark = Get.find<ThemeController>().isDarkMode.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          publisher.translations.first.name,
          style: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          publisher.city.translations.first.name,
          style: TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.8)),
        ),
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
    final isDark = Get.find<ThemeController>().isDarkMode.value;

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
  final uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) {
    await Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('تعذر فتح الرابط: $url'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
    return;
  }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/Stores.dart';
import '../OnAppPages/on_app_pages.dart';

class ListStores extends StatelessWidget {
  ListStores({super.key});
  final controller = Get.find<Searchcontroller>();
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loadingStores.value) {
        return _buildSkeletonLoader();
      } else if (controller.StoresList.isEmpty) {
        return _buildEmptyState();
      } else {
        return _buildStoresList();
      }
    });
  }

  Widget _buildStoresList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: controller.StoresList.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final store = controller.StoresList[index];
        return _StoreCard(store: store);
      },
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

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 80.sp, color: AppColors.textGrey),
        SizedBox(height: 24.h),
        Text("لا يوجد نتائج".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            )),
        SizedBox(height: 8.h),
        Text("حاول تعديل معايير البحث الخاصة بك".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey.withOpacity(0.8),
            )),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Stores store;
  final themeController = Get.find<ThemeController>();
  final controller = Get.find<Searchcontroller>();

  _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(24.r),
        color: themeController.isDarkMode.value
            ? AppColors.darkCardBackground
            : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () => _navigateToStoreDetails(store, controller),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StoreHeader(store: store),
                SizedBox(height: 16.h),
                _StoreImages(images: store.image.split(',')),
                SizedBox(height: 16.h),
                _StoreInfo(store: store),
                SizedBox(height: 16.h),
                _SocialMediaRow(store: store),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStoreDetails(Stores store, Searchcontroller controller) {
    controller.setSelectedStore(store);
    Get.toNamed(
      '/store-mobile/${store.id}',
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final Stores store;

  const _StoreHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صورة البروفايل
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(store.user.logo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.translations.first.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
              SizedBox(height: 4.h),
              Text(store.translations.first.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ),
        _AccountTypeChip(accountType: store.accountType),
      ],
    );
  }
}

class _AccountTypeChip extends StatelessWidget {
  final String accountType;

  const _AccountTypeChip({required this.accountType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: accountType == 'commercial'
            ? AppColors.primaryColor.withOpacity(0.1)
            : AppColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(
            accountType == 'commercial' ? Icons.business : Icons.person,
            size: 16.sp,
            color: accountType == 'commercial'
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          SizedBox(width: 6.w),
          Text(
            accountType == 'commercial' ? 'تجاري'.tr : 'شخصي'.tr,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: accountType == 'commercial'
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreImages extends StatefulWidget {
  final List<String> images;

  const _StoreImages({required this.images});

  @override
  State<_StoreImages> createState() => _StoreImagesState();
}

class _StoreImagesState extends State<_StoreImages> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (_, index) => ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.backgroundGrey,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.backgroundGrey,
                  child:
                      Icon(Icons.broken_image, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _PageIndicator(
          count: widget.images.length,
          currentIndex: _currentPage,
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: currentIndex == index ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primaryColor
                : AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}

class _StoreInfo extends StatelessWidget {
  final Stores store;

  const _StoreInfo({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (store.accountType == 'commercial') ...[
          _InfoRow(
            icon: Icons.business_center,
            title: 'التخصص'.tr,
            value: store.translations.first.companySpecialization ?? "",
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            icon: Icons.description,
            title: 'نبذة'.tr,
            value: store.translations.first.companySummary ?? "",
          ),
          SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final themeController = Get.find<ThemeController>();

  _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color:
              AppColors.backgroundColorIcon(themeController.isDarkMode.value),
        ),
        SizedBox(width: 8.w),
        Text('$title: ',
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 14.sp,
              color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value),
            )),
        SizedBox(
          width: 200.w,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(themeController.isDarkMode.value),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SocialMediaRow extends StatelessWidget {
  final Stores store;

  const _SocialMediaRow({required this.store});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      children: [
        if (store.instagramLink.isNotEmpty)
          _SocialButton(
            icon: Icons.wallet,
            color: AppColors.instagram,
            onPressed: () => _launchURL(store.instagramLink),
          ),
        if (store.facebookLink.isNotEmpty)
          _SocialButton(
            icon: Icons.facebook,
            color: AppColors.facebook,
            onPressed: () => _launchURL(store.facebookLink),
          ),
        if (store.youtubeLink?.isNotEmpty ?? false)
          _SocialButton(
            icon: Icons.play_circle_filled,
            color: AppColors.youtube,
            onPressed: () => _launchURL(store.youtubeLink!),
          ),
        if (store.linkedinLink?.isNotEmpty ?? false)
          _SocialButton(
            icon: Icons.linked_camera,
            color: AppColors.linkedin,
            onPressed: () => _launchURL(store.linkedinLink!),
          ),
        if (store.website.isNotEmpty)
          _SocialButton(
            icon: Icons.language,
            color: AppColors.primaryColor,
            onPressed: () => _launchURL(store.website),
          ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (!url.startsWith('http')) url = 'https://$url';
    if (await canLaunch(url)) await launch(url);
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 24.sp, color: color),
      ),
    );
  }
}

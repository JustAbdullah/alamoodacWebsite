import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/data/model/category.dart';
import '../../core/localization/changelanguage.dart';

class CategoriesPageWeb extends StatefulWidget {
  const CategoriesPageWeb({super.key});

  @override
  State<CategoriesPageWeb> createState() => _CategoriesPageWebState();
}

class _CategoriesPageWebState extends State<CategoriesPageWeb>
    with AutomaticKeepAliveClientMixin {
  final HomeController controller = Get.find<HomeController>();
  final ThemeController themeController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // احتفظ بالصفحة حية

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ضروري لتفعيل KeepAlive
    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Stack(
            children: [
              _buildCategoriesList(),
              _buildArrow(isLeft: true),
              _buildArrow(isLeft: false),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildArrow({required bool isLeft}) {
    return Positioned(
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      top: 35,
      bottom: 35,
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          width: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
              colors: [
                AppColors.backgroundColor(themeController.isDarkMode.value),
                AppColors.backgroundColor(themeController.isDarkMode.value)
                    .withOpacity(0),
              ],
            ),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                if (!_scrollController.hasClients) return;
                final isRTL = Directionality.of(context) == TextDirection.rtl;

                final offsetChange = (isLeft ? -1 : 1) * 200 * (isRTL ? 1 : -1);

                _scrollController.animateTo(
                  _scrollController.offset + offsetChange,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                );
              },
              icon: Icon(
                isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.backgroundColorIconBack(
                    themeController.isDarkMode.value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 130.h,
      child: Obx(() {
        if (controller.categoriesList.isEmpty &&
            !controller.isLoadingCategories.value) {
          return _buildEmptyState();
        }
        return Skeletonizer(
          enabled: controller.isLoadingCategories.value,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.isLoadingCategories.value
                  ? 17
                  : controller.categoriesList.length,
              itemBuilder: (context, index) {
                if (controller.isLoadingCategories.value) {
                  return _buildSkeletonItem();
                }
                final category = controller.categoriesList[index];
                return _CategoryCard(category: category);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSkeletonItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 70.w,
            height: 14.h,
            color: AppColors.textColor(themeController.isDarkMode.value),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "المعــذرة البيانات حاليًا غير متاحة للعرض ..حاول مجددًا".tr,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: AppTextStyles.DinarOne,
          color: AppColors.accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Category category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovering = false;
  OverlayEntry? _tooltip;
// في الدالة dispose:
  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final translation = widget.category.translations.first;

    _tooltip = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy - 85,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: 240.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translation.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  translation.description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_tooltip!);
  }

  void _hideTooltip() {
    _tooltip?.remove();
    _tooltip = null;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final searchcontroller = Get.find<Searchcontroller>();
    final controller = Get.find<HomeController>();

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _showTooltip(context);
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _hideTooltip();
      },
      child: InkWell(
        onTap: () {
          controller.nameCategories.value =
              widget.category.translations.first.name;
          controller.idCategories.value = widget.category.id.toString();
          controller.fetchSubcategories(
            widget.category.id,
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );
          controller.fetchPostsAll(
            widget.category.id,
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
            null,
            null,
          );

          searchcontroller.subCategories.clear();
          searchcontroller.isChosedAndShowTheSub.value = false;
          searchcontroller
              .fetchSubcategories(
            int.parse(controller.idCategories.value),
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          )
              .then((_) {
            searchcontroller.isChosedAndShowTheSub.value = true;
          });
          searchcontroller.idOfCateSearchBox.value = widget.category.id;
          print("/......................................");
          print(searchcontroller.idOfCateSearchBox.value);
          print("/......................................");
          searchcontroller.detailCarControllers["القسم الرئيسي"]?.text =
              controller.idCategories.value;

          searchcontroller.detailRealestateControllers["القسم الرئيسي"]?.text =
              controller.idCategories.value;

          searchcontroller.isOpenINSubPost.value = true;
          searchcontroller.selectedMainCategory = widget.category.id;

          Get.toNamed(
            '/Category', preventDuplicates: false, // اسمح بتكرار الصفحات
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          transform: Matrix4.identity()..scale(_isHovering ? 1.0 : 0.90),
          child: Column(
            children: [
              Container(
                width: 82.w,
                height: 82.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.15),
                              blurRadius: 20,
                              spreadRadius: 4)
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 73.w,
                      height: 73.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHovering
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                    ),
                    ClipOval(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isHovering ? 74.w : 70.w,
                        height: _isHovering ? 74.h : 70.h,
                        child: CachedNetworkImage(
                          imageUrl: widget.category.image,
                          fit: BoxFit.cover,
                          color: _isHovering
                              ? AppColors.whiteColorTypeOne.withOpacity(0.9)
                              : null,
                          colorBlendMode: BlendMode.modulate,
                          placeholder: (context, url) => Skeletonizer(
                            enabled: true,
                            child: Container(
                              width: 72.w,
                              height: 72.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            size: 72.w,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.category.translations.first.name,
                  key: ValueKey(_isHovering),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppTextStyles.DinarOne,
                    color: _isHovering
                        ? AppColors.primaryColor
                        : AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.w600,
                    shadows: _isHovering
                        ? [
                            Shadow(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 2))
                          ]
                        : [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

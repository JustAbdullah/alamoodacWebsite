import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/PromotedAdController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

import '../../core/localization/changelanguage.dart';
import '../../customWidgets/DropdwondFieldApi.dart';

class ShowAskPromoted extends StatelessWidget {
  const ShowAskPromoted({super.key});

  @override
  Widget build(BuildContext context) {
    final Userdahsboardcontroller userDahsboardController = Get.find();
    final ThemeController themeController = Get.find();
    final Settingscontroller settingsController = Get.find();
    final RxInt selectedPostId = (-1).obs;
    final RxBool isSubmitting = false.obs;

    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: settingsController.showAskToPromotedAd.value
            ? Scaffold(
                body: _buildMainContainer(
                    userDahsboardController,
                    themeController,
                    context,
                    settingsController,
                    selectedPostId,
                    isSubmitting),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildMainContainer(
    Userdahsboardcontroller userDahsboardController,
    ThemeController themeController,
    BuildContext context,
    Settingscontroller controller,
    RxInt selectedPostId,
    RxBool isSubmitting,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeaderSection(themeController, controller),
                  SizedBox(height: 25.h),
                  _buildPromotionHeroSection(themeController),
                  SizedBox(height: 30.h),
                  _buildPostSelectionSection(themeController, selectedPostId),
                  SizedBox(height: 40.h),
                  _buildProcessTimeline(themeController),
                  SizedBox(height: 40.h),
                  _buildActionButtonSection(
                      userDahsboardController,
                      themeController,
                      selectedPostId,
                      isSubmitting,
                      controller),
                  SizedBox(height: 20.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
      ThemeController themeController, Settingscontroller controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCloseIcon(themeController, controller),
            SizedBox(
              width: 15.w,
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                "المنشور الممول".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          "وصل إلى جمهور أوسع وضاعف تفاعل منشوراتك".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            color: AppColors.textColor(themeController.isDarkMode.value)
                .withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseIcon(
      ThemeController themeController, Settingscontroller controller) {
    return InkWell(
      onTap: () {
        controller.showAskToPromotedAd.value = false;
        Get.toNamed(
          '/settings-mobile/', // المسار مع المعلمة الديناميكية
          // إرسال الكائن كامل
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColorIconBack(
                  themeController.isDarkMode.value)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
            Get.find<ChangeLanguageController>()
                        .currentLocale
                        .value
                        .languageCode ==
                    "ar"
                ? ImagesPath.back
                : ImagesPath.arrowLeft,
            width: 24.w,
            height: 24.h,
            color: AppColors.textColor(themeController.isDarkMode.value)),
      ),
    );
  }

  Widget _buildPromotionHeroSection(ThemeController themeController) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorIconBack(
                Get.find<ThemeController>().isDarkMode.value)
            .withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildComparisonPreview(themeController),
          SizedBox(height: 25.h),
          _buildFeatureGrid(),
        ],
      ),
    );
  }

  Widget _buildComparisonPreview(ThemeController themeController) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor(themeController.isDarkMode.value),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child:
                    _buildPostPreview("العرض العادي", false, themeController),
              ),
              Container(
                height: 4.h,
                color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.1),
              ),
              Expanded(
                child:
                    _buildPostPreview("المنشور الممول", true, themeController),
              ),
            ],
          ),
        ),
        Positioned(
          right: 20.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "x3 التفاعل".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostPreview(
      String title, bool isPromoted, ThemeController themeController) {
    return Container(
      padding: EdgeInsets.all(15.w),
      color: isPromoted
          ? AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.08)
          : Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isPromoted
                  ? AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPromoted ? Icons.rocket_launch : Icons.insert_chart,
              color: Colors.white,
              size: 20.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title.tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  isPromoted
                      ? "ظهور مميز في الصفحة الرئيسية".tr
                      : "ظهور عادي مع باقي المنشورات".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 10.sp,
                    color: AppColors.textColor(themeController.isDarkMode.value)
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4, // تم تعديل النسبة لدعم النصوص الأطول
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      children: [
        _buildFeatureItem(
            Icons.visibility, "وضوح أعلى".tr, "زيادة معدلات المشاهدة".tr),
        _buildFeatureItem(
            Icons.groups, "جمهور أوسع".tr, "وصول لمتابعين جدد".tr),
        _buildFeatureItem(
            Icons.attach_money, "تمويل مرن".tr, "سهوله في الطلب وبشكل فوري".tr),
        _buildFeatureItem(
            Icons.schedule, "مدة الترويج".tr, "عالي ويصل لاسابيع او اشهر".tr),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return IntrinsicHeight(
      // يجعل العناصر متساوية الارتفاع
      child: Container(
        margin: EdgeInsets.all(4.w), // هامش خارجي لتجنب الازدحام
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value),
                    size: 22.w),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: AppColors.textColor(
                          Get.find<ThemeController>().isDarkMode.value),
                    ),
                    maxLines: 2, // تحديد الحد الأقصى للأسطر
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 10.5.sp,
                  height: 1.3,
                  color: AppColors.textColor(
                          Get.find<ThemeController>().isDarkMode.value)
                      .withOpacity(0.8),
                ),
                maxLines: 3, // تحديد الحد الأقصى للأسطر
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostSelectionSection(
      ThemeController themeController, RxInt selectedPostId) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.article,
                  color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  size: 24.w),
              SizedBox(width: 12.w),
              Text(
                "اختر المنشور المطلوب".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  fontSize: 18.sp,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          _buildPostItems(),
        ],
      ),
    );
  }

  Widget _buildPostItems() {
    final Userdahsboardcontroller userData = Get.put(Userdahsboardcontroller());
    return DropdownFieldApi(
      label: "المنشور المطلوب".tr,
      items: [
        "غير مدخل".tr,
        ...userData.postsList
            .map((store) => store.translations.first.title)
            .toList(),
      ],
      selectedItem: userData.postsList.isNotEmpty ? "غير مدخل".tr : null,
      onChanged: (value) {
        if (value != "غير مدخل".tr) {
          final selected = userData.postsList.firstWhere(
            (store) => store.translations.first.title == value,
          );
          print(selected.id);
          userData.selectedIdPost.value = selected.id;
          print(userData.selectedIdPost.value);
        }
      },
    );
  }

  Widget _buildProcessTimeline(ThemeController themeController) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimelineStep(Icons.edit, "تقديم الطلب".tr, true),
            _buildTimelineConnector(),
            _buildTimelineStep(Icons.visibility, "مراجعة الإدارة".tr, false),
            _buildTimelineConnector(),
            _buildTimelineStep(Icons.assignment_turned_in, "النتيجة".tr, false),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          "سيتم مراجعة طلبك خلال 24 ساعة وسيتم إشعارك بالنتيجة".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 12.sp,
            color: AppColors.textColor(themeController.isDarkMode.value)
                .withOpacity(0.7),
          ),
        ),
        Text(
          "ملاحظة:تواصل من خلال ايقونة الواتساب العائمة لمعلومات أكثر".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 12.sp,
            color: AppColors.redColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(IconData icon, String text, bool isActive) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.2)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isActive
                ? AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                : Colors.grey,
            size: 24.w,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 10.sp,
            color: isActive
                ? AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                : AppColors.textColor(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector() {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildActionButtonSection(
    Userdahsboardcontroller userData,
    ThemeController themeController,
    RxInt selectedPostId,
    RxBool isSubmitting,
    Settingscontroller controller,
  ) {
    return Obx(
      () => ElevatedButton(
        onPressed: isSubmitting.value
            ? null
            : () async {
                PromotedadController promotedadController =
                    Get.put(PromotedadController());

                if (userData.selectedIdPost.value == null ||
                    userData.selectedIdPost.value == 0) {
                  Get.snackbar(
                    "خطأ".tr,
                    "يرجى اختيار منشور أولاً".tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.backgroundColorIconBack(
                            Get.find<ThemeController>().isDarkMode.value)
                        .withOpacity(0.9),
                    colorText: Colors.white,
                  );
                  return;
                }
                isSubmitting.value = true;
                try {
                  await promotedadController
                      .createAd(userData.selectedIdPost?.value ?? 0);

                  controller.showAskToPromotedAd.value = false;
                } catch (e) {
                } finally {
                  isSubmitting.value = false;
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColorIconBack(
              Get.find<ThemeController>().isDarkMode.value),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.3),
          textStyle: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: isSubmitting.value
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch, size: 24.w),
                  SizedBox(width: 12.w),
                  Text(
                    "اطلب الخدمة الآن".tr,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:alamoadac_website/viewsDeskTop/dashboardUserDeskTop/users_posts_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/subscriptionController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/data/model/Subscription.dart';
import '../../core/data/model/SubscriptionCode.dart';
import '../../core/localization/changelanguage.dart';
import '../SettingsDeskTop/saveAccount/save_account_desktop.dart';
import '../SettingsDeskTop/show_packages_desktop.dart';
import '../SidePopup.dart';
import 'details_post_edit.dart';
import 'info_push_user_dashboard_desktop.dart';

class HomeDashboardUserDeskTop extends StatelessWidget {
  const HomeDashboardUserDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Userdahsboardcontroller());
    final themeController = Get.find<ThemeController>();
    final langController = Get.find<ChangeLanguageController>();
    final subController = Get.put(SubscriptionController());
    final userController = Get.find<LoadingController>();

    controller.fetchPosts(langController.currentLocale.value.languageCode);

    return GetX<Userdahsboardcontroller>(
      builder: (_) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildDashboard(context, controller, themeController,
              subController, userController)),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    Userdahsboardcontroller controller,
    ThemeController themeController,
    SubscriptionController subController,
    LoadingController userController,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundColor(themeController.isDarkMode.value),
            AppColors.backgroundColor(themeController.isDarkMode.value),
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(controller, themeController),
              SliverToBoxAdapter(
                  child: _buildUserInfoSection(
                      userController, themeController, context)),
              SliverToBoxAdapter(
                  child: _buildSubscriptionSection(
                      subController, themeController, context)),
              SliverToBoxAdapter(
                  child: _buildStatsSection(controller, themeController)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 30.h),
                    _buildInfoPush(controller, themeController, context),
                    _buildPostsSection(controller, themeController),
                    const UsersPostsDeskTop(),
                  ]),
                ),
              ),
            ],
          ),
          PostDetailsEdit(),
        ],
      ),
    );
  }

  // قسم معلومات المستخدم الجديد
  Widget _buildUserInfoSection(LoadingController controller,
      ThemeController themeController, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("معلومات الحساب", themeController),
          SizedBox(height: 10.h),
          Container(
            constraints: BoxConstraints(
                maxWidth: 300.w), // حل مشكلة الشدادة على الشاشات الكبيرة
            width: 500.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: themeController.isDarkMode.value
                  ? Colors.grey[900]!.withOpacity(0.5)
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  _buildUserInfoRow(
                    title: "اسم المستخدم",
                    value: controller.currentUser?.name.toString() ?? "",
                    themeController: themeController,
                  ),
                  SizedBox(height: 10.h),
                  _buildSecurityStatus(controller, themeController, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow({
    required String title,
    required String value,
    required ThemeController themeController,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title.tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColorOne(themeController.isDarkMode.value),
              fontSize: 16.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColorOne(themeController.isDarkMode.value),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStatus(LoadingController controller,
      ThemeController themeController, BuildContext context) {
    return Obx(() {
      // الحصول على القيمة الرقمية مع افتراضية 0 إذا كانت null
      final isVerifiedInt = controller.currentUser?.isVerified ?? 0;
      // تحويل القيمة الرقمية إلى boolean
      final isVerified = isVerifiedInt == 1;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "حالة التأمين".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isVerified
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isVerified ? Icons.verified : Icons.warning_amber_rounded,
                      color: isVerified ? Colors.green : Colors.red,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isVerified ? "مؤمن".tr : "غير مؤمن".tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        color: isVerified ? Colors.green : Colors.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isVerifiedInt == 0) ...[
            // استخدام القيمة الرقمية مباشرة للتحقق
            SizedBox(height: 15.h),
            ElevatedButton(
              onPressed: () {
                Get.find<Settingscontroller>().saveAccount.value = true;
                showSidePopup(
                  context: context,
                  child: const SaveAccountDeskTopPage(),
                  widthPercent: 0.30,
                  useSideAlignment: true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                minimumSize: Size(double.infinity, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "بدء التأمين الآن".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ]
        ],
      );
    });
  }

  SliverAppBar _buildAppBar(
      Userdahsboardcontroller controller, ThemeController themeController) {
    return SliverAppBar(
      pinned: true,
      backgroundColor:
          AppColors.backgroundColor(themeController.isDarkMode.value),
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: InkWell(
          onTap: () => Get.back(),
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
        ),
      ),
      expandedHeight: 120.h,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "لوحة التحكم الخـاصة بالمـستخدم".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.backgroundColorIconBack(
                        Get.find<ThemeController>().isDarkMode.value)
                    .withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
            ],
          ),
        ),
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 15.h),
      ),
    );
  }

  Widget _buildSubscriptionSection(SubscriptionController controller,
      ThemeController themeController, BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.subscriptions.isEmpty) {
        return _buildNoSubscriptionCard(themeController, context);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("الاشتراك الحالي".tr, themeController),
            SizedBox(height: 10.h),
            ...controller.subscriptions.map(
                (sub) => _buildSubscriptionCard(sub, themeController, context)),
          ],
        ),
      );
    });
  }

  Widget _buildSubscriptionCard(
      Subscription sub, ThemeController themeController, BuildContext context) {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    final daysRemaining = sub.endDate.difference(DateTime.now()).inDays;
    final canGenerateCodes = sub.allowed_accounts > 0;
    return Container(
      width: 500.w,
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.1),
            AppColors.backgroundColor(themeController.isDarkMode.value)
                .withOpacity(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sub.package.translations.first.translatedName,
                    style: TextStyle(
                      fontFamily: AppTextStyles.DinarOne,
                      color: AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    daysRemaining > 0
                        ? "${'نشط'.tr}($daysRemaining ${'يوم'.tr})"
                        : "منتهي".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: daysRemaining > 0
                      ? AppColors.backgroundColorIconBack(
                          Get.find<ThemeController>().isDarkMode.value)
                      : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildSubscriptionDetailRow("تاريخ البدء".tr, sub.startDate),
            _buildSubscriptionDetailRow("تاريخ الانتهاء".tr, sub.endDate),
            _buildSubscriptionDetailRow(
                "الأقسام المختارة".tr, sub.selectedSections),
            _buildSubscriptionDetailRow(
                "عدد الحسابات الفرعية".tr, sub.allowed_accounts),
            LinearProgressIndicator(
              value: sub.adsLimit > 0 ? sub.usedAds / sub.adsLimit : 0,
              backgroundColor:
                  AppColors.backgroundColor(themeController.isDarkMode.value),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 15.h),
            if (daysRemaining > 0 && daysRemaining <= 30)
              ElevatedButton(
                onPressed: () {/* تجديد الاشتراك */},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value),
                  minimumSize: Size(500.w, 45.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "تجديد الاشتراك".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            if (canGenerateCodes) ...[
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.generating_tokens, size: 20.sp),
                      label: Text("توليد كود جديد".tr),
                      onPressed: () {
                        subscriptionController
                            .generateSubscriptionCode(sub.subscriptionId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColorIconBack(
                            themeController.isDarkMode.value),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.list_alt, size: 20.sp),
                      label: Text("عرض الأكواد".tr),
                      onPressed: () {
                        subscriptionController.fetchCodes(sub.subscriptionId);
                        showSubscriptionCodesDialog(context, sub);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor(
                            themeController.isDarkMode.value),
                        foregroundColor: AppColors.textColor(
                            themeController.isDarkMode.value),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionDetailRow(String title, dynamic value) {
    final themeController = Get.find<ThemeController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(themeController.isDarkMode.value),
              fontSize: 14.sp,
            ),
          ),
          Text(
            value is DateTime
                ? DateFormat('yyyy-MM-dd').format(value)
                : value.toString(),
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              color: AppColors.textColor(themeController.isDarkMode.value)
                  .withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionCard(
      ThemeController themeController, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              .withOpacity(0.1),
          border: Border.all(
              color: AppColors.backgroundColorIconBack(
                      Get.find<ThemeController>().isDarkMode.value)
                  .withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.subscriptions,
                size: 40.sp,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            SizedBox(height: 15.h),
            Text(
              "لايوجد اشتراك نشط".tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "يمكنك الاشتراك الآن للتمتع بمزايا إضافية".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.8),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 15.h),
            ElevatedButton(
              onPressed: () {
                Get.find<Settingscontroller>().showPack.value = true;
                showSidePopup(
                  context: context,
                  child: ShowPackagesDeskTopPage(),
                  widthPercent: 0.30,
                  useSideAlignment: true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value),
                minimumSize: Size(500.w, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "الاشتراك الآن".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
      Userdahsboardcontroller controller, ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("الـمعلومات الــعامة", themeController),
          SizedBox(height: 10.h),
          Text(
            "المعلومات العامة حول لوحة التحكم الخـاصة بك عدد المنشورات,المشاهدات وإلخ.."
                .tr,
            style: _buildDescriptionStyle(themeController),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 500.w,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 15.w,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  title: "عدد المنشورات",
                  value: controller.countOfNumberPostUser.value.toString(),
                  themeController: themeController,
                  icon: Icons.post_add_rounded,
                ),
                _buildStatCard(
                  title: "إجمالي المشاهدات",
                  value: controller.countOfViewPostUser.value.toString(),
                  themeController: themeController,
                  icon: Icons.remove_red_eye_rounded,
                ),
                _buildStatCard(
                  title: "عدد المزادات",
                  value: controller.countOfViewPostAuctionUser.value.toString(),
                  themeController: themeController,
                  icon: Icons.gavel_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(themeController.isDarkMode.value),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: AppColors.balckColorTypeFour.withOpacity(0.5),
          thickness: 1.2,
          endIndent: MediaQuery.of(Get.context!).size.width * 0.4,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required ThemeController themeController,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)
                .withOpacity(0.15),
            AppColors.backgroundColor(themeController.isDarkMode.value)
                .withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 24.sp,
                color: AppColors.backgroundColorIconBack(
                    Get.find<ThemeController>().isDarkMode.value)),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.redColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value)
                    .withOpacity(0.8),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPush(Userdahsboardcontroller controller,
      ThemeController themeController, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("بيـانات النـاشر".tr, themeController),
        SizedBox(height: 10.h),
        Text(
          "بيانات النــاشر الخاص بحــسابك وتعرض عند عرض المنشورات".tr,
          style: _buildDescriptionStyle(themeController),
        ),
        SizedBox(height: 15.h),
        Obx(() {
          return SizedBox(
              width: 500.w,
              height: controller.StorePuscherList.isEmpty ? 250.h : 400.h,
              child: InfoPushInUserDashBoardDeskTop());
        })
      ],
    );
  }

  Widget _buildPostsSection(
      Userdahsboardcontroller controller, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("قائمة المنشورات".tr, themeController),
        SizedBox(height: 10.h),
        Text(
          "قائمة منشوراتك الخاصة التى قمت بنشرها..والحذف".tr,
          style: _buildDescriptionStyle(themeController),
        ),
        SizedBox(height: 15.h),
        _buildToggleButtons(controller, themeController),
      ],
    );
  }

  TextStyle _buildDescriptionStyle(ThemeController themeController) {
    return TextStyle(
      fontFamily: AppTextStyles.DinarOne,
      color: AppColors.textColor(themeController.isDarkMode.value)
          .withOpacity(0.8),
      fontSize: 14.sp,
      height: 1.4,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildToggleButtons(
      Userdahsboardcontroller controller, ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton(
              label: "المنشورات",
              isActive: !controller.isShowPostsOrStores.value,
              onTap: () => controller.isShowPostsOrStores.value = false,
              themeController: themeController),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      {required String label,
      required bool isActive,
      required VoidCallback onTap,
      required ThemeController themeController}) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? AppColors.backgroundColorIconBack(
                  Get.find<ThemeController>().isDarkMode.value)
              : Colors.transparent,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.backgroundColorIconBack(
                            Get.find<ThemeController>().isDarkMode.value)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                label.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: isActive
                      ? Colors.white
                      : AppColors.textColor(themeController.isDarkMode.value),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showSubscriptionCodesDialog(BuildContext context, Subscription sub) async {
  final subscriptionController = Get.put(SubscriptionController());

  await subscriptionController.fetchCodes(sub.subscriptionId);

  Get.dialog(
    Dialog(
      backgroundColor: Get.find<ThemeController>().isDarkMode.value
          ? Colors.grey[900]
          : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        constraints: BoxConstraints(maxHeight: 500.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الأكواد المولدة".tr,
                  style: TextStyle(
                    color: AppColors.textColor(
                        Get.find<ThemeController>().isDarkMode.value),
                    fontFamily: AppTextStyles.DinarOne,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10.h),

            // المحتوى
            Obx(() {
              if (subscriptionController.isLoadingCode.value) {
                return Center(child: CircularProgressIndicator());
              }

              final codes = subscriptionController.codes;

              if (codes.isEmpty) {
                return _buildNoCodesMessage();
              }

              return Expanded(
                child: ListView.separated(
                  itemCount: codes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final code = codes[index];
                    return _buildCodeItem(code);
                  },
                ),
              );
            }),

            SizedBox(height: 15.h),

            // زر الإغلاق
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back),
                label: Text("رجوع".tr),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Widget _buildCodeItem(SubscriptionCode code) {
  final isDark = Get.find<ThemeController>().isDarkMode.value;

  return Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    ),
    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                code.code,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(code.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon:
              Icon(Icons.copy, color: isDark ? Colors.white70 : Colors.black87),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code.code));
            Get.snackbar(
              'تم النسخ'.tr,
              'تم نسخ الكود إلى الحافظة'.tr,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.black87,
              colorText: Colors.white,
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildNoCodesMessage() {
  return Padding(
    padding: EdgeInsets.all(15.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, color: Colors.grey),
        SizedBox(width: 8.w),
        Text(
          'لا توجد أكواد متاحة حالياً'.tr,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    ),
  );
}

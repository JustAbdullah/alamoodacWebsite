import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/LoadingController.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';
import '../../core/data/model/MessageModel.dart';
import '../../core/localization/changelanguage.dart';

class ChoseMessagesDeskTop extends StatelessWidget {
  const ChoseMessagesDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final Settingscontroller settingsController =
        Get.find<Settingscontroller>();
    final LoadingController loadingController = Get.find<LoadingController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isDark = themeController.isDarkMode.value;

    // تحميل الرسائل عند فتح الصفحة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingsController.fetchMessages(
        loadingController.currentUser?.id ?? 0,
      );
    });

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight * 0.92,
        color: AppColors.backgroundColor(isDark),
        child: Column(
          children: [
            _buildHeader(themeController),
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () => settingsController.fetchMessages(
                        loadingController.currentUser?.id ?? 0,
                      ),
                  child: Obx(() {
                    return _buildMessageList(
                        themeController, settingsController);
                  })),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeController themeController) {
    final bool isDark = themeController.isDarkMode.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.find<Settingscontroller>().showMessages.value = false;
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColorIconBack(isDark)
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
                    color: AppColors.textColor(isDark),
                  ),
                ),
              ),
              Text(
                "الرسائل والتنبيهات".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(isDark),
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      ThemeController themeController, Settingscontroller settingsController) {
    final bool isDark = themeController.isDarkMode.value;
    if (settingsController.isLoadingMessages.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // التعديل هنا: استخدام showMessages بدلاً من التحقق من القائمة الفارغة
    if (settingsController.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            "لا توجد رسائل جديدة".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textColor(isDark).withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemCount: settingsController.messages.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
      itemBuilder: (context, index) => _buildMessageItem(
          themeController, settingsController.messages[index], context),
    );
  }

  Widget _buildMessageItem(ThemeController themeController,
      MessageModel message, BuildContext context) {
    final bool isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.email_outlined,
              color: AppColors.primaryColor,
              size: 28.w,
            ),
          ),
          title: Text(
            isArabic ? "رسالة جديدة".tr : "New Message".tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor(themeController.isDarkMode.value),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.h),
              Text(
                isArabic ? message.messageAr : message.messageEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: AppColors.textColor(themeController.isDarkMode.value)
                      .withOpacity(0.9),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14.w, color: Colors.grey),
                  SizedBox(width: 6.w),
                  Text(
                    _formatDate(message.messageDate),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 24.w,
                ),
                onPressed: () => _confirmDelete(context, message.id),
              ),
            ],
          ),
          onTap: () => _showMessageDetails(context, message),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تأكيد الحذف".tr),
        content: Text("هل أنت متأكد من حذف هذه الرسالة؟".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء".tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<Settingscontroller>().deleteMessage(messageId);
            },
            child: Text("حذف".tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showMessageDetails(BuildContext context, MessageModel message) {
    final bool isArabic =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode ==
            "ar";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تفاصيل الرسالة".tr),
        content: SingleChildScrollView(
          child: Text(
            isArabic ? message.messageAr : message.messageEn,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق".tr),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

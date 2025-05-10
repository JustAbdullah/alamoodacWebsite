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

class ChoseMessages extends StatelessWidget {
  const ChoseMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final Settingscontroller settingsController = Get.find();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.92,
        color: AppColors.backgroundColor(themeController.isDarkMode.value),
        child: Column(
          children: [
            // Header Section
            _buildHeader(themeController),

            // Content Section
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => settingsController.fetchMessages(
                  Get.find<LoadingController>().currentUser?.id ?? 0,
                ),
                child: _buildMessageList(themeController, settingsController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
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
                      color: AppColors.textColor(
                          themeController.isDarkMode.value)),
                ),
              ),
              Text(
                "الرسائل والتنبيهات".tr,
                style: TextStyle(
                  fontFamily: AppTextStyles.DinarOne,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40), // للحفاظ على التوازن في التصميم
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      ThemeController themeController, Settingscontroller controller) {
    if (controller.isLoadingMessages.value) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.messages.isEmpty) {
      return Center(
        child: Text(
          "لا توجد رسائل جديدة".tr,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textColor(themeController.isDarkMode.value)
                .withOpacity(0.5),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemCount: controller.messages.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      itemBuilder: (context, index) => _buildMessageItem(
          themeController, controller.messages[index], context),
    );
  }

  Widget _buildMessageItem(ThemeController themeController,
      MessageModel message, BuildContext context) {
    final isArabic =
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
            offset: Offset(0, 3),
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
                icon: Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 24.w),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تفاصيل الرسالة".tr),
        content: Text(
          Get.find<ChangeLanguageController>()
                      .currentLocale
                      .value
                      .languageCode ==
                  "ar"
              ? message.messageAr
              : message.messageEn,
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
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

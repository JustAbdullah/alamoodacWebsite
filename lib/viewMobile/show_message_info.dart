
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/settingsController.dart';
import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';
import 'Settings/createPusher/chose_pusher.dart';

class PublisherInfoDialog extends StatelessWidget {
  const PublisherInfoDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    Settingscontroller settingscontroller = Get.put(Settingscontroller());

    return GetX<HomeController>(
      builder: (controller) => Visibility(
        visible: controller.shouldShowDialog.value,
        child: AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Icon(
            Icons.verified_user_rounded,
            size: 60,
            color: AppColors.TheMain,
          ),
          title: Text(
            'أكمل ملفك الشخصي!'.tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.TheMain,
            ),
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'حتى تظهر معلوماتك عند نشر المنشورات.. يجب عليك إكمال معلومات الناشر'
                  .tr,
              style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                fontSize: 17,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            _buildActionButton(
              text: 'الإكمال الان'.tr,
              isPrimary: true,
              onTap: () async {
                controller.isChosedMenu();
                settingscontroller.showPusher.value = true;
                  Get.to(() => ChosePusher());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.TheMain : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.TheMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: AppColors.TheMain, width: 1),
          ),
          minimumSize: const Size(110, 40),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

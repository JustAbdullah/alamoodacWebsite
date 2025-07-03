import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/appcolors.dart';
import '../../customWidgets/custom_flag.dart';
import '../../customWidgets/custom_logo.dart';
import '../Settings/chose_route.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final Settingscontroller settingsController = Get.find();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الشعار في الزاوية اليسرى العليا
              const CustomLogo(),
              
              // تغيير اللغة في الزاوية اليمنى العليا
              const CustomFlag(),
            ],
          ),
          
          // قسم اختيار الدولة أسفل الشعار
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    homeController.isChosedMenu();
                    Get.offNamed('/settings-mobile');
                    settingsController.showTheRoute.value = true;  
                    Get.to(() => ChoseRoute());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        GetX<HomeController>(
                          builder: (controller) => Text(
                            homeController.selectedRoute.value.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // خط فاصل
          Container(
            height: 1.h,
            margin: EdgeInsets.only(top: 12.h),
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
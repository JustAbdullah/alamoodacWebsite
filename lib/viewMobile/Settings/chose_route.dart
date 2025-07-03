import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

class ChoseRoute extends StatefulWidget {
  const ChoseRoute({super.key});

  @override
  State<ChoseRoute> createState() => _ChoseRouteState();
}

class _ChoseRouteState extends State<ChoseRoute> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final HomeController homeController = Get.find();
    final Settingscontroller settingsController = Get.find();

    return GetX<Settingscontroller>(
      builder: (controller) => Visibility(
        visible: controller.showTheRoute.value,
        child: Scaffold(
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            curve: Curves.easeInOutQuint,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.backgroundColor(themeController.isDarkMode.value).withOpacity(0.96),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  maxWidth:  MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height ,
                ),
                margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                decoration: BoxDecoration(
                  color: themeController.isDarkMode.value 
                      ? Colors.grey[900] 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      // Background Decoration
                     
                      
                      // Content
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 25.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Title with Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 34.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  "اختر الدولة".tr,
                                  style: TextStyle(
                                    fontSize: 23.sp,
           fontFamily: AppTextStyles.DinarOne,                                  fontWeight: FontWeight.bold,
                                    color: themeController.isDarkMode.value 
                                        ? Colors.white 
                                        : AppColors.primaryColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 25.h),
                            
                            // Description
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                "يمكنك اختيار الدولة التي تريد عرض محتواها".tr,
                                style: TextStyle(
                                   fontFamily: AppTextStyles.DinarOne,
                                  fontSize: 17.sp,
                                  height: 1.5,
                                  color: themeController.isDarkMode.value 
                                      ? Colors.grey[400] 
                                      : Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            SizedBox(height: 50.h),
                            
                            // Country Cards - Enhanced Design
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.w,
                                  mainAxisSpacing: 20.h,
                                  childAspectRatio: 0.55,
                                  shrinkWrap: true,
                                  children: [
                                    _buildCountryCard(
                                      countryName: "العراق".tr,
                                      flagAsset: ImagesPath.flagIq,
                                      isSelected: homeController.selectedRoute.value == "العراق",
                                      onTap: () {
                                        homeController.selectedRoute.value = "العراق";
                                        homeController.saveSelectedRoute( homeController.selectedRoute.value);
                                     homeController.loadSelectedRoute();
                                      },
                                      themeController: themeController,
                                    ),
                                    _buildCountryCard(
                                      countryName: "تركيا".tr,
                                      flagAsset: ImagesPath.flagTr,
                                      isSelected: homeController.selectedRoute.value == "تركيا",
                                      onTap: () {
                                        homeController.selectedRoute.value = "تركيا";
                                           homeController.saveSelectedRoute( homeController.selectedRoute.value);
                                     homeController.loadSelectedRoute();
                                      },
                                      themeController: themeController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                         
                          ],
                        ),
                      ),
                      
                      // Close Button (Top Right)
                      Positioned(
                        top: 20.w,
                        right: 20.w,
                        child: GestureDetector(
                          onTap: () {
                            settingsController.showTheRoute.value = false;
                              Get.toNamed(
                                    '/settings-mobile/', // المسار مع المعلمة الديناميكية
                                    // إرسال الكائن كامل
                                  );
                          },
                          child: Container(
                            width: 45.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode.value 
                                  ? Colors.grey[800] 
                                  : Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 26.sp,
                                color: themeController.isDarkMode.value 
                                    ? Colors.white 
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard({
    required String countryName,
    required String flagAsset,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeController themeController,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryColor.withOpacity(0.08) 
              : themeController.isDarkMode.value 
                  ? Colors.grey[850] 
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryColor 
                : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flag with animated selection
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutBack,
                    width: isSelected ? 110.w : 100.w,
                    height: isSelected ? 110.w : 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                     
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Flag with gradient border
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(flagAsset),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: isSelected 
                                  ? AppColors.primaryColor 
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        
                        // Selection indicator
                        if (isSelected)
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Country Name
                  Text(
                    countryName,
                    style: TextStyle(
                       fontFamily: AppTextStyles.DinarOne,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : themeController.isDarkMode.value 
                              ? Colors.white 
                              : Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Selection Indicator
                  if (isSelected)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 1.0 : 0.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "محدد".tr,
                          style: TextStyle( fontFamily: AppTextStyles.DinarOne,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
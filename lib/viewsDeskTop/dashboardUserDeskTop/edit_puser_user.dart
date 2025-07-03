
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // استخدم latlong2 للتعامل مع إحداثيات الخريطة.

import '../../../controllers/ThemeController.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/appcolors.dart';
import '../../../core/constant/images_path.dart';
import '../../../customWidgets/PostDetailsField.dart';
import '../../controllers/AddStorePushController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/userDahsboardController.dart';

class EditPuserUserDeskTop extends StatelessWidget {
  const EditPuserUserDeskTop({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    final ThemeController themeController = Get.find();
    final addstorecontroller = Get.put(AddStorePushController());
    final settingsController = Get.find<Settingscontroller>();
    return GetX<Userdahsboardcontroller>(
        builder: (controller) => Visibility(
            visible: controller.isShowEditPusher.value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isShowEditPusher.value
                  ? Container(
                      key: const ValueKey('info-data'),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: AppColors.backgroundColor(
                          themeController.isDarkMode.value),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 25.h),
                        child: Column(
                          children: [
                            _buildHeader(themeController, settingsController,
                                addstorecontroller),
                            SizedBox(height: 15.h),
                            _buildProgressIndicator(addstorecontroller),
                            Expanded(
                              child: Obx(() {
                                return IndexedStack(
                                  index: addstorecontroller.currentStep.value,
                                  children: [
                                    /*    _buildStep1(addstorecontroller,
                                        themeController, context),*/
                                    _buildStep2(
                                        addstorecontroller, themeController),
                                    _buildStep3(
                                        addstorecontroller, themeController),
                                    _buildStep4(
                                        addstorecontroller, themeController),
                                    _buildStep5(
                                        addstorecontroller, themeController),
                                  ],
                                );
                              }),
                            ),
                            _buildNavigationButtons(
                                addstorecontroller, context),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            )));
  }

  // ------------------ Common Components ------------------
  Widget _buildHeader(
      ThemeController themeController,
      Settingscontroller controller,
      AddStorePushController addstorecontroller) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.find<Userdahsboardcontroller>().isShowEditPusher.value = false;
            addstorecontroller.restValues();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  size: 24.w),
              Text(" العودة".tr,
                  style: TextStyle(
                    fontFamily: AppTextStyles.DinarOne,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontSize: 18.sp,
                  )),
            ],
          ),
        ),
        const Spacer(),
        Image.asset(ImagesPath.logo, width: 50.w, height: 50.h),
      ],
    );
  }

  Widget _buildProgressIndicator(AddStorePushController controller) {
    List<String> stepTitles = ['المعلومات', 'التواصل', 'الموقع', 'المراجعة'];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Obx(() {
              bool isActive = controller.currentStep.value >= index;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                                colors: [
                                    AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                    AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                                  ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)
                            : null,
                        color: !isActive ? Colors.grey[200] : null,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey[600],
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTextStyles.DinarOne,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      stepTitles[index].tr,
                      style: TextStyle(
                        fontFamily: AppTextStyles.DinarOne,
                        fontSize: 12.sp,
                        color: isActive ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
      AddStorePushController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (controller.currentStep.value > 0)
            _buildGradientButton(
              text: 'السابق'.tr,
              onPressed: controller.previousStep,
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[400]!],
              ),
            ),
          _buildGradientButton(
            text: controller.currentStep.value == 4 ? 'تأكيد'.tr : 'التالي'.tr,
            onPressed: () {
              controller.nextStepEdit(context, controller.idStoretoEdit);
            },
            gradient: LinearGradient(
              colors: [AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3)),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontFamily: AppTextStyles.DinarOne)),
      ),
    );
  }

  // ------------------ Step 1: Account Type ------------------
  Widget _buildStep1(AddStorePushController controller,
      ThemeController themeController, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Text("اختر نوع الحساب المناسب".tr,
                style: TextStyle(
                    fontSize: 22.sp,
                    color:
                        AppColors.textColor(themeController.isDarkMode.value),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.DinarOne)),
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              _buildAccountTypeCard(
                  type: 'personal',
                  icon: Icons.person,
                  title: "حساب شخصي".tr,
                  isSelected: controller.accountType.value == 'personal',
                  context: context),
              SizedBox(height: 15.h),
              _buildAccountTypeCard(
                  type: 'commercial',
                  icon: Icons.business,
                  title: "حساب تجاري".tr,
                  isSelected: controller.accountType.value == 'commercial',
                  context: context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeCard(
      {required String type,
      required IconData icon,
      required String title,
      required bool isSelected,
      required BuildContext context}) {
    final Map<String, List<Map<String, dynamic>>> accountFeatures = {
      'personal': [
        {'icon': Icons.person_pin, 'text': 'حساب شخصي خاص بك'},
        {'icon': Icons.share, 'text': 'مشاركة الإعلانات بسهولة'},
        {'icon': Icons.content_copy, 'text': 'إضافة معلومات التواصل'},
        {
          'icon': Icons.social_distance,
          'text': 'روابط لمواقع التواصل الإجتماعي'
        },
      ],
      'commercial': [
        {'icon': Icons.info, 'text': 'معلومات أشمل حول النشاط التجاري'},
        {'icon': Icons.timelapse, 'text': 'أوقات العمل والخدمات المميزة'},
        {'icon': Icons.photo, 'text': 'صور أكثر للخدمات والمنشاة'},
        {'icon': Icons.share, 'text': 'مشاركة الإعلانات بسهولة'},
        {'icon': Icons.content_copy, 'text': 'إضافة معلومات التواصل'},
        {
          'icon': Icons.social_distance,
          'text': 'روابط لمواقع التواصل الإجتماعي'
        },
      ],
    };

    return InkWell(
      onTap: () => Get.find<AddStorePushController>().setAccountType(type),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [
                  AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.1),
                  Colors.white
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              : null,
          color: !isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
          border: Border.all(
            color: isSelected ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    size: 35.w,
                    color: isSelected ? Colors.white : Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              Text(title,
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: isSelected
                          ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)
                          : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.DinarOne)),
              SizedBox(height: 15.h),
              ...accountFeatures[type]!.map((feature) => ListTile(
                    leading: Icon(feature['icon'],
                        size: 22.w,
                        color:
                            isSelected ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.grey),
                    title: Text(feature['text'],
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppTextStyles.DinarOne,
                            color: Colors.grey[700])),
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 10.w,
                  )),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                      color: isSelected ? AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value) : Colors.grey),
                ),
                child: Text(
                  'اختر هذا النوع',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 14.sp,
                    fontFamily: AppTextStyles.DinarOne,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ Step 2: Basic Info ------------------
  Widget _buildStep2(
      AddStorePushController controller, ThemeController themeController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInputField(
            label: "أسم الناشر-المتجر".tr,
            hint: "أدخل الاسم المعروض".tr,
            controller: controller.nameController,
            icon: Icons.store,
          ),
          _buildInputField(
            label: "وصف الناشر-المتجر".tr,
            hint: "وصف مختصر للنشاط".tr,
            controller: controller.descriptionController,
            maxLines: 4,
            icon: Icons.description,
          ),
          if (controller.accountType.value == 'commercial') ...[
            _buildInputField(
              label: "نبذة الشركة".tr,
              hint: "وصف طبيعة عمل الشركة".tr,
              controller: controller.companySummaryController,
              maxLines: 3,
              icon: Icons.business_center,
            ),
            _buildInputField(
              label: "تخصص الشركة".tr,
              hint: "التخصص الرئيسي للشركة".tr,
              controller: controller.companySpecializationController,
              maxLines: 3,
              icon: Icons.category,
            ),
            _buildWorkingHoursField(controller),
          ],
          _buildPhoneField(
            label: "رقم التواصل".tr,
            hint: "7701234567".tr,
            controller: controller.phoneCell,
          ),
          _buildPhoneField(
            label: "رقم الواتساب".tr,
            hint: "7701234567".tr,
            controller: controller.phoneWhatUps,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursField(AddStorePushController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: PostDetailsField(
        label: "⏰ أوقات العمل".tr,
        hint: "مثال: الأحد - الخميس: ٩ صباحًا - ٥ مساءً\nالجمعة: مغلق".tr,
        controller: controller.workingHoursController,
        prefixIcon: Icon(Icons.access_time, color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)),
        maxLines: 3,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5)),
              ],
            ),
            child: PostDetailsField(
              width: 340.w,
              maxLines: maxLines,
              label: label,
              hint: hint,
              controller: controller,
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), size: 22.w)
                  : null,
            )));
  }

  Widget _buildPhoneField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return _buildInputField(
      label: label,
      hint: hint,
      controller: controller,
      icon: Icons.phone,
      maxLines: 1,
    );
  }

  // ------------------ Step 3: Social Media ------------------
  Widget _buildStep3(
      AddStorePushController controller, ThemeController themeController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSocialMediaField(
            label: "فيسبوك".tr,
            hint: "facebook.com/username".tr,
            controller: controller.facebookUrl,
            icon: Icons.facebook,
          ),
          _buildSocialMediaField(
            label: "انستجرام".tr,
            hint: "instagram.com/username".tr,
            controller: controller.instagramUrl,
            iconImage: ImagesPath.instagram,
          ),
          _buildSocialMediaField(
            label: "لينكدإن".tr,
            hint: "linkedin.com/username".tr,
            controller: controller.linkedinUrl,
            icon: Icons.link,
          ),
          _buildSocialMediaField(
            label: "يوتيوب".tr,
            hint: "youtube.com/username".tr,
            controller: controller.youtubeUrl,
            icon: Icons.video_library,
          ),
          _buildSocialMediaField(
            label: "الموقع الإلكتروني".tr,
            hint: "example.com".tr,
            controller: controller.websiteUrl,
            icon: Icons.language,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    String? iconImage,
  }) {
    return _buildInputField(
      label: label,
      hint: hint,
      controller: controller,
      icon: icon,
    );
  }

  // ------------------ Step 4: Media & Location ------------------
  Widget _buildStep4(
      AddStorePushController controller, ThemeController themeController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageSection(controller, themeController),
          SizedBox(height: 20.h),
          _buildMapSection(controller, themeController),
          SizedBox(
            height: 20.h,
          ),
          controller.accountType.value == 'commercial'
              ? _buildImageSectionBuss(controller, themeController)
              : SizedBox(
                  height: 10.h,
                ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
      AddStorePushController controller, ThemeController themeController) {
    return Column(
      children: [
        Text("صور الناشر-المتجر".tr,
            style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        _buildImageUploadCard(controller),
        SizedBox(height: 15.h),
        _buildImageGrid(controller),
      ],
    );
  }

  Widget _buildImageUploadCard(AddStorePushController controller) {
    return InkWell(
      onTap: controller.pickImages,
      child: Container(
        width: 200.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: Colors.white, size: 30.w),
            SizedBox(height: 8.h),
            Text("إضافة صورة".tr,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontFamily: AppTextStyles.DinarOne)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(AddStorePushController controller) {
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1,
          ),
          itemCount: controller.images.length,
          itemBuilder: (context, index) => _buildImageItem(index, controller),
        ));
  }

  Widget _buildImageItem(int index, AddStorePushController controller) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:  Image.memory(
          controller.images[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.edit, size: 18.w),
                  onPressed: () => controller.updateImage(index),
                ),
              ),
              SizedBox(width: 5.w),
              CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.close, size: 18.w),
                  onPressed: () => controller.removeImage(index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////.........../Buss Image........../////////
  Widget _buildImageSectionBuss(
      AddStorePushController controller, ThemeController themeController) {
    return Column(
      children: [
        Text("المزيد من الصور حول نشاطك التجاري".tr,
            style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        _buildImageUploadCardBuss(controller),
        SizedBox(height: 15.h),
        _buildImageGridBuss(controller),
      ],
    );
  }

  Widget _buildImageUploadCardBuss(AddStorePushController controller) {
    return InkWell(
      onTap: controller.pickImagesBuss,
      child: Container(
        width: 200.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value).withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: Colors.white, size: 30.w),
            SizedBox(height: 8.h),
            Text("إضافة صورة".tr,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontFamily: AppTextStyles.DinarOne)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGridBuss(AddStorePushController controller) {
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1,
          ),
          itemCount: controller.imagesBuss.length,
          itemBuilder: (context, index) =>
              _buildImageItemBuss(index, controller),
        ));
  }

  Widget _buildImageItemBuss(int index, AddStorePushController controller) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child:  Image.memory(
          controller.imagesBuss[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.edit, size: 18.w),
                  onPressed: () => controller.updateImageBuss(index),
                ),
              ),
              SizedBox(width: 5.w),
              CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.close, size: 18.w),
                  onPressed: () => controller.removeImageBuss(index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//////////////////////////////////////
  Widget _buildMapSection(
      AddStorePushController controller, ThemeController themeController) {
    return Column(
      children: [
        Text("الموقع الجغرافي".tr,
            style: TextStyle(
                fontFamily: AppTextStyles.DinarOne,
                color: AppColors.textColor(themeController.isDarkMode.value),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Container(
          height: 250.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5)),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Obx(() => controller.latitude.value != null
                ? FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                        controller.latitude.value!,
                        controller.longitude.value!,
                      ),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.alamodac.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 50.w,
                            height: 50.h,
                            point: LatLng(
                              controller.latitude.value!,
                              controller.longitude.value!,
                            ),
                            child: Icon(Icons.location_on,
                                color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), size: 40.w),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off,
                            size: 50.w, color: Colors.grey),
                        Text("لم يتم تحديد الموقع".tr,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                                fontFamily: AppTextStyles.DinarOne)),
                      ],
                    ),
                  )),
          ),
        ),
        SizedBox(height: 15.h),
        Obx(() => controller.isLoadingLocation.value
            ? CircularProgressIndicator(color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value))
            : _buildGradientButton(
                text: "تحديد الموقع الحالي".tr,
                onPressed: () async {
                  await controller.ensureLocationPermission();
                  if (await controller.isLocationServiceEnabled()) {
                    await controller.fetchCurrentLocation();
                  } else {
                    Get.snackbar(
                        "خطأ".tr, "يرجى تفعيل خدمة الموقع الجغرافي".tr);
                  }
                },
                gradient: LinearGradient(
                  colors: [AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value), AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value)],
                ),
              )),
      ],
    );
  }

  // ------------------ Step 5: Review ------------------
  Widget _buildStep5(
      AddStorePushController controller, ThemeController themeController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildReviewItem('نوع الحساب:', controller.accountType.value.tr),
          _buildReviewItem('الاسم:', controller.nameController.text),
          _buildReviewItem('الوصف:', controller.descriptionController.text),
          if (controller.accountType.value == 'commercial') ...[
            _buildReviewItem(
                'نبذة الشركة:', controller.companySummaryController.text),
            _buildReviewItem('تخصص الشركة:',
                controller.companySpecializationController.text),
            _buildReviewItem(
                'أوقات العمل:', controller.workingHoursController.text),
          ],
          _buildReviewItem('رقم التواصل:', "+964 ${controller.phoneCell.text}"),
          _buildReviewItem(
              'رقم الواتساب:', "+964 ${controller.phoneWhatUps.text}"),
          _buildReviewItem('فيسبوك:', controller.facebookUrl.text),
          _buildReviewItem('انستجرام:', controller.instagramUrl.text),
          _buildReviewItem('لينكدإن:', controller.linkedinUrl.text),
          _buildReviewItem('يوتيوب:', controller.youtubeUrl.text),
          _buildReviewItem('الموقع الإلكتروني:', controller.websiteUrl.text),
          _buildReviewItem('الموقع الجغرافي:',
              '${controller.latitude.value?.toStringAsFixed(4)}, ${controller.longitude.value?.toStringAsFixed(4)}'),
          SizedBox(height: 20.h),
          _buildImageGrid(controller),
          _buildTranslatedWorkingHours(controller),
        ],
      ),
    );
  }

  Widget _buildTranslatedWorkingHours(AddStorePushController controller) {
    return Obx(() => Column(
          children: controller.translatedData
              .map((trans) => _buildReviewItem(
                  'أوقات العمل (${trans['lang']}):', trans['working_hours']))
              .toList(),
        ));
  }

  Widget _buildReviewItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.backgroundColorIconBack(Get.find<ThemeController>().isDarkMode.value),
                  fontFamily: AppTextStyles.DinarOne,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value.isEmpty ? 'غير محدد' : value,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    fontFamily: AppTextStyles.DinarOne),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

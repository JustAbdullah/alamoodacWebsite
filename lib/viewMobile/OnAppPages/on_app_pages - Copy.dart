import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ThemeController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/searchController.dart';
import '../../controllers/settingsController.dart';
import '../../controllers/userDahsboardController.dart';
import '../../core/constant/appcolors.dart';
import '../../core/constant/images_path.dart';

import '../AddPostsPage/add_list.dart';

import '../HomeScreen/home_screen.dart';

import '../SearchScreen/search_screen.dart';

import '../Settings/settings.dart';

import '../dashboardUser/home_dashboard_user.dart';

import 'menu.dart';

// تعريف الكونترولرات
final HomeController homeController = Get.find<HomeController>();
final ThemeController themeController = Get.find<ThemeController>();
final Settingscontroller settingscontroller = Get.put(Settingscontroller());
final userdahsboardcontroller = Get.put(Userdahsboardcontroller());

final Searchcontroller searchcontroller = Get.put(Searchcontroller());

class OnAppPages extends StatefulWidget {
  const OnAppPages({super.key});

  @override
  State<OnAppPages> createState() => _OnAppPagesState();
}

class _OnAppPagesState extends State<OnAppPages> {
  final HomeController homeController = Get.find();
  final ThemeController themeController = Get.find();
  final Settingscontroller settingscontroller = Get.find();
  final Searchcontroller searchcontroller = Get.find();

  @override
  void initState() {
    super.initState();
    _precacheResources();
    _enforceImmersiveMode();
  }

  void _precacheResources() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage(ImagesPath.whatsappShare), context);
      // أضف باقي الصور التي تحتاج precaching هنا
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _handleBackButton,
      child: Scaffold(
        backgroundColor: _getBackgroundColor,
        body: const SafeArea(
          child: Stack(
            children: [
              _MainContentSection(),
              _BottomNavigationSection(),
              _FloatingActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Color get _getBackgroundColor =>
      AppColors.backgroundColor(themeController.isDarkMode.value);

  void _handleBackButton(bool didPop) {
    if (didPop) return;
    _resetAllControllers();
    _enforceImmersiveMode();
  }

  void _resetAllControllers() {
    homeController
      ..resetHomeState()
      ..resetSubCategories();
    settingscontroller.resetSettings();
    searchcontroller.resetSearchState();
  }

  static void _enforceImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}

class _MainContentSection extends StatelessWidget {
  const _MainContentSection();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'main_content',
      builder: (controller) {
        return Stack(
          children: [
            const HomeScreen(),
            if (controller.isMenu.value) const SettingsPage(),
            if (controller.isSearch.value) const SearchScreen(),
            if (controller.addPost.value) const AddList(),
            if (userdahsboardcontroller.showDashBoardUser.value)
              const HomeDashboardUser(),
            // أضف باقي الصفحات الشرطية بنفس النمط
          ],
        );
      },
    );
  }
}

class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColors.backgroundColor(
            Get.find<ThemeController>().isDarkMode.value),
        width: MediaQuery.of(context).size.width,
        height: 70.h,
        child: const Menu(),
      ),
    );
  }
}

class _FloatingActionsSection extends StatelessWidget {
  const _FloatingActionsSection();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'floating_actions',
      builder: (controller) {
        return Stack(
          children: [
            Positioned(
              bottom: 70.h,
              right: 20.w,
              child: _AnimatedWhatsappButton(controller: controller),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedWhatsappButton extends StatelessWidget {
  final HomeController controller;

  const _AnimatedWhatsappButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: 400.milliseconds,
      opacity: controller.isWhatsappButtonVisible.value ? 0 : 1,
      child: Semantics(
        button: true,
        label: 'Open WhatsApp',
        child: GestureDetector(
          onTap: controller.launchWhatsApp,
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              ImagesPath.whatsappShare,
              cacheWidth: 256,
              cacheHeight: 256,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}

// تحسينات إضافية على الكونترولرات
extension on HomeController {
  void resetHomeState() {
    isChosedHome();
    restWhenBack();
    showTheSubTwo.value = false;
    showTheSubCategories.value = false;
    subCategories.clear();
  }

  void resetSubCategories() {
    subCategories.clear();
    showTheSubCategories.value = false;
    showTheSubTwo.value = false;
  }
}

extension on Settingscontroller {
  void resetSettings() {
    // أضف هنا عمليات إعادة التعيين للإعدادات
  }
}

extension on Searchcontroller {
  void resetSearchState() {
    idOfCateSearchBox.value = 0;
    isOpenFromSub.value = 0;
    getDataForOneTime.value = false;
    isOpenINSubPost.value = false;
    selectedMainCategory = null;
  }
}

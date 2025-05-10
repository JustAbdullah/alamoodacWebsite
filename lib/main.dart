import 'dart:html' as html;

import 'package:alamoadac_website/Load_new_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';

import 'HomeDeciderView.dart';
import 'controllers/ThemeController.dart';
import 'controllers/home_controller.dart';
import 'controllers/LoadingController.dart';
import 'controllers/searchController.dart';
import 'core/constant/color_primary.dart';
import 'core/localization/AppTranslation.dart';
import 'core/localization/changelanguage.dart';
import 'core/services/appservices.dart';
import 'viewMobile/AddPostsPage/add_list.dart';
import 'viewMobile/HomeScreen/DetailsPost/details_post.dart';
import 'viewMobile/HomeScreen/SubCategories/sub_categories.dart';
import 'viewMobile/HomeScreen/home_screen.dart';
import 'viewMobile/OnAppPages/on_app_pages.dart';
import 'viewMobile/SearchScreen/DetailsStores/details_stroes.dart';
import 'viewMobile/SearchScreen/search_screen.dart';
import 'viewMobile/Settings/settings.dart';
import 'viewMobile/dashboardUser/home_dashboard_user.dart';
import 'viewsDeskTop/AddPageDeskTop/add_list_desktop.dart';
import 'viewsDeskTop/SubCategoriesDeskTop/sub_categories_desktop.dart';
import 'viewsDeskTop/homeDeskTop/DetailsPostDeskTop/details_post_desktop.dart';
import 'viewsDeskTop/homeDeskTop/home_screen_desktop.dart';
import 'viewsDeskTop/searchDeskTop/DetailsStoresDesktop/details_stroes_desktop.dart';
import 'viewsDeskTop/searchDeskTop/search_screen_desktop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الخدمات والكونترولرات
  final appServices = await AppServices.init();
  Get.put(appServices);
  Get.put(ChangeLanguageController());

  // استخدام الاستراتيجيّة الافتراضيّة لبناء سجل التنقل
  setUrlStrategy(PathUrlStrategy());

  // التعامل مع زرّ "رجوع" في المتصفح
  html.window.onPopState.listen((event) {
    // إذا كان هناك Snackbar مفتوح، نغلقه أولاً
    if (Get.isSnackbarOpen) {
      Get.back();
      return;
    }

    // إذا كان بالإمكان الرجوع داخل التطبيق
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      // خلاف ذلك، إعادة التوجيه دوماً إلى واجهة '/Decider'
      Get.offAllNamed('/Decider');
      html.window.history.replaceState({}, '', '/Decider');
    }
  });

  // قفل التدوير بوضع Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langCtrl = Get.find<ChangeLanguageController>();

    // إخفاء شريط النظام وضبط لون شريط الحالة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ModeColor.mode),
    );

    return Obx(() => GetMaterialApp(
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [GetObserver()],
          title: 'على مودك',
          translations: AppTranslation(),
          locale: langCtrl.currentLocale.value,
          fallbackLocale: const Locale('ar'),
          initialBinding: BindingsBuilder(() {
            Get.put(HomeController(), permanent: true);
            Get.put(Searchcontroller(), permanent: true);
            Get.put(ThemeController(), permanent: true);
            Get.put(LoadingController(), permanent: true);
          }),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const LoadTheWeb()),
            GetPage(name: '/Decider', page: () => const HomeDeciderView()),
            GetPage(name: '/desktop', page: () => const HomeScreenDesktop()),
            GetPage(name: '/post/:id', page: () => PostDetailsDeskTop()),
            GetPage(name: '/store/:id', page: () => StoreDetailsDeskTop()),
            GetPage(name: '/Category', page: () => SubCategoriesPageDeskTop()),
            GetPage(name: '/add-post', page: () => AddListDeskTop()),
            GetPage(name: '/search', page: () => SearchScreenDesktop()),

            // مسارات الموبايل
            GetPage(name: '/mobile', page: () => const HomeScreen()),
            GetPage(name: '/post-mobile/:id', page: () => PostDetails()),
            GetPage(name: '/store-mobile/:id', page: () => StoreDetails()),
            GetPage(name: '/category-mobile/', page: () => SubCategoriesPage()),
            GetPage(name: '/search-mobile/', page: () => SearchScreen()),
            GetPage(name: '/add-post-mobile/', page: () => AddList()),
            GetPage(name: '/settings-mobile/', page: () => SettingsPage()),
            GetPage(
                name: '/dashboard-mobile/', page: () => HomeDashboardUser()),
          ],
          theme: ThemeData(primarySwatch: ModeColor.mode),
          builder: (context, child) {
            // توحيد TextScaleFactor على 0.9
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaleFactor: 0.9),
              child: child!,
            );
          },
          routingCallback: (routing) {
            // عند كل تنقل داخلي، استبدال آخر مدخل في التاريخ
            if (routing != null && !routing.isBack!) {
              html.window.history.replaceState({}, '', Get.currentRoute);
            }
          },
        ));
  }
}

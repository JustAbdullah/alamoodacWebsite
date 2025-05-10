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

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    _updateHistory(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _updateHistory(previousRoute);
  }

  void _updateHistory(Route? route) {
    if (route is PageRoute && route.settings.name != null) {
      html.window.history.replaceState(
        {'route': route.settings.name},
        '',
        route.settings.name,
      );
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appServices = await AppServices.init();
  Get.put(appServices);
  Get.put(ChangeLanguageController());

  setUrlStrategy(PathUrlStrategy());
  html.window.history.replaceState({'route': '/'}, '', '/');

  html.window.onPopState.listen((event) {
    final currentRoute = Get.currentRoute;

    if (Get.isSnackbarOpen) {
      Get.back();
      return;
    }

    if (currentRoute == '/Decider') {
      _showExitConfirmation();
    } else {
      _forceRedirectToDecider();
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

void _forceRedirectToDecider() {
  Get.offAllNamed('/Decider');
  html.window.history.replaceState({'route': '/Decider'}, '', '/Decider');
}

void _showExitConfirmation() {
  Get.dialog(
    AlertDialog(
      title: const Text('تأكيد الخروج'),
      content: const Text('هل تريد حقًا الخروج من التطبيق؟'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            html.window.history.pushState(
              {'route': '/Decider'},
              '',
              '/Decider',
            );
          },
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () => html.window.close(),
          child: const Text('خروج'),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langCtrl = Get.find<ChangeLanguageController>();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ModeColor.mode),
    );

    return Obx(() => GetMaterialApp(
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            CustomNavigatorObserver(),
            GetObserver(),
          ],
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

            // صفحات الموبايل
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
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaleFactor: 0.9),
              child: child!,
            );
          },
        ));
  }
}

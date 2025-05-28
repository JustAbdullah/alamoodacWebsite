import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';

import 'HomeDeciderView.dart';
import 'controllers/ThemeController.dart';
import 'controllers/home_controller.dart';
import 'controllers/LoadingController.dart';
import 'controllers/searchController.dart';
import 'core/localization/AppTranslation.dart';
import 'core/localization/changelanguage.dart';
import 'core/services/appservices.dart';
import 'viewMobile/AddPostsPage/add_list.dart';
import 'viewMobile/HomeScreen/DetailsPost/details_post.dart';
import 'viewMobile/HomeScreen/SubCategories/sub_categories.dart';
import 'viewMobile/HomeScreen/home_screen.dart';
import 'viewMobile/SearchScreen/DetailsStores/details_stroes.dart';
import 'viewMobile/SearchScreen/search_screen.dart';
import 'viewMobile/Settings/settings.dart';
import 'viewMobile/dashboardUser/home_dashboard_user.dart';
import 'viewsDeskTop/AddPageDeskTop/add_list_desktop.dart';
import 'viewsDeskTop/SubCategoriesDeskTop/sub_categories_desktop.dart';
import 'viewsDeskTop/homeDeskTop/DetailsPostDeskTop/details_load_link.dart';
import 'viewsDeskTop/homeDeskTop/DetailsPostDeskTop/details_post_desktop.dart';
import 'viewsDeskTop/homeDeskTop/home_screen_desktop.dart';
import 'viewsDeskTop/searchDeskTop/DetailsStoresDesktop/details_stroes_desktop.dart';
import 'viewsDeskTop/searchDeskTop/search_screen_desktop.dart';

class EnhancedNavigatorObserver extends NavigatorObserver {
  static final List<String> _navigationStack = [];
  static String? _initialPath;

  @override
  void didPush(Route route, Route? previousRoute) {
    _handleRouteChange(route, isPush: true);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _handleRouteChange(previousRoute, isPop: true);
  }

  void _handleRouteChange(Route? route,
      {bool isPush = false, bool isPop = false}) {
    if (route is PageRoute && route.settings.name != null) {
      final routeName = _normalizeRoute(route.settings.name!);

      if (isPop && _navigationStack.isNotEmpty) {
        _navigationStack.removeLast();
      } else if (isPush) {
        if (_navigationStack.isEmpty) _navigationStack.add(_initialPath ?? '/');
        if (_navigationStack.last != routeName) _navigationStack.add(routeName);
      }

      _updateBrowserHistory(routeName, isPush: isPush);
    }
  }

  String _normalizeRoute(String path) {
    return path;
  }

  void _updateBrowserHistory(String route, {bool isPush = false}) {
    // معالجة المسار بشكل آمن
    final currentPath = html.window.location.pathname;
    final pathSegments = currentPath?.split('/') ?? [];
    final dynamicId = pathSegments.isNotEmpty ? pathSegments.last : '';

    // استبدال المعلمة الديناميكية
    final browserPath = route.replaceFirst(':id', dynamicId);

    // استخدام التوابع المباشرة بدلاً من المُعامل []
    if (isPush) {
      html.window.history.pushState(
        {
          'type': 'flutter_route',
          'path': route,
          'stack': List<String>.from(_navigationStack)
        },
        '',
        browserPath,
      );
    } else {
      html.window.history.replaceState(
        {
          'type': 'flutter_route',
          'path': route,
          'stack': List<String>.from(_navigationStack)
        },
        '',
        browserPath,
      );
    }
  }

  static void handleBrowserBack(dynamic state) {
    if (state != null && state['type'] == 'flutter_route') {
      final stack = List<String>.from(state['stack'] ?? []);
      if (stack.isNotEmpty) {
        _navigationStack
          ..clear()
          ..addAll(stack);

        final targetRoute = stack.isNotEmpty ? stack.last : _initialPath;
        if (targetRoute != null && Get.currentRoute != targetRoute) {
          Get.offNamedUntil(targetRoute, (route) => false);
        }
      }
    }
  }

  static void initialize(String initialPath) {
    _initialPath = initialPath;
    _navigationStack.add(initialPath);
  }
}

void _forceFullScreen() {
  html.document.documentElement!.style
    ..height = '100%'
    ..width = '100%'
    ..minWidth = '100%'
    ..minHeight = '100%'
    ..margin = '0'
    ..padding = '0'
    ..overflow = 'hidden';

  html.document.body!.style
    ..height = '100%'
    ..width = '100%'
    ..minWidth = '100%'
    ..minHeight = '100%'
    ..margin = '0'
    ..padding = '0'
    ..overflow = 'hidden';
}

Future<void> main() async {
  debugDisableShadows = true;
  WidgetsFlutterBinding.ensureInitialized();
  _forceFullScreen();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  final appServices = await AppServices.init();
  Get.put(appServices);
  Get.put(ChangeLanguageController());

  setUrlStrategy(PathUrlStrategy());

  final initialUri = Uri.parse(html.window.location.href);
  final initialPath = initialUri.path.isEmpty ? '/' : initialUri.path;

  EnhancedNavigatorObserver.initialize(initialPath);
  html.window.history.replaceState({
    'type': 'flutter_route',
    'path': initialPath,
    'stack': [initialPath]
  }, '', initialPath);

  html.window.onPopState.listen((event) {
    EnhancedNavigatorObserver.handleBrowserBack(event.state);
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(initialUri: initialUri));
}

// هنا نقوم بتعديل الروتين الخاص بالروابط العميقة بحيث إذا كان الرابط يبدأ بـ “/post/…” نوجه المستخدم إلى واجهة DetailsLoadLink
class MyApp extends StatelessWidget {
  final Uri initialUri;

  const MyApp({Key? key, required this.initialUri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langCtrl = Get.find<ChangeLanguageController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // إذا كان المسار يحتوي على "post" فهذا يعني أننا دخلنا عبر رابط تفاصيل المنشور
      if (initialUri.pathSegments.length >= 2 &&
          initialUri.pathSegments[0] == 'post') {
        // التوجيه إلى واجهة DetailsLoadLink مع تمرير معرف المنشور كمعامل (arguments)
        Get.offAllNamed('/link', arguments: {'id': initialUri.pathSegments[1]});
      }
    });

    return Obx(() => GetMaterialApp(
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [EnhancedNavigatorObserver()],
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
          // يمكن ترك initialRoute كما هو أو تغييره حسب منطق التطبيق
          initialRoute: '/Decider',
          getPages: [
            GetPage(
              name: '/Decider',
              page: () => const HomeDeciderView(),
              preventDuplicates: false,
            ),
            GetPage(
              name: '/post/:id',
              page: () => PostDetailsDeskTop(),
            ),
            GetPage(
              name: '/link',
              page: () => DetailsLoadLink(),
              transition: Transition.fadeIn,
            ),

            GetPage(name: '/Decider', page: () => const HomeDeciderView()),
            GetPage(name: '/desktop', page: () => const HomeScreenDesktop()),
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
          builder: (context, child) => WillPopScope(
            onWillPop: () async {
              if (EnhancedNavigatorObserver._navigationStack.length > 1) {
                EnhancedNavigatorObserver._navigationStack.removeLast();
                html.window.history.back();
                return false;
              }
              _showExitConfirmation();
              return false;
            },
            child: Scaffold(
              body: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 0.9,
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Container(child: child),
                ),
              ),
            ),
          ),
        ));
  }

  void _showExitConfirmation() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل تريد حقًا الخروج من التطبيق؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
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
}

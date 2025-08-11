import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../../controllers/AuthController.dart';
import '../../controllers/areaController.dart';
import '../../core/localization/changelanguage.dart';
import 'dart:async';
import 'dart:convert';
import '../viewsDeskTop/SettingsDeskTop/settings_popup_desktop.dart';
import '../viewsDeskTop/searchDeskTop/search_screen_desktop.dart';
import 'LoadingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/class/class/crud.dart';
import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';
import '../core/data/model/Auction.dart';
import '../core/data/model/BannerAd.dart';
import '../core/data/model/Bid.dart';
import '../core/data/model/City.dart';
import '../core/data/model/Comment.dart';
import '../core/data/model/Stores.dart';
import '../core/data/model/category.dart';
import '../core/data/model/post.dart';
import '../core/data/model/subcategory_level_one.dart';
import '../core/data/model/subcategory_level_two.dart';
import '../core/services/appservices.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'PromotedAdController.dart';
import 'settingsController.dart';
import 'userDahsboardController.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ////////////////////////////////
  var currentAdIndex = 0.obs;
  RxInt isGoFromLink = 0.obs;
  //////////////////////

  final RxBool isDesktop = false.obs;
  final RxBool isTablet = false.obs;
  final RxBool isMobile = false.obs;
  AreaController areaController = Get.put(AreaController());
  AuthController authController = Get.put(AuthController());
  PromotedadController promotedadController = Get.put(PromotedadController());
  RxBool showMap = false.obs;
  var priceInDetails = "";
  final crud = Crud();
  AppServices appServices = Get.find();
  RxBool isGetDataFirstTime = false.obs;
  RxString selectedRoute = 'العراق'.obs;
  /////التمرير داخل تفاصيل المنشور//////
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
 /// حالة التهيئة
  bool isInitialized = false;

  String? pendingPostId;

  @override
  void onInit() {
    super.onInit();

    // الاستماع لضغط زر الرجوع في المتصفح
    html.window.onPopState.listen((event) {
      if (Get.currentRoute != '/') {
        isSearchFromHome.value = false;
        Get.back();
      } else {
        isSearchFromHome.value = false;
        Get.toNamed('/confirm-exit');
      }
    });

    _initAnimations();

    // تشغيل وضع الشاشة الكاملة
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    checkAndSetFullScreen();

    // بدء التهيئة وجلب البيانات
    initializeData();
  }


  /// يعيد تشغيل جلب البيانات من الصفر
  void replayData() {
    isInitialized = false;
    isGetDataFirstTime.value = false;
    initializeData();
  }

  /// ضبط شاشة كاملة ولون شريط الحالة
  void checkAndSetFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// الخطوة الأولى: تحميل المسار واللغة ثم البيانات الأساسية
  Future<void> initializeData() async {
    try {
      isInitialized = true;

      // إذا هناك منشور معلق، جلب تفاصيله أولاً
      if (pendingPostId != null) {
        await fetchPostDetails(pendingPostId!);
        pendingPostId = null;
      }

      // 1. تحميل المسار المحفوظ
      await loadSelectedRoute();

      // 2. تهيئة إعدادات اللغة/التنسيق
      await makeInitial();

      // 3. جلب البيانات الأساسية لمرة واحدة
      if (!isGetDataFirstTime.value) {
        await fetchInitialData();
      }
    } catch (e, st) {
      debugPrint('Initialization Error: $e\n$st');
    }
  }

  /// جلب البيانات الأساسية مع تحسينات التوازي وإلغاء التأخير
  Future<void> fetchInitialData() async {
    final lang = Get.find<ChangeLanguageController>()
        .currentLocale
        .value
        .languageCode;
    final country = getCountryCode(selectedRoute.value);

    try {
      // تجميع المهام في قائمة
      final parallelTasks = <Future<void>>[
        _fetchWithRetry(() => fetchCategories(lang), retries: 2),
        _fetchWithRetry(() => promotedadController.fetchAds('active', lang)),
        _fetchWithRetry(() => fetchLatestBannerAds()),
        _fetchWithRetry(
            () => fetchPosts(lang, country: country), retries: 2),
        _fetchWithRetry(
            () => fetchPostsMostView(lang, country: country), retries: 2),
        _fetchWithRetry(
            () => fetchPostsMostRating(lang, country: country), retries: 2),
        _fetchWithRetry(
            () => Get.find<Settingscontroller>().fetchPackages(lang)),
        _fetchWithRetry(() => fetchCities(country, lang), retries: 2),
      ];

      // تنفيذ 8 طلبات في دفعة واحدة بدون تأخير
      await runTaskBatches(
        parallelTasks,
        batchSize: 8,
        delayBetweenBatches: Duration.zero,
      );

      // جلب 30 فئة بدفعات من 10 فئات لكل دفعة
      await _fetchCategoriesInBatches(lang, country, batchSize: 10);

      // التحقق من انتهاء صلاحية المنشورات
      await checkExpiredPosts();

      isGetDataFirstTime.value = true;
    } catch (e, st) {
      debugPrint('Failed to load initial data: $e\n$st');
      isGetDataFirstTime.value = false;
    }
  }

  /// تنفيذ قائمة مهام في دفعات متزامنة لزيادة التوازي
  Future<void> runTaskBatches(
    List<Future<void>> tasks, {
    int batchSize = 8,
    Duration delayBetweenBatches = Duration.zero,
  }) async {
    for (int i = 0; i < tasks.length; i += batchSize) {
      final end = (i + batchSize > tasks.length)
          ? tasks.length
          : i + batchSize;
      final batch = tasks.sublist(i, end);
      await Future.wait(batch);
      if (end < tasks.length && delayBetweenBatches > Duration.zero) {
        await Future.delayed(delayBetweenBatches);
      }
    }
  }

  /// آلية إعادة المحاولة لأي طلب
  Future<void> _fetchWithRetry(
    Future<void> Function() request, {
    int retries = 2,
  }) async {
    for (int i = 0; i <= retries; i++) {
      try {
        await request();
        return;
      } catch (e) {
        if (i == retries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// جلب 30 فئة في دفعات لتقليل عدد مرات wait
  Future<void> _fetchCategoriesInBatches(
    String lang,
    String country, {
    int batchSize = 10,
  }) async {
    const totalCategories = 30;
    for (int start = 1; start <= totalCategories; start += batchSize) {
      final end = (start + batchSize - 1).clamp(1, totalCategories);
      final futures = List.generate(
        end - start + 1,
        (i) => _fetchWithRetry(
          () => _fetchCategoryPosts(start + i, lang, country),
          retries: 1,
        ),
      );
      await Future.wait(futures);
    }
  }

  /// جلب منشورات كل فئة كما في الأصل
  Future<void> _fetchCategoryPosts(
    int categoryId,
    String languageCode,
    String country,
  ) {
    final Map<int, Future<void> Function(String, String)> categoryFetchers =
        {
      1: fetchPostsCateOne,
      2: fetchPostsCateTwo,
      3: fetchPostsCateThree,
      4: fetchPostsCateFour,
      5: fetchPostsCateFive,
      6: fetchPostsCateSix,
      7: fetchPostsCateSeven,
      8: fetchPostsCateEight,
      9: fetchPostsCateNine,
      10: fetchPostsCateTen,
      11: fetchPostsCateEleven,
      12: fetchPostsCateTwelve,
      13: fetchPostsCateThrteen,
      14: fetchPostsCateFourTeen,
      15: fetchPostsCateFifteen,
      16: fetchPostsCateSixteen,
      17: fetchPostsCateSeventeen,
      18: fetchPostsCateEighteen,
      19: fetchPostsCateNineteen,
      20: fetchPostsCateTwenty,
      21: fetchPostsCateTwentyOne,
      22: fetchPostsCateTwentyTwo,
      23: fetchPostsCateTwentyThree,
      24: fetchPostsCateTwentyFour,
      25: fetchPostsCateTwentyFive,
      26: fetchPostsCateTwentySix,
      27: fetchPostsCateTwentySeven,
      28: fetchPostsCateTwentyEight,
      29: fetchPostsCateTwentyNine,
      30: fetchPostsCateThirty,
    };

    final fetcher = categoryFetchers[categoryId];
    if (fetcher != null) {
      return fetcher(languageCode, country);
    } else {
      return Future.error(
        Exception('Invalid category ID: $categoryId'),
      );
    }
  }

  /// استخراج رمز الدولة من اسم المسار
  String getCountryCode(String route) {
    const routeMap = {'العراق': 'IQ', 'تركيا': 'TR'};
    return routeMap[route] ?? 'SY';
  }

  /// تهيئة تنسيق التاريخ حسب اللغة
  Future<void> makeInitial() async {
    final lang = Get.find<ChangeLanguageController>()
        .currentLocale
        .value
        .languageCode;
    await initializeDateFormatting(lang, null);
  }

  /// تحميل المسار المحفوظ واستدعاء جلب المدن والفئات
  Future<void> loadSelectedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    selectedRoute.value = prefs.getString('selectedRoute') ?? 'العراق';

    await fetchCities(
      getCountryCode(selectedRoute.value),
      Get.find<ChangeLanguageController>()
          .currentLocale
          .value
          .languageCode,
    );

    await fetchCategories(
      Get.find<ChangeLanguageController>()
          .currentLocale
          .value
          .languageCode,
    );
  }

  /// حفظ المسار المختار
  Future<void> saveSelectedRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRoute', route);
    selectedRoute.value = route;
  }

  /// إعادة تحميل البيانات عند السحب للتحديث
  Future<void> refreshData() async {
    try {
      isGetDataFirstTime.value = false;
      await fetchInitialData();
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to refresh data'.tr);
    }
  }

////////////////////////////////..............Show The Cate...........////////////////////
   RxBool isShowTheCate = false.obs;

  showTheCate() {
    if (isShowTheCate.value == true) {
      isShowTheCate.value = false;
    } else {
      isShowTheCate.value = true;
    }
  }


//////////////////////////...........مسار التطبيق......................//////////.
// تحميل المسار المحفوظ من SharedPreferences

///////////////////////////////////...............القائمة الرئيسية...................................///////////////////////
  var categoriesList = <Category>[].obs; // قائمة قابلة للمراقبة
  RxBool isLoadingCategories = false.obs;

  Future<void> fetchCategories(String language) async {
    isLoadingCategories.value = true;
    try {
      final response = await http.get(
          Uri.parse('https://alamoodac.com/modac/public/categories/$language'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var fetchedCategories = (data['data'] as List)
            .map((category) => Category.fromJson(category))
            .toList();

        // إذا كان المسار المختار هو "تركيا"، نقوم بإزالة القسم ذو المعرف 9
        if (selectedRoute.value == 'تركيا') {
          fetchedCategories.removeWhere((category) => category.id == 10);
        }

        categoriesList.value = fetchedCategories;
      } else {}
    } catch (e) {
    } finally {
      isLoadingCategories.value = false;
    }
  }

////////////////////////////////////.................... البوستات احدث..........................////////////

  RxBool LoadingPosts = false.obs;
  var postsList = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور

  Future<void> fetchPosts(String language, {String? country}) async {
  try {
    LoadingPosts.value = true;

    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts/$language',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // تعديل هنا: فك الـ JSON من الحقل data
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;

      postsList.value = jsonData
          .map((post) => Post.fromJson(post))
          .toList();
    } else {
      // طباعة الخطأ مع التنبيه
      print('⚠️ فشل تحميل المنشورات. رمز الاستجابة: ${response.statusCode}');
      print('🧾 محتوى الاستجابة: ${response.body}');
      throw Exception('حدث خطأ أثناء تحميل المنشورات من الخادم.');
    }
  } catch (e, stacktrace) {
    print('🚨 خطأ في الدالة fetchPosts: $e');
    print('📌 تتبع الخطأ:\n$stacktrace');
  } finally {
    LoadingPosts.value = false;
  }
} ////////////////////////////////////.................... البوستات الاكثر مشاهدة..........................////////////

  RxBool LoadingPostsMostView = false.obs;
  var postsListMostView = <Post>[].obs;

  Future<void> fetchPostsMostView(String language ,{String ?country}) async {
    try {
      LoadingPostsMostView.value = true;


    // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/top-posts/$language',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);
     




      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListMostView.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      //  print("Error loading posts: $e");
    } finally {
      LoadingPostsMostView.value = false;
    }
  } ////////////////////////////////////.................... البوستات الاكثر تقييم..........................////////////

  RxBool LoadingPostsMostRating = false.obs;
  var postsListMostRating = <Post>[].obs;

  Future<void> fetchPostsMostRating(String language,{String? country}) async {
    try {
      LoadingPostsMostRating.value = true;


    // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
        'https://alamoodac.com/modac/public/top-rated-posts/$language',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);


      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListMostRating.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error loading posts: $e");
    } finally {
      LoadingPostsMostRating.value = false;
    }
  }
////////////////////////////////////.................... المنشورات حسب القسم الرئيسي والفرعي الاول والثاني .........................////////////

////////////////////////////////////.................... المنشورات حسب القسم الرئيسي والفرعي الاول والثاني .........................////////////
RxBool LoadingPostsAll = false.obs;
var postsListAll = <Post>[].obs;

Future<void> fetchPostsAll(
  int categoryId,
  String language,
  int? subcategoryId,
  int? subcategoryLevel2Id,
  String? country,
) async {
  try {
    LoadingPostsAll.value = true;

    // بناء الرابط الأساسي
    String url = 'https://alamoodac.com/modac/public/posts/$categoryId/$language';

    // إضافة المعرفات الفرعية إن وُجدت
    if (subcategoryId != null) {
      url += '/$subcategoryId';
    }
    if (subcategoryLevel2Id != null) {
      url += '/$subcategoryLevel2Id';
    }

    // تكوين الرابط الكامل باستخدام Uri
    final uri = Uri.parse(url).replace(queryParameters: {
      if (country != null && country.isNotEmpty) 'country': country,
    });

    print("🔗 Final URL: $uri"); // ✅ طباعة الرابط الكامل النهائي

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('📛 فشل في تحميل المنشورات. StatusCode: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print("❌⚠️ حدث خطأ أثناء تحميل المنشورات:");
    print("🔴 الخطأ: $e");
    print("🧵 تفاصيل الستاك:\n$stackTrace");
  } finally {
    LoadingPostsAll.value = false;
  }
}
  ////////////////////////////...............Show SubCategoriesPage................................///////////////////////////
  RxBool showTheSubCategories = false.obs;
  RxString nameCategories = "".obs;
  RxString idCategories = "".obs;
  /////////////////////////////...................Sub.....................///////////////

  RxBool isLoadingSubcategoryLevelOne = false.obs; // متغير حالة التحميل
  var subCategories = <SubcategoryLevelOne>[].obs; // قائمة قابلة للمراقبة

  Future<void> fetchSubcategories(int Theid, String language) async {
    if (subCategories.isEmpty) {
      isLoadingSubcategoryLevelOne.value = true;
      try {
        final response = await http.get(Uri.parse(
            'https://alamoodac.com/modac/public/subcategories?category_id=$Theid&language=$language'));

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data != null) {
            var fetchedSubCategories = (data as List)
                .map((subcategory) => SubcategoryLevelOne.fromJson(subcategory))
                .toList();

            subCategories.value = fetchedSubCategories;
          } else {
            subCategories.clear();
          }
        } else {}
      } catch (e) {
      } finally {
        isLoadingSubcategoryLevelOne.value = false;
      }
    }
  }

  //////////////////////////.........................SubTwo...............................//////////////

  RxInt numberOfSubOne = 0.obs;
  RxInt numberOfSubTwo = 0.obs;

  RxBool showTheSubTwo = false.obs;
  RxBool isLoadingSubcategoryLevelTwo = false.obs;
  var subcategoriesLevelTwo = <SubcategoryLevelTwo>[].obs;
  Future<void> fetchSubcategoriesLevelTwo(
      int subCategoryLevelOneId, String language) async {
    isLoadingSubcategoryLevelTwo.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/subcategories-level-two?sub_category_level_one_id=$subCategoryLevelOneId&language=$language'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data != null && data['data'] != null) {
          var fetchedSubCategoriesTwo = (data['data'] as List)
              .map((subcategoryTwo) =>
                  SubcategoryLevelTwo.fromJson(subcategoryTwo))
              .toList();

          if (fetchedSubCategoriesTwo.isNotEmpty) {
            subcategoriesLevelTwo.value = fetchedSubCategoriesTwo;
            showTheSubTwo.value =
                true; // تعيين showTheSubTwo إلى true إذا كانت البيانات غير فارغة
          } else {
            subcategoriesLevelTwo.clear();
            showTheSubTwo.value =
                false; // تعيين showTheSubTwo إلى false إذا كانت البيانات فارغة
          }
        } else {
          subcategoriesLevelTwo.clear();
          showTheSubTwo.value =
              false; // تعيين showTheSubTwo إلى false إذا كانت البيانات غير موجودة
        }
      } else {
        subcategoriesLevelTwo.clear();
        showTheSubTwo.value =
            false; // تعيين showTheSubTwo إلى false في حال فشل الـ API
      }
    } catch (e) {
      print('Error occurred: $e');
      subcategoriesLevelTwo.clear();
      showTheSubTwo.value =
          false; // تعيين showTheSubTwo إلى false في حال حدوث خطأ
    } finally {
      isLoadingSubcategoryLevelTwo.value = false;
    }
  }

  /////////////////..........Details Post.........................../////////

  RxBool showDetailsPost = false.obs;
  RxInt currentPageIndex = 0.obs;
  Rxn<Post> selectedPost = Rxn<Post>();

  var categoryName = "";

  var subcategoryName = "";
  var subcategoryLevelTwoName = "";
  var postTitle = "";
  void setSelectedPost(Post post) {
    selectedPost.value = post;
    incrementViewsPost(selectedPost.value?.id ?? 0);
    fetchComments(selectedPost.value?.id ?? 0);
    // التحقق من وجود ترجمات في القسم قبل الوصول إلى العنصر الأول
    categoryName = selectedPost.value?.category.translations.isNotEmpty == true
        ? selectedPost.value?.category.translations.first.name ?? ''
        : '';

    // التحقق من وجود ترجمات في القسم الفرعي قبل الوصول إلى العنصر الأول
    subcategoryName =
        selectedPost.value?.subcategory.translations.isNotEmpty == true
            ? selectedPost.value?.subcategory.translations.first.name ?? ''
            : '';

    // التحقق من وجود ترجمات في القسم الفرعي الثاني قبل الوصول إلى العنصر الأول
    subcategoryLevelTwoName =
        selectedPost.value?.subcategoryLevelTwo.translations.isNotEmpty == true
            ? selectedPost.value?.subcategoryLevelTwo.translations.first.name ??
                ''
            : '';

    // التحقق من وجود ترجمات في المنشور قبل الوصول إلى العنصر الأول
    postTitle = selectedPost.value?.translations.isNotEmpty == true
        ? selectedPost.value?.translations.first.title ?? ''
        : "";

    if (int.parse(post.categoryId) == 8) {
      fetchAuctionByPostId(post.id.toString());
    }
    fetchPublisherList(selectedPost.value?.storeID ?? "",
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode);
    showDetailsPost.value = true;
  }

  /////////////////////////////............. The icons Ac................//////////////////
  RxBool isHome = true.obs;
  RxBool isInfo = false.obs;
  RxBool isSearch = false.obs;
  RxBool isMenu = false.obs;
  RxBool addPost = false.obs;

  isChosedHome() {
    isHome.value = true;

    isInfo.value = false;
    isSearch.value = false;
    isMenu.value = false;
    addPost.value = false;
    shouldShowDialog.value = false;
  }

  isChosedInfo() {
    Get.find<Userdahsboardcontroller>().showDashBoardUser.value = true;

    shouldShowDialog.value = false;
  }

  isChosedSearch() {
    isSearch.value = true;
    isInfo.value = false;
    isHome.value = false;
    isMenu.value = false;
    addPost.value = false;
    shouldShowDialog.value = false;
   
  }

  isChosedMenu() {
    isMenu.value = true;
    isSearch.value = false;
    isInfo.value = false;
    isHome.value = false;
    addPost.value = false;
    shouldShowDialog.value = false;
  }

  RxBool showMessage = false.obs;
  isChosedAddPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // الحصول على القيمة المخزنة للمفتاح
    String? storeStatus = prefs.getString('IsHaveInfoUser');
    print(storeStatus);

    // إذا كانت القيمة 'Yes' يعني أن المستخدم لديه متجر
    if (storeStatus == 'Yes') {
      shouldShowDialog.value = false;
      showMessage.value = false;
    } else {
      // في حال عدم وجود القيمة أو كانت قيمة مختلفة، يمكن عرض رسالة إنشاء حساب متجر
      shouldShowDialog.value = true;
      showMessage.value = true;
    }

    addPost.value = true;
    isMenu.value = false;
    isSearch.value = false;
    isInfo.value = false;
    isHome.value = false;
  }

  ////////////////////////............Searching.......................///////////
  final TextEditingController isSearchText = TextEditingController();

  RxBool loadingSearchPosts = false.obs;
  var searchPostsList = <Post>[].obs;

  RxString? nameOFSearch;
  RxInt? idCateSeaarch;
  RxInt? idSubForSearch;
  RxInt? idSubTwoForSearch;

// لتخصيص الصفحة لكل منشور
  
  ////////////////........getCitys.............../////////
  final chosedIdCity = Rx<int?>(null); // يجب أن يكون Rx<int?> وليس RxInt?
  var citiesList = <TheCity>[].obs; // قائمة قابلة للمراقبة
  RxBool isLoadingCities = false.obs;
  Future<void> fetchCities(String Cont, String language) async {
    isLoadingCities.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://alamoodac.com/modac/public/cities/$Cont/$language'),
      );

      if (response.statusCode == 200) {
        //  print("استجابة الخادم: ${response.body}");

        var data = json.decode(response.body);

        if (data is List) {
          var fetchedCities = data
              .map((city) {
                try {
                  return TheCity.fromJson(city);
                } catch (e) {
                  return null; // تجاهل الكائن غير الصحيح
                }
              })
              .where((city) => city != null)
              .toList();

          citiesList.value = fetchedCities.cast<TheCity>();
        } else {}
      } else {}
    } catch (e) {
    } finally {
      isLoadingCities.value = false;
    }
  }

  /////////////////////////////////............مشاهدة التعليقات وإخفاء التفاصيل...........//////////////////////
  RxBool isShowMoreOrLess = false.obs;
////////////////.............إضافة تعليق جديد.............................//

  Future<void> addComment(
      {required int postId,
      required String commentText,
      required BuildContext context}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
          child: CircularProgressIndicator(
        color: AppColors.TheMain,
        backgroundColor: AppColors.whiteColor,
      )),
    );
    final url = Uri.parse(
        'https://alamoodac.com/modac/public/comments'); // استبدل `your-api-url` بعنوان الـ API
    final response = await http.post(
      url,
      body: {
        'post_id': postId.toString(),
        'user_id': Get.find<LoadingController>().currentUser?.id.toString(),
        'comment_text': commentText,
      },
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'نجاح',
        'تم إضافة التعليق بنجاح!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchComments(selectedPost.value?.id ?? 0);
    } else {
      Get.snackbar(
        'فشل',
        'فشل في إضافة التعليق: ${response.body}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    Navigator.of(context, rootNavigator: true).pop();
  }

//////////////////////......................إضافة مزاد جديد.................................////////
  RxList<Comment> commentsList =
      <Comment>[].obs; // قائمة قابلة للمراقبة للتعليقات
  RxBool isLoadingComments = false.obs; // حالة التحميل
  int? chosenPostId; // معرف المنشور المختار
  Future<void> fetchComments(int postId) async {
    isLoadingComments.value = true; // تفعيل حالة التحميل
    try {
      final response = await http.get(
        Uri.parse(
            'https://alamoodac.com/modac/public/comments/$postId'), // استبدل `your-api-url` بعنوان الـ API
      );

      if (response.statusCode == 200) {
        print("استجابة الخادم: ${response.body}");

        var data = json.decode(response.body);

        if (data['comments'] is List) {
          var fetchedComments = data['comments']
              .map((comment) {
                try {
                  // طباعة كل تعليق للتحقق من البيانات
                  print("تعليق: ${comment}");

                  return Comment.fromJson(comment);
                } catch (e) {
                  print("خطأ في تحويل التعليق: $e");
                  return null; // تجاهل الكائن غير الصحيح
                }
              })
              .where((comment) => comment != null)
              .toList();

          commentsList.value = fetchedComments.cast<Comment>();

          // طباعة عدد التعليقات المسترجعة
          print("تم تحميل التعليقات بنجاح: ${commentsList.length} تعليق");

          // طباعة محتويات التعليقات (إذا كانت هناك تعليقات)
          if (commentsList.isEmpty) {
            print("قائمة التعليقات فارغة");
          } else {
            for (var comment in commentsList) {
              print(
                  "تعليق: ${comment.commentText} - من: ${comment.userName ?? 'مجهول'}");
            }
          }
        } else {
          print("البيانات غير متوفرة أو غير صحيحة.");
        }
      } else {
        print("خطأ في تحميل التعليقات: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ أثناء الاتصال بالخادم: $e");
    } finally {
      isLoadingComments.value = false; // إيقاف حالة التحميل
    }
  }

  //////////////////////////////المزادات
  RxList<Bid> bidsList = <Bid>[].obs;
  RxBool isLoadingBids = false.obs;
  RxBool isLoadingBid = false.obs;

  // جلب المزايدات حسب معرف المزاد
  Future<void> fetchBids(int auctionId) async {
    isLoadingBids.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://alamoodac.com/modac/public/bids/$auctionId'), // استبدل `your-api-url` بعنوان API الخاص بك
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['bids'] is List) {
          bidsList.value =
              data['bids'].map((bid) => Bid.fromJson(bid)).toList().cast<Bid>();
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch bids',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching bids',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingBids.value = false;
    }
  }

  String convertArabicNumbersToEnglish(String text) {
    Map<String, String> arabicToEnglishNumbers = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    arabicToEnglishNumbers.forEach((arabic, english) {
      text = text.replaceAll(arabic, english);
    });

    return text;
  }

  Future<void> placeBid({
    required int auctionId,
    required double bidAmount,
    required String contactInfo,
    String? additionalNotes,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: AppColors.TheMain,
          backgroundColor: AppColors.whiteColor,
        ),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse('https://alamoodac.com/modac/public/bids/$auctionId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': Get.find<LoadingController>().currentUser?.id ?? 0,
          'bid_amount': bidAmount,
          'contact_info': contactInfo,
          'additional_notes': additionalNotes,
        }),
      );
      print({
        'user_id': Get.find<LoadingController>().currentUser?.id ?? 0,
        'bid_amount': bidAmount,
        'contact_info': contactInfo,
        'additional_notes': additionalNotes,
      });

      // طباعة الاستجابة من الخادم لمساعدتك في معرفة ما يتم إرجاعه
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response Content-Type: ${response.headers['content-type']}');

      // التحقق إذا كانت الاستجابة بصيغة JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        var responseData = json.decode(response.body);

        if (response.statusCode == 201) {
          Get.snackbar(
            'نجاح',
            "تم إضافة المزايدة بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          fetchBids(auctionId);
        } else {
          String errorMessage =
              responseData['error'] ?? 'فشل في إضافة المزايدة';
          print(
              'Error occurred: $errorMessage'); // طباعة رسالة الخطأ لتتبع المشكلة

          Get.snackbar(
            'خطأ',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

          // تخصيص رسائل الأخطاء استنادًا إلى نوع الخطأ
          if (errorMessage == 'Auction is not active') {
            Get.snackbar('Error', 'المزاد غير نشط',
                snackPosition: SnackPosition.BOTTOM);
          } else if (errorMessage ==
              'Bid amount must be greater than current price') {
            Get.snackbar('Error', 'يجب أن تكون المزايدة أكبر من السعر الحالي',
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.snackbar('Error', errorMessage,
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      } else {
        // إذا كانت الاستجابة ليست JSON، طباعة المحتوى
        print('Unexpected response format: ${response.body}');
        Get.snackbar('Error', 'استجابة غير صحيحة من الخادم',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // طباعة الاستثناء في حال حدوث خطأ
      print('Exception: $e');
      Get.snackbar('Error', 'حدث خطأ أثناء إضافة المزايدة',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingBid.value = false;
    }

    Navigator.of(context, rootNavigator: true).pop();
  }

  //////////واجهات المزايدة والتعليقات
  final TextEditingController bidAmountController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  RxBool showTheBid = false.obs;
  ////..........التعليقات............................//////////

  final TextEditingController CommentController = TextEditingController();
  RxBool showTheComment = false.obs;

/////////////////
  Future<bool> incrementViews(int storeId) async {
    final url = Uri.parse(
        'https://alamoodac.com/modac/public/store/$storeId/increment-views');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // إذا كنت بحاجة إلى توثيق
        },
      );

      if (response.statusCode == 200) {
        // إذا كانت الاستجابة ناجحة
        final data = jsonDecode(response.body);
        if (data['success']) {
          print('تم زيادة عدد المشاهدات بنجاح');
          return true;
        } else {
          print('فشل في زيادة عدد المشاهدات');
          return false;
        }
      } else {
        print('حدث خطأ: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('خطأ في الاتصال: $e');
      return false;
    }
  }

  //////////////////
  Future<bool> incrementViewsPost(int postId) async {
    final url = Uri.parse(
        'https://alamoodac.com/modac/public/posts/$postId/increment-views');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // إذا كنت بحاجة إلى توثيق
        },
      );

      if (response.statusCode == 200) {
        // إذا كانت الاستجابة ناجحة
        final data = jsonDecode(response.body);
        print("تم");
        return data['success'] ?? false;
      } else {
        print('حدث خطأ: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('خطأ في الاتصال: $e');
      return false;
    }
  }

  //////////////////..........................GetData Acu................///////////
  RxBool isShowStores = false.obs;

  RxList<RxInt> storesPageIndexes = <RxInt>[].obs;

  var approvedStoresList = <Stores>[].obs; // قائمة المتاجر المعتمدة
  RxBool isLoadingApprovedStores = false.obs;

  Future<void> fetchApprovedStores(String language,
      {String? searchName}) async {
    isLoadingApprovedStores.value = true;

    try {
      // بناء الرابط لجلب المتاجر المعتمدة
      String endpoint =
          'https://alamoodac.com/modac/public/stores/approved/$language';

      // إذا كان هناك نص بحث
      if (searchName != null && searchName.isNotEmpty) {
        endpoint += '?name=$searchName'; // إضافة البحث في الرابط
      }

      // إرسال الطلب
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // التأكد من أن `data['data']` هي قائمة
        if (data['data'] != null && data['data'] is List) {
          var fetchedStores = (data['data'] as List)
              .map((store) => Stores.fromJson(store))
              .toList();

          storesPageIndexes.value =
              List.generate(fetchedStores.length, (index) => 0.obs);
          approvedStoresList.value =
              fetchedStores; // تحديث قائمة المتاجر المعتمدة
        } else {
          approvedStoresList.value = []; // إذا لم تكن هناك متاجر
        }
      } else {}
    } catch (e) {
    } finally {
      isLoadingApprovedStores.value = false;
    }
  }

  /////////////................Details Stores............................/////////////////////
  var StoreTitle = "";
  var StoreDesc = "";

//https://alamoodac.com/modac/public/user-posts/category/22/ar
  /////////////////جلب منشورات المتجر

  ////////////////...........changeCount........................///////////////

  var currency = 'IQD'.obs; // العملة الافتراضية
  double exchangeRate = 0.00076; // سعر الصرف
  String getConvertedPrice(String price) {
    // إزالة النصوص غير الضرورية مثل "IQD" والفواصل
    String cleanedPrice = price.replaceAll(RegExp(r'[^\d.]'), '');

    // تحويل النص المنظف إلى قيمة رقمية
    double priceValue = double.tryParse(cleanedPrice) ?? 0.0;

    // إنشاء كائن لتنسيق الأرقام
    final numberFormat = NumberFormat("#,###");

    // تحويل العملة بناءً على الحالة
    if (currency.value == 'USD') {
      return '\$${numberFormat.format(priceValue * exchangeRate)}'; // دولار
    }
    return '${numberFormat.format(priceValue)} ${'دينار'.tr}';
  }

  /////////////////جلب مزاد منشور ما.............................../////////////////////
  Rx<Auction?> auction = Rx<Auction?>(null); // بيانات المزاد
  RxBool isLoading = false.obs; // حالة التحميل
  RxString errorMessage = ''.obs; // رسالة الخطأ
  int idAucToAdd = 0;
  // جلب بيانات المزاد حسب معرف المنشور
  Future<void> fetchAuctionByPostId(String postId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url =
          Uri.parse('https://alamoodac.com/modac/public/auctions/$postId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        auction.value = Auction.fromJson(data['auction']);
        print(response.body);
        print(data);
        print("////////////////////////////////////");
        idAucToAdd = auction.value?.id ?? 0;
      } else {
        errorMessage.value = 'Failed to fetch auction data';
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////////////////........rate.................//////////

  var isSubmitting = false.obs; // متغير لمراقبة حالة الإرسال

  Future<void> ratePost(int postId, double rating, BuildContext context) async {
    isSubmitting.value = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
    );

    final String url = 'https://alamoodac.com/modac/public/posts/$postId/rate';

    try {
      // احصل على التقييم السابق
      final previousRatingString = selectedPost.value?.rating;
      final previousRating =
          previousRatingString != null && previousRatingString.isNotEmpty
              ? double.tryParse(previousRatingString) ?? 0.0
              : 0.0;

      // قم بحساب التقييم الجديد بعد إضافة التقييمين معًا ثم القسمة على 2 (أو على 5 إذا كان لديك 5 تقييمات)
      final newRating = (previousRating + rating) / 2;

      // إرسال التقييم الجديد إلى الخادم
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'rating': newRating}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar(
          "نجاح".tr,
          "تم تحديث التقييم بنجاح".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print('تم تحديث التقييم: ${data['post']}');
      } else {
        final error = json.decode(response.body);
        Get.snackbar(
          "خطأ".tr,
          error['error'] ?? "حدث خطأ أثناء التقييم".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ".tr,
        "تعذر الاتصال بالخادم".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('خطأ: $e');
    } finally {
      isSubmitting.value = false;
      Navigator.of(context, rootNavigator: true).pop(); // إغلاق دائرة التحميل
    }
  }

  //////Rout........../
  final RxInt _currentStep = 1.obs;
  final RxString _selectedCountry = ''.obs;
  final RxString _selectedLang = ''.obs;

  int get currentStep => _currentStep.value;
  String get selectedCountry => _selectedCountry.value;
  String get selectedLang => _selectedLang.value;

  void selectCountry(String country) {
    _selectedCountry.value = country;
    _currentStep.value = 2;
  }

  void selectLanguage(String lang) {
    _selectedLang.value = lang;
  }

  void goToNextStep() {
    if (_currentStep.value < 2) {
      _currentStep.value++;
    } else {
      //////////////////////////////////////////////////////...........    Get.offAll(OnAppPages());
    }
  }

  /////////////////................Stores بيانات الناشر..........................///////
  ///////////////أولا جلب متجر-بيانات الناشر.........////////
  RxBool showStorePusherUser = false.obs;
  RxBool LoadingStorePuscher = false.obs;
  var StorePuscherList = <Stores>[].obs;
  Future<void> fetchStroePuscher(String language, int idUser) async {
    //////////////////////////////////////////////////////......  Get.to(PublisherDetailsScreen());
    LoadingStorePuscher.value = true;

    try {
      // بناء الرابط لجلب المتاجر المعتمدة
      String endpoint =
          'https://alamoodac.com/modac/public/user/$idUser/store/$language';

      // إذا كان هناك نص بحث

      // إرسال الطلب
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // التأكد من أن `data['data']` هي قائمة
        if (data['data'] != null && data['data'] is List) {
          var fetchedStores = (data['data'] as List)
              .map((store) => Stores.fromJson(store))
              .toList();

          StorePuscherList.value =
              fetchedStores; // تحديث قائمة المتاجر المعتمدة
          StorePuscherList.isNotEmpty ? setSelectedStores(idUser) : null;
        } else {
          StorePuscherList.value = []; // إذا لم تكن هناك متاجر
        }
      } else {}
    } catch (e) {
    } finally {
      LoadingStorePuscher.value = false;
    }
  }

//////////////////مشاهدة تفاصيل الناشر.....................//////////

  void setSelectedStores(int idUser) {
    fetchPostsStore(
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
        idUser);
    showStorePusherUser.value = true;
  }

  RxList<RxInt> postPageIndexesStore = <RxInt>[].obs;

  RxBool LoadingPostsStore = false.obs;
  var postsListStore = <Post>[].obs;

  Future<void> fetchPostsStore(String language, int iduser) async {
    try {
      LoadingPostsStore.value = true;

      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/user-posts/category/$iduser/$language'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        postsListStore.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error loading posts: $e");
    } finally {
      LoadingPostsStore.value = false;
    }
  }

  Future<bool> incrementViewsStore(int storeId) async {
    final url = Uri.parse(
        'https://alamoodac.com/modac/public/store/$storeId/increase-views');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // إذا كنت بحاجة إلى توثيق
        },
      );

      if (response.statusCode == 200) {
        // إذا كانت الاستجابة ناجحة
        final data = jsonDecode(response.body);
        print("تم");
        return data['success'] ?? false;
      } else {
        print('حدث خطأ: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('خطأ في الاتصال: $e');
      return false;
    }
  }

  ////////////////////////////////////////الفلترة في الأقسام الداخلية .............../////
 ////////////////////////////////////////الفلترة في الأقسام الداخلية .............../////

Future<void> fetchLatestPosts({
  required String language,
  String? categoryId,
  required String country, // ✅ أضف هذا السطر
}) async {
  try {
    LoadingPostsAll.value = true;

    Map<String, String> queryParams = {}; // ✅ مهيأة فارغة بدل null

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    if (country != null && country.isNotEmpty) {
      queryParams['country'] = country; // ✅ أضف باراميتر الدولة
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/f/latest/$language',
      queryParameters: queryParams, // ✅ استخدم الكائن الذي بنيناه
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value =
          jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load latest posts');
    }
  } catch (e) {
    print("⚠️ خطأ أثناء تحميل المنشورات المفلترة: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}
Future<void> fetchOldestPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/oldest/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load oldest posts');
    }
  } catch (e) {
    print("Error loading oldest posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchCheapestPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/cheapest/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load cheapest posts');
    }
  } catch (e) {
    print("Error loading cheapest posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchMostExpensivePosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/most-expensive/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load most expensive posts');
    }
  } catch (e) {
    print("Error loading most expensive posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchHighestRatedPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/highest-rated/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load highest rated posts');
    }
  } catch (e) {
    print("Error loading highest rated posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchLowestRatedPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/lowest-rated/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load lowest rated posts');
    }
  } catch (e) {
    print("Error loading lowest rated posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchMostViewedPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/most-viewed/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load most viewed posts');
    }
  } catch (e) {
    print("Error loading most viewed posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

Future<void> fetchLeastViewedPosts({
  required String language,
  String? categoryId,
  required String country,
}) async {
  try {
    LoadingPostsAll.value = true;
    Map<String, String> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }
    if (country.isNotEmpty) {
      queryParams['country'] = country;
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'alamoodac.com',
      path: '/modac/public/least-viewed/$language',
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> jsonData = body['data'] as List<dynamic>;
      postsListAll.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load least viewed posts');
    }
  } catch (e) {
    print("Error loading least viewed posts: $e");
  } finally {
    LoadingPostsAll.value = false;
  }
}

  /////////////////////////////.........المنشورات القريبة...............////////////////

  isShowTheFetch(BuildContext context) {
    if (Get.find<LoadingController>().currentUser?.latitude == null) {
      Get.snackbar(
        '', // اترك العنوان فارغًا لأنك ستستخدم titleText
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        titleText: Text(
          "لاتستطيع البحث!".tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'يجب عليك إضافة موقعك الجغرافي للبحث عن المنشورات القريبة منك'.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.DinarOne,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      );
    } else {
      fetchNearbyPosts(
          latitude: Get.find<LoadingController>().currentUser?.latitude ?? 0.0,
          longitude:
              Get.find<LoadingController>().currentUser?.longitude ?? 0.0,
          language: Get.find<ChangeLanguageController>()
              .currentLocale
              .value
              .languageCode,
          categoryId: idCategories.value,
          context: context, 
          country: getCountryCode(selectedRoute.value));
    }
  }

  Future<void> fetchNearbyPosts({
    required double latitude,
    required double longitude,
    required String language,
    double radius = 10.0,
    String? categoryId, // معرف القسم الرئيسي اختياري
    required BuildContext context,
    required String? country,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: CircularProgressIndicator(
            color: AppColors.TheMain,
            backgroundColor: AppColors.whiteColor,
          ),
        ),
      );
      LoadingPostsAll.value = true;

      // بناء الرابط الأساسي مع معلمات الموقع واللغة
      String url = 'https://alamoodac.com/modac/public/posts/nearby';
      url +=
          '?latitude=$latitude&longitude=$longitude&radius=$radius&language=$language';

      // إذا تم تمرير معرف القسم الرئيسي، يتم إضافته إلى الرابط
      if (categoryId != null && categoryId.isNotEmpty) {
        url += '&category_id=$categoryId';
      }
      

    if (country != null && country.isNotEmpty) {
     url += '/$country';
    }

      print("Fetching nearby posts from URL: $url");

      // إجراء الطلب HTTP
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // إذا كنت بحاجة إلى توثيق
        },
      );

      if (response.statusCode == 200) {
        // معالجة البيانات المستلمة وتحويلها إلى قائمة من المنشورات
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListAll.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
        Get.snackbar(
          duration: Duration(seconds: 3),
          '', // اترك العنوان فارغًا لأنك ستستخدم titleText
          '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          titleText: Text(
            "تمت عملية البحث عن المنشورات القريبة!".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'سيتم الان عرض المنـشورات القريبة من موقعك في حال وُجدت'.tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        );
        await Future.delayed(Duration(seconds: 3));
        showMap.value = false;
      } else {
        Get.snackbar(
          duration: Duration(seconds: 3),
          '', // اترك العنوان فارغًا لأنك ستستخدم titleText
          '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow,
          colorText: Colors.white,
          titleText: Text(
            "فشلت العمـلية!.".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            "لسبب ما لم تتم عملية البحث..!!حاول مجددًا".tr,
            style: TextStyle(
              fontFamily: AppTextStyles.DinarOne,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        );
        await Future.delayed(Duration(seconds: 3));
        showMap.value = false;
        throw Exception('Failed to load nearby posts');
      }
    } catch (e) {
      print("Error loading nearby posts: $e");
    } finally {
      LoadingPostsAll.value = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
 

  /////////////////////////...............الان العرض لجميع الاقسام أحدث 5.....................................//

/////////////////.......................الأول.......................///////////////
  RxBool LoadingPostsCateOne = false.obs;
  var postsListCateOne = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور

  Future<void> fetchPostsCateOne(String language, String country) async {
    try {
      LoadingPostsCateOne.value = true;


    // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
        'https://alamoodac.com/modac/public/latest-posts-by-category/$language/1',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);
    

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListCateOne.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
    } finally {
      LoadingPostsCateOne.value = false;
    }
  } /////////////////.......................الثاني.......................///////////////

  RxBool LoadingPostsCateTwo = false.obs;
  var postsListCateTwo = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور

  Future<void> fetchPostsCateTwo(String language,String country) async {
    try {
      LoadingPostsCateTwo.value = true;

      // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
        'https://alamoodac.com/modac/public/latest-posts-by-category/$language/2',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);
    

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListCateTwo.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
    } finally {
      LoadingPostsCateTwo.value = false;
    }
  }

  /////////////////.......................three.......................///////////////
  RxBool LoadingPostsCateThree = false.obs;
  var postsListCateThree = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور

  Future<void> fetchPostsCateThree(String language,String country) async {
    try {
      LoadingPostsCateThree.value = true;

      // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
        'https://alamoodac.com/modac/public/latest-posts-by-category/$language/3',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);
    

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListCateThree.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
    } finally {
      LoadingPostsCateThree.value = false;
    }
  } /////////////////.......................Four.......................///////////////

  RxBool LoadingPostsCateFour = false.obs;
  var postsListCateFour = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور

  Future<void> fetchPostsCateFour(String language,String country) async {
    try {
      LoadingPostsCateFour.value = true;

     // بناء URI وإضافة باراميتر الدولة إذا أرسلها المستخدم
    var uri = Uri.parse(
        'https://alamoodac.com/modac/public/latest-posts-by-category/$language/4',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'country': country,
      });
    }

    final response = await http.get(uri);
    

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;        postsListCateFour.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
    } finally {
      LoadingPostsCateFour.value = false;
    }
  } ///////////////.......................five.......................///////////////

RxBool LoadingPostsCateFive = false.obs;
var postsListCateFive = <Post>[].obs;

Future<void> fetchPostsCateFive(String language, String country) async {
  try {
    LoadingPostsCateFive.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/5',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateFive.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateFive.value = false;
  }
}

///////////////.......................Six.......................///////////////

RxBool LoadingPostsCateSix = false.obs;
var postsListCateSix = <Post>[].obs;

Future<void> fetchPostsCateSix(String language, String country) async {
  try {
    LoadingPostsCateSix.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/6',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateSix.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateSix.value = false;
  }
}

///////////////.......................Seven.......................///////////////

RxBool LoadingPostsCateSeven = false.obs;
var postsListCateSeven = <Post>[].obs;

Future<void> fetchPostsCateSeven(String language, String country) async {
  try {
    LoadingPostsCateSeven.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/7',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateSeven.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateSeven.value = false;
  }
}

///////////////.......................Eight.......................///////////////

RxBool LoadingPostsCateEight = false.obs;
var postsListCateEight = <Post>[].obs;

Future<void> fetchPostsCateEight(String language, String country) async {
  try {
    LoadingPostsCateEight.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/8',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateEight.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateEight.value = false;
  }
}

///////////////.......................Nine.......................///////////////

RxBool LoadingPostsCateNine = false.obs;
var postsListCateNine = <Post>[].obs;

Future<void> fetchPostsCateNine(String language, String country) async {
  try {
    LoadingPostsCateNine.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/9',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateNine.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateNine.value = false;
  }
}

///////////////.......................Ten.......................///////////////

RxBool LoadingPostsCateTen = false.obs;
var postsListCateTen = <Post>[].obs;

Future<void> fetchPostsCateTen(String language, String country) async {
  try {
    LoadingPostsCateTen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/10',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTen.value = false;
  }
}

///////////////.......................eleven.......................///////////////

RxBool LoadingPostsCateEleven = false.obs;
var postsListCateEleven = <Post>[].obs;

Future<void> fetchPostsCateEleven(String language, String country) async {
  try {
    LoadingPostsCateEleven.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/11',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateEleven.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateEleven.value = false;
  }
}

///////////////.......................Twelve.......................///////////////

RxBool LoadingPostsCateTwelve = false.obs;
var postsListCateTwelve = <Post>[].obs;

Future<void> fetchPostsCateTwelve(String language, String country) async {
  try {
    LoadingPostsCateTwelve.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/12',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwelve.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwelve.value = false;
  }
}

///////////////.......................Thrteen.......................///////////////

RxBool LoadingPostsCateThrteen = false.obs;
var postsListCateThrteen = <Post>[].obs;

Future<void> fetchPostsCateThrteen(String language, String country) async {
  try {
    LoadingPostsCateThrteen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/13',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateThrteen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateThrteen.value = false;
  }
}

///////////////.......................FourTeen.......................///////////////

RxBool LoadingPostsCateFourTeen = false.obs;
var postsListCateFourTeen = <Post>[].obs;

Future<void> fetchPostsCateFourTeen(String language, String country) async {
  try {
    LoadingPostsCateFourTeen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/14',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateFourTeen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateFourTeen.value = false;
  }
}

///////////////.......................Fifteen.......................///////////////

RxBool LoadingPostsCateFifteen = false.obs;
var postsListCateFifteen = <Post>[].obs;

Future<void> fetchPostsCateFifteen(String language, String country) async {
  try {
    LoadingPostsCateFifteen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/15',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateFifteen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateFifteen.value = false;
  }
}

///////////////.......................Sixteen.......................///////////////

RxBool LoadingPostsCateSixteen = false.obs;
var postsListCateSixteen = <Post>[].obs;

Future<void> fetchPostsCateSixteen(String language, String country) async {
  try {
    LoadingPostsCateSixteen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/16',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateSixteen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateSixteen.value = false;
  }
}

///////////////.......................Seventeen.......................///////////////

RxBool LoadingPostsCateSeventeen = false.obs;
var postsListCateSeventeen = <Post>[].obs;

Future<void> fetchPostsCateSeventeen(String language, String country) async {
  try {
    LoadingPostsCateSeventeen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/17',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateSeventeen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateSeventeen.value = false;
  }
}

///////////////.......................Eighteen.......................///////////////

RxBool LoadingPostsCateEighteen = false.obs;
var postsListCateEighteen = <Post>[].obs;

Future<void> fetchPostsCateEighteen(String language, String country) async {
  try {
    LoadingPostsCateEighteen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/18',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateEighteen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateEighteen.value = false;
  }
}

///////////////.......................Nineteen.......................///////////////

RxBool LoadingPostsCateNineteen = false.obs;
var postsListCateNineteen = <Post>[].obs;

Future<void> fetchPostsCateNineteen(String language, String country) async {
  try {
    LoadingPostsCateNineteen.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/19',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateNineteen.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateNineteen.value = false;
  }
}

///////////////.......................Twenty.......................///////////////

RxBool LoadingPostsCateTwenty = false.obs;
var postsListCateTwenty = <Post>[].obs;

Future<void> fetchPostsCateTwenty(String language, String country) async {
  try {
    LoadingPostsCateTwenty.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/20',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwenty.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwenty.value = false;
  }
}

///////////////.......................TwentyOne.......................///////////////

RxBool LoadingPostsCateTwentyOne = false.obs;
var postsListCateTwentyOne = <Post>[].obs;

Future<void> fetchPostsCateTwentyOne(String language, String country) async {
  try {
    LoadingPostsCateTwentyOne.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/21',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyOne.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyOne.value = false;
  }
}

///////////////.......................TwentyTwo.......................///////////////

RxBool LoadingPostsCateTwentyTwo = false.obs;
var postsListCateTwentyTwo = <Post>[].obs;

Future<void> fetchPostsCateTwentyTwo(String language, String country) async {
  try {
    LoadingPostsCateTwentyTwo.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/22',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyTwo.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyTwo.value = false;
  }
}

///////////////.......................TwentyThree.......................///////////////

RxBool LoadingPostsCateTwentyThree = false.obs;
var postsListCateTwentyThree = <Post>[].obs;

Future<void> fetchPostsCateTwentyThree(String language, String country) async {
  try {
    LoadingPostsCateTwentyThree.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/23',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyThree.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyThree.value = false;
  }
}

///////////////.......................TwentyFour.......................///////////////

RxBool LoadingPostsCateTwentyFour = false.obs;
var postsListCateTwentyFour = <Post>[].obs;

Future<void> fetchPostsCateTwentyFour(String language, String country) async {
  try {
    LoadingPostsCateTwentyFour.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/24',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyFour.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyFour.value = false;
  }
}

///////////////.......................TwentyFive.......................///////////////

RxBool LoadingPostsCateTwentyFive = false.obs;
var postsListCateTwentyFive = <Post>[].obs;

Future<void> fetchPostsCateTwentyFive(String language, String country) async {
  try {
    LoadingPostsCateTwentyFive.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/25',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyFive.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyFive.value = false;
  }
}

///////////////.......................TwentySix.......................///////////////

RxBool LoadingPostsCateTwentySix = false.obs;
var postsListCateTwentySix = <Post>[].obs;

Future<void> fetchPostsCateTwentySix(String language, String country) async {
  try {
    LoadingPostsCateTwentySix.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/26',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentySix.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentySix.value = false;
  }
}

///////////////.......................TwentySeven.......................///////////////

RxBool LoadingPostsCateTwentySeven = false.obs;
var postsListCateTwentySeven = <Post>[].obs;

Future<void> fetchPostsCateTwentySeven(String language, String country) async {
  try {
    LoadingPostsCateTwentySeven.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/27',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentySeven.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentySeven.value = false;
  }
}

///////////////.......................TwentyEight.......................///////////////

RxBool LoadingPostsCateTwentyEight = false.obs;
var postsListCateTwentyEight = <Post>[].obs;

Future<void> fetchPostsCateTwentyEight(String language, String country) async {
  try {
    LoadingPostsCateTwentyEight.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/28',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyEight.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyEight.value = false;
  }
}

///////////////.......................TwentyNine.......................///////////////

RxBool LoadingPostsCateTwentyNine = false.obs;
var postsListCateTwentyNine = <Post>[].obs;

Future<void> fetchPostsCateTwentyNine(String language, String country) async {
  try {
    LoadingPostsCateTwentyNine.value = true; // تم تصحيح الخطأ هنا
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/29',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateTwentyNine.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateTwentyNine.value = false;
  }
}

///////////////.......................Thirty.......................///////////////

RxBool LoadingPostsCateThirty = false.obs;
var postsListCateThirty = <Post>[].obs;

Future<void> fetchPostsCateThirty(String language, String country) async {
  try {
    LoadingPostsCateThirty.value = true;
    
    var uri = Uri.parse(
      'https://alamoodac.com/modac/public/latest-posts-by-category/$language/30',
    );

    if (country != null && country.isNotEmpty) {
      uri = uri.replace(queryParameters: {'country': country});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
final List<dynamic> jsonData = body['data'] as List<dynamic>;      postsListCateThirty.value = jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (e) {
    // Handle error
  } finally {
    LoadingPostsCateThirty.value = false;
  }
}

  /////////////////////////
  /////////////////////////

  RxBool hideForever = false.obs;
  RxBool shouldShowDialog = false.obs;
  Settingscontroller settingscontroller = Get.put(Settingscontroller());
  Future<void> loadPersistedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    hideForever.value = prefs.getBool('hide_publisher_forever') ?? false;

    // Only show dialog if not hidden forever
    shouldShowDialog.value = !hideForever.value;
  }

  Future<void> togglePermanentHide(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hide_publisher_forever', value);
    hideForever.value = value;
    shouldShowDialog.value = !value;
    isChosedMenu();
    settingscontroller.showPusher.value = true;
  }

  void temporarilyHideDialog() {
    shouldShowDialog.value = false;
  }

  ///////////////////مشاركة المنشور...................
  void handleDirectLink(String postId) async {
    try {
      final language =
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode;
      final post = await getPostById(int.parse(postId), language);

      if (post != null) {
        selectedPost.value = post;
        showDetailsPost.value = true;
        Get.offNamed('/post/$postId');
        _updateHistory(postId);
      }
    } catch (e) {
      Get.offAllNamed('/Decider');
    }
  }

  void _updateHistory(String postId) {
    html.window.history.replaceState(
        {'type': 'post', 'id': postId}, 'Post $postId', '/post/$postId');
  }

  Future<Post?> getPostById(int postId, String language) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://alamoodac.com/modac/public/post/share/$postId/$language"),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return Post.fromJson(jsonData);
      } else {
        print("❌ فشل في جلب المنشور: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المنشور: $e");
      return null;
    }
  }

  // في HomeController
  Future<void> fetchPostDetails(String postId) async {
    // showDetailsPost.value = true;
    try {
      // جلب البيانات بشكل غير متزامن
      Post? post = await getPostById(
       int.parse(postId) ,
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
      );
      if (post != null) {
        selectedPost.value = post;
        fetchPublisherList(
            selectedPost.value?.storeID ?? "",
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode);
        incrementViewsPost(selectedPost.value?.id ?? 0);
        fetchComments(selectedPost.value?.id ?? 0);
        if (int.parse(post.categoryId) == 8) {
          fetchAuctionByPostId(post.id.toString());
        }
      } else {
        print("❌ المنشور غير موجود!");
      }
    } catch (e) {
      print("❌ خطأ في جلب بيانات المنشور: $e");
    }
  }

  ////////////......زر المشاركة............////////////////
  void sharePost(int postId) {
    final String deepLink = 'https://alamoodac.com/post/$postId';
    Share.share('شاهد هذا المنشور: $deepLink');

    // إضافة الرابط لتاريخ المتصفح
    html.window.history.pushState(
      {'type': 'post', 'id': postId},
      'Post $postId',
      deepLink,
    );
  }

//////////////////////////////////
  restWhenBack() {
    currentPageIndex.value = 0;
    showDetailsPost.value = false;
    showTheBid.value = false;
    showTheComment.value = false;
  }

  ///////////////
  var isWhatsappHovered = false.obs;

  Future launchWhatsApp() async {
    // قم بتعديل رقم الهاتف والنص حسب احتياجاتك
    final whatsappUrl = "whatsapp://send?phone=+1234567890&text=مرحبا";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      // إذا لم يتم تثبيت تطبيق واتساب
      Get.snackbar(
        "تنبيه",
        "يبدو أن تطبيق WhatsApp غير مثبت على الجهاز",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } // المتحكم بالرسوم المتحركة

  final isWhatsappButtonVisible = false.obs;
  final isTextVisible = false.obs;
  final isHiding = false.obs;
  final isTooltipVisible = false.obs;

  // متحكمات الرسوم المتحركة
  late AnimationController pulseAnimationController;
  late Animation<double> pulseAnimation;
  void _initAnimations() {
    pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: pulseAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  // دوال تغيير الحالة
  void toggleVisibility() => isWhatsappButtonVisible.toggle();
  void showTooltip() => isTooltipVisible.value = true;
  void hideTooltip() => isTooltipVisible.value = false;

  @override
  void onClose() {
    pulseAnimationController.dispose();
    super.onClose();
  }

  Rx<String?> selectedCityName = Rx<String?>(null); // تغيير هنا
  RxString selectedprice = ''.obs;

  ///////////////////////////
  // أحدث 5 إعلانات بنرية
  var latestBannerAdsList = <BannerAd>[].obs;
  RxBool isLoadingLatestBannerAds = false.obs;

  // جلب أحدث 5 إعلانات بنرية
  Future<void> fetchLatestBannerAds() async {
    print(
        "is Done More One.................................................////////////////////////");
    isLoadingLatestBannerAds.value = true;
    try {
      final response = await http.get(
          Uri.parse('https://alamoodac.com/modac/public/banner-ads/latest'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          latestBannerAdsList.value =
              data.map((banner) => BannerAd.fromJson(banner)).toList();

          print("تم جلب الاعلانات البنرية");
        } else {}
      } else {}
    } catch (e) {
    } finally {
      isLoadingLatestBannerAds.value = false;
    }
  }


  void showSettingsPopup(BuildContext context) {
    // الحصول على المتحكم الخاص بتغيير اللغة
    final changeLanguageController = Get.find<ChangeLanguageController>();
    bool isArabic =
        changeLanguageController.currentLocale.value.languageCode == 'ar';

    // الحصول على أبعاد الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // تحديد عرض النافذة الجديد بحيث يكون أقل من نصف الشاشة (مثلاً 35٪)
    double popupWidth = screenWidth * 0.30;

    // ضبط المحاذاة بناءً على اللغة: إذا كانت عربية تظهر من اليمين، وإلا من اليسار
    Alignment alignment =
        isArabic ? Alignment.centerRight : Alignment.centerLeft;

    // ضبط الهوامش: إذا كانت اللغة عربية، نترك فراغ من اليسار بما يساوي باقي العرض؛ وإذا كانت لغة أخرى، من اليمين
    EdgeInsets insetPadding = isArabic
        ? EdgeInsets.only(left: screenWidth - popupWidth, top: 0, bottom: 0)
        : EdgeInsets.only(right: screenWidth - popupWidth, top: 0, bottom: 0);

    Get.dialog(
      Align(
        alignment: alignment,
        child: Dialog(
          elevation: 10,
          backgroundColor: Colors.transparent,
          insetPadding: insetPadding,
          // إزالة التقوس لتحقيق شكل متماسك مع حافة الشاشة
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            width: popupWidth, // عرض النافذة الجديد
            height: screenHeight, // تغطي ارتفاع الشاشة بالكامل
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const SettingsContentDeskTopPage(),
          ),
        ),
      ),
      barrierColor: Colors.black54,
      barrierDismissible: true,
    );
  }

  final isHovered = false.obs;

  void setHoverState(bool value) {
    isHovered.value = value;
  }

  void openPostDetails(Post post) {
    final controller = Get.find<HomeController>();
    controller.setSelectedPost(post);

    Get.toNamed(
      '/post/${post.id}', // المسار مع المعلمة الديناميكية

      arguments: post, // إرسال الكائن كامل
    );
  }

  RxBool isSearchFromHome = false.obs;
  ClickSearchHome(BuildContext context) {
    if (isSearchFromHome.value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
            child: CircularProgressIndicator(
          color: AppColors.TheMain,
          backgroundColor: AppColors.whiteColor,
        )),
      );
      Future.delayed(Duration(seconds: 3));
      Get.to(SearchScreenDesktop());
      isSearchFromHome.value = true;
      Navigator.of(context, rootNavigator: true).pop();
    } else {}
  }

/////////////.....جلب منشورات الناشر..........///////

  RxBool loadingPublisherData = false.obs;
  var PublisherListList = <Post>[].obs;

  Future<void> fetchPublisherList(String id, String language) async {
    try {
      loadingPublisherData.value = true;
      final response = await http.get(
        Uri.parse(
            'https://alamoodac.com/modac/public/post/publisher/$id/$language'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          // حالة مصفوفة مباشرة
          PublisherListList.value = (decoded as List)
              .cast<Map<String, dynamic>>()
              .map(Post.fromJson)
              .toList();

          print("get");
        } else if (decoded is Map<String, dynamic>) {
          print("getOne");
          loadingPublisherData.value = false;
          // حالة كائن مفرد
          PublisherListList.value = [Post.fromJson(decoded)];
          loadingPublisherData.value = false;
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error loading posts: $e");
    } finally {
      loadingPublisherData.value = false;
    }
  }

  //////////////////////////////////////////......Messages...................//////////

  /// رسالة ترحيبية عند إنشاء حساب جديد
  static const welcomeAccountMessage = {
    "ar":
        "مرحباً بك في تطبيقنا! تم إنشاء حسابك بنجاح، ونحن سعداء بانضمامك إلينا.",
    "en":
        "Welcome to our app! Your account has been created successfully, and we are delighted to have you with us."
  };

  /// رسالة عند طلب باقة (نوضح للمستخدم الرجاء الانتظار)
  static const packageRequestMessage = {
    "ar": "طلبك قيد المعالجة. يرجى الانتظار حتى يتم تفعيل باقتك.",
    "en":
        "Your package request is being processed. Please wait until your package is activated."
  };

  /// رسالة عند إنشاء بيانات منشور جديد (منشور تحت المراجعة)
  static const postCreationMessage = {
    "ar":
        "شكرًا لإنشاء منشورك! منشورك الآن تحت المراجعة وسيتم نشره بعد الموافقة.",
    "en":
        "Thank you for creating your post! Your post is now under review and will be published once approved."
  };

  /// رسالة عند إنشاء بيانات ناشر جديد (يمكن النشر الآن)
  static const publisherCreationMessage = {
    "ar":
        "تم إنشاء بيانات الناشر بنجاح. يمكنك الآن النشر باستخدام بيانات الناشر الجديدة، شكرًا لانضمامك إلينا.",
    "en":
        "Your publisher profile has been created successfully. You can now publish using your new publisher data. Thank you for joining us."
  };

  Future<void> sendMessage({
    required var userId,
    required int whatType, // true للموافقة، false للرفض
  }) async {
    const url = 'https://alamoodac.com/modac/public/messages';

    final message = whatType == 1
        ? welcomeAccountMessage
        : whatType == 2
            ? packageRequestMessage
            : whatType == 3
                ? postCreationMessage
                : publisherCreationMessage;

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'message_ar': message['ar'],
        'message_en': message['en'],
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Message sent successfully");
    } else {
      print("❌ Failed to send message: ${response.body}");
    }
  }
  Future<void> checkExpiredPosts() async {
  final url = Uri.parse('https://alamoodac.com/modac/public/posts/check-expired');
  await http.get(url, headers: {
    'Accept': 'application/json',
    // إذا كنت تستخدم مصادقة:
    // 'Authorization': 'Bearer YOUR_TOKEN',
  });
}
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/constant/app_text_styles.dart';
import '../core/constant/appcolors.dart';
import '../core/data/model/City.dart';
import '../core/data/model/Stores.dart';
import '../core/data/model/category.dart';
import 'package:http/http.dart' as http;

import '../core/data/model/post.dart';
import '../core/data/model/subcategory_level_one.dart';
import '../core/data/model/subcategory_level_two.dart';
import '../core/localization/changelanguage.dart';
import '../customWidgets/DropdownFieldWithIcons.dart';
import 'LoadingController.dart';
import 'areaController.dart';
import 'home_controller.dart';

class Searchcontroller extends GetxController {
  RxInt selectIdToSearch = 0.obs;
  String? idCate;
  AreaController areaController = Get.put(AreaController());
  HomeController homeController = Get.put(HomeController());
  RxBool getDataForOneTime = false.obs;
  void onInit() {
    super.onInit();
    _setupDebounce();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    homeController.loadSelectedRoute();

    if (getDataForOneTime.value) return;

    await _fetchEssentialData();
    await _fetchLocationDependentData();

    getDataForOneTime.value = true;
  }

  void _setupDebounce() {
    debounce(textSearching, (_) => performSearch(), time: 500.milliseconds);
  }

  Future<void> _fetchEssentialData() async {
    final lang =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    // جلب البيانات المتعلقة ببعضها بالتسلسل
    await fetchCategories(lang);
    await fetchSubcategories(3, lang);
  }

  Future<void> _fetchLocationDependentData() async {
    final countryCode = _getCountryCode();
    final lang =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    // جلب البيانات غير المرتبطة ببعضها بشكل متوازي
    await Future.wait([
      fetchCities(countryCode, lang),
      fetchStoresList(language: lang),
      _fetchInitialPosts(),
    ]);
  }

  String _getCountryCode() {
    final route = homeController.selectedRoute.value;
    return {
          'تركيا': 'TR',
          'سوريا': 'SY',
          'العراق': 'IQ',
        }[route] ??
        'IQ';
  }

  Future<void> _fetchInitialPosts() async {
    await fetchSearchPosts(
      language:
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
      categoryId: idOfCate,
      subcategoryId: idOfSub,
      subcategoryLevel2Id: idOfSubTwo,
      searchTerm: textSearching.value,
      cityId: chosedIdCity,
    );
  }

  Future<void> refreshData() async {
    try {
      // إعادة تعيين البيانات مع الاحتفاظ بالسياسة التخزينية
      getDataForOneTime.value = false;
      await _fetchLocationDependentData();
      await _fetchEssentialData();
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to refresh search data'.tr);
    }
  }
///////////////
  /////////////////////////////...........Searching.............................///////////

  var searchPostsList = <Post>[].obs;
  RxBool loadingSearchPosts = false.obs;

  Future<void> fetchSearchPosts({
    required String language,
    var categoryId,
    var subcategoryId,
    var subcategoryLevel2Id,
    var searchTerm,
    var cityId,
  }) async {
    try {
      loadingSearchPosts.value = true;

      // بناء الرابط الديناميكي مع اللغة كجزء رئيسي
      String url = 'https://alamoodac.com/modac/public/search-posts/$language';

      // إضافة categoryId، subcategoryId، subcategoryLevel2Id في الرابط حتى لو كانت قيمتها NULL
      url += '/${(categoryId != null && categoryId > 0) ? categoryId : 'NULL'}';
      url +=
          '/${(subcategoryId != null && subcategoryId > 0) ? subcategoryId : 'NULL'}';
      url +=
          '/${(subcategoryLevel2Id != null && subcategoryLevel2Id > 0) ? subcategoryLevel2Id : 'NULL'}';

      // إضافة searchTerm إذا كان موجودًا
      url +=
          '/${(searchTerm != null && searchTerm.isNotEmpty) ? searchTerm : 'NULL'}';

      // إضافة cityId إذا كان موجودًا
      url += '/${(cityId != null && cityId > 0) ? cityId : 'NULL'}';

      print("Fetching posts from URL: $url");

      // إجراء الطلب HTTP
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // معالجة البيانات المستلمة وتحويلها إلى قائمة من المنشورات
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور
      } else {
        throw Exception('Failed to load search posts');
      }
    } catch (e) {
    } finally {
      loadingSearchPosts.value = false;
    }
  }

////////////////////////
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

        if (homeController.selectedRoute.value == 'تركيا') {
          fetchedCategories.removeWhere((category) => category.id == 10);
        }

        categoriesList.value = fetchedCategories;
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

/////////////////
  ////////////............المدن....................................///////////////////////
  int chosedIdCity = 0;
  var citiesList = <TheCity>[].obs; // قائمة قابلة للمراقبة
  RxBool isLoadingCities = false.obs;
  int? idCity;
  Future<void> fetchCities(String Cont, String language) async {
    isLoadingCities.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://alamoodac.com/modac/public/cities/$Cont/$language'),
      );

      if (response.statusCode == 200) {
        // print("استجابة الخادم: ${response.body}");

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
          //print("تم تحميل البيانات بنجاح: ${citiesList.length} مدينة");
        } else {
          // print("البيانات غير متوفرة أو غير صحيحة.");
        }
      } else {
        //  print("خطأ في تحميل البيانات: ${response.statusCode}");
      }
    } catch (e) {
      // print("حدث خطأ أثناء الاتصال بالخادم: $e");
    } finally {
      isLoadingCities.value = false;
    }
  }

  // متغيرات البحث
  final TextEditingController isSearchText = TextEditingController();
  RxString textSearching = "".obs;
  RxInt idOfCateSearchBox = 3.obs;

  // القوائم والمتغيرات
  var categoriesList = <Category>[].obs;
  RxBool isLoadingCategories = false.obs;
  int idOfCate = 0;

  // الأقسام الفرعية الأولى
  int idOfSub = 0;
  RxBool isChosedAndShowTheSub = false.obs;
  RxBool isLoadingSubcategoryLevelOne = false.obs;
  var subCategories = <SubcategoryLevelOne>[].obs;

  // الأقسام الفرعية الثانية
  RxBool isChosedAndShowTheSubTwo = false.obs;
  RxBool isLoadingSubcategoryLevelTwo = false.obs;

  int idOfSubTwo = 0;

  // جلب الأقسام الرئيسية
  var subcategoriesLevelTwo = <SubcategoryLevelTwo>[].obs;
  // جلب الأقسام الفرعية الأولى
  Future<void> fetchSubcategories(int categoryId, String language) async {
    isLoadingSubcategoryLevelOne.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/subcategories?category_id=$categoryId&language=$language'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null) {
          subCategories.value = (data as List)
              .map((subcategory) => SubcategoryLevelOne.fromJson(subcategory))
              .toList();
          isChosedAndShowTheSub.value = true;
        }
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    } finally {
      isLoadingSubcategoryLevelOne.value = false;
    }
  }

  // جلب الأقسام الفرعية الثانية
  Future<void> fetchSubcategoriesLevelTwo(
      int subCategoryLevelOneId, String language) async {
    isLoadingSubcategoryLevelTwo.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/subcategories-level-two?sub_category_level_one_id=$subCategoryLevelOneId&language=$language'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null && data['data'] != null) {
          subcategoriesLevelTwo.value = (data['data'] as List)
              .map((subcategoryTwo) =>
                  SubcategoryLevelTwo.fromJson(subcategoryTwo))
              .toList();
          isChosedAndShowTheSubTwo.value = subcategoriesLevelTwo.isNotEmpty;
        }
      }
    } catch (e) {
      print('Error fetching subcategories level two: $e');
    } finally {
      isLoadingSubcategoryLevelTwo.value = false;
    }
  }

  void resetCategorySelectionInSubPost() {
    homeController.fetchPostsAll(
      idOfCateSearchBox.value,
      Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
      null,
      null,
    );

    selectedTimeRange.value = "all_time";

    homeController.chosedIdCity.value = null;
    areaController.idOfArea.value = null;
  }

  // إعادة تعيين الأقسام
  void resetCategorySelection() {
    fetchSearchPosts(
      language:
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
    );
    idOfCateSearchBox.value = 0;
    subCategories.clear();
    subcategoriesLevelTwo.clear();
    isSearchText.clear();
    isChosedAndShowTheSub.value = false;
    isChosedAndShowTheSubTwo.value = false;
    selectedMainCategory = null;
    selectedSubCategory = null;
    selectedSubCategoryLevel2 = null;
    selectedTimeRange.value = "all_time";

    homeController.chosedIdCity.value = null;
    areaController.idOfArea.value = null;
  }

  void resetSubCategorySelection() {
    idOfSub = 0;
    subcategoriesLevelTwo.clear();
    isChosedAndShowTheSubTwo.value = false;
  }

  void resetSubCategoryLevelTwoSelection() {
    idOfSubTwo = 0;
  }

  // وظيفة البحث
  void performSearch() {
    // إضافة منطق البحث هنا
  }

//////////

  RxBool isShowSearchingBox = false.obs;

  showTheshowSearchingBox() {
    if (isShowSearchingBox.value == true) {
      isShowSearchingBox.value = false;
    } else {
      isShowSearchingBox.value = true;
    }
  }

  //////////////////////////////////////

// المتغيرات الخاصة بالمنشورات القريبة

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
          context: context);
    }
  }

  RxBool showMap = false.obs;
  Future<void> fetchNearbyPosts({
    required double latitude,
    required double longitude,
    required String language,
    double radius = 10.0,
    String? categoryId, // معرف القسم الرئيسي اختياري
    required BuildContext context,
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
      loadingSearchPosts.value = true;

      // بناء الرابط الأساسي مع معلمات الموقع واللغة
      String url = 'https://alamoodac.com/modac/public/posts/nearby';
      url +=
          '?latitude=$latitude&longitude=$longitude&radius=$radius&language=$language';

      // إذا تم تمرير معرف القسم الرئيسي، يتم إضافته إلى الرابط
      if (categoryId != null && categoryId.isNotEmpty) {
        url += '&category_id=$categoryId';
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
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
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
        Get.back();
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
    } finally {
      loadingSearchPosts.value = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  ////////////////.....................المــتاجر........................///////////////////
  RxBool isShowPostsOrStores = false.obs;
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

  RxBool showDetailsStores = false.obs;
  RxInt currentPageStoreIndex = 0.obs;
  Rxn<Stores> selectedStores = Rxn<Stores>();

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

        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  } /////////////////جلب منشورات المتجر

  RxBool LoadingPostsStore = false.obs;
  var postsListStore = <Post>[].obs;

  // إضافة قائمة `RxInt` لكل منشور
  RxList<RxInt> postPageIndexesStore = <RxInt>[].obs;

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
        postPageIndexesStore.value =
            List.generate(postsListStore.length, (index) => 0.obs);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error loading posts: $e");
    } finally {
      LoadingPostsStore.value = false;
    }
  } ////////////..............البحث عن المتاجر الأقرب......................../////////////////////////

  var nearbyStoresList = <Stores>[].obs;
  RxBool loadingNearbyStores = false.obs;
  RxList<RxInt> nearbyStorePageIndexes = <RxInt>[].obs;
  Future<void> fetchNearbyStores({
    required double latitude,
    required double longitude,
    required String language,
    double radius = 10.0,
    required BuildContext context,
  }) async {
    try {
      // عرض دائرة التحميل أثناء جلب البيانات
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
      loadingNearbyStores.value = true;

      // بناء الـ URL بناءً على المعاملات
      String url =
          'https://alamoodac.com/modac/public/nearby-stores/$language/$latitude/$longitude';

      // إضافة نصف القطر إذا كان موجودًا
      if (radius != 10.0) {
        url += '?radius=$radius';
      }

      print("Fetching nearby stores from URL: $url");

      // إرسال الطلب عبر الـ HTTP
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        try {
          // تحقق من وجود HTML في الاستجابة
          if (response.body.contains('<html>')) {
            print("Error: HTML response received instead of JSON.");
            throw Exception('Received HTML instead of JSON');
          }

          // طباعة الاستجابة لمراجعتها
          print("Response body: ${response.body}");

          // تحليل الاستجابة JSON والوصول إلى المفتاح 'data'
          Map<String, dynamic> responseData = json.decode(response.body);
          List<dynamic> jsonData =
              responseData['data']; // استخراج المتاجر من 'data'

          // تعبئة قائمة المتاجر
          nearbyStoresList.value =
              jsonData.map((store) => Stores.fromJson(store)).toList();

          // إنشاء فهرس لكل متجر لربط كل متجر مع فهرس خاص
          nearbyStorePageIndexes.value =
              List.generate(nearbyStoresList.length, (index) => 0.obs);
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to load nearby stores');
      }
    } catch (e) {
      print("Error loading nearby stores: $e");
    } finally {
      loadingNearbyStores.value = false;
      Navigator.of(context, rootNavigator: true).pop(); // إغلاق دائرة التحميل
    }
  }

  //////////////////////////.......Searching Box...............................///////////////
  RxBool searchingBox = false.obs;

//////////////////////////////.................Cars..........................//////////

  // خريطة التحكم بالفلاتر
  // قائمة الـ Controllers الخاصة بالفلترة
  ////////////////////////...........فلترة السيارات.....................////////////
  ///////////عام للجميع
  // النطاق الزمني الافتراضي
  RxString selectedTimeRange = "all_time".obs; // القيمة الافتراضية "كل الأوقات"
  RxBool isOpenINSubPost = false.obs;
// متغيرات الأقسام (قيمها مبدئيًا null)
  int? selectedMainCategory;
  int? selectedSubCategory;
  int? selectedSubCategoryLevel2;

// دالة لتحويل الأرقام العربية إلى إنجليزية
  String convertArabicNumbers(String input) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    const englishDigits = '0123456789';

    return input.split('').map((char) {
      int index = arabicDigits.indexOf(char);
      return index != -1 ? englishDigits[index] : char;
    }).join('');
  }

// الكنترولرز الخاصة بتفاصيل السيارة (تم إزالة حقول الأقسام)
  final Map<String, TextEditingController> detailCarControllers = {
    "حالة السيارة".tr: TextEditingController(),
    "عدد المقاعد".tr: TextEditingController(),
    "النوع".tr: TextEditingController(),
    "حالة الهيكل".tr: TextEditingController(),
    "سعة المحرك".tr: TextEditingController(),
    "نوع ناقل الحركة".tr: TextEditingController(),
    "نوع الوقود".tr: TextEditingController(),
    "السعر الأدنى".tr: TextEditingController(),
    "السعر الأعلى".tr: TextEditingController(),
  };

// متغيرات معرف المدينة ومعرف المنطقة يتم استخدامها من homeController و areaController

// دالة جمع الفلاتر
  Map<String, dynamic> getFiltersFromCarControllers() {
    final Map<String, dynamic> filters = {};

    // تجميع فلاتر التفاصيل من المتحكمات
    detailCarControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        String convertedText = convertArabicNumbers(controller.text);

        if (key == "السعر الأدنى".tr) {
          int? minPrice = int.tryParse(convertedText);
          if (minPrice != null && minPrice > 0) {
            filters["min_price"] = minPrice;
          }
        } else if (key == "السعر الأعلى".tr) {
          int? maxPrice = int.tryParse(convertedText);
          if (maxPrice != null && maxPrice > 0) {
            filters["max_price"] = maxPrice;
          }
        } else {
          filters[key] = convertedText;
        }
      }
    });

    // إضافة الفلاتر الخاصة بالأقسام إذا لم تكن null
    if (selectedMainCategory != null) {
      filters["القسم الرئيسي"] = selectedMainCategory;
    }
    if (selectedSubCategory != null) {
      filters["القسم الفرعي"] = selectedSubCategory;
    }
    if (selectedSubCategoryLevel2 != null) {
      filters["القسم الفرعي الثاني"] = selectedSubCategoryLevel2;
    }

    // إضافة معرف المدينة ومعرف المنطقة إن وُجدا
    if (homeController.chosedIdCity.value != null) {
      filters["id_city"] = homeController.chosedIdCity.value;
    }
    if (areaController.idOfArea.value != null) {
      filters["area_id"] = areaController.idOfArea.value;
    }

    // إضافة فلترة النطاق الزمني إذا تم تحديده
    if (selectedTimeRange.value.isNotEmpty) {
      filters["time_range"] = selectedTimeRange.value;
    }

    return filters;
  }

// دالة فلترة المنشورات
  Future<void> filterPosts(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
    );

    final Map<String, dynamic> filters = getFiltersFromCarControllers();
    print("الفلترة المرسلة:$filters");
    if (filters.isEmpty ||
        (filters.length == 1 &&
            (filters.containsKey("min_price") ||
                filters.containsKey("max_price")))) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        "خطأ".tr,
        "يرجى إدخال قيم صالحة للفلترة".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    filters['language'] =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    try {
      final response = await http.post(
        Uri.parse('https://alamoodac.com/modac/public/filter-posts'),
        body: jsonEncode(filters),
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        homeController.postsListAll.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // في حال عدم وجود نتائج، يتم إعادة تعيين جميع القيم إلى حالتها الافتراضية
        if (searchPostsList.isEmpty) {
          Get.snackbar(
            duration: const Duration(seconds: 7),
            "تنبيه".tr,
            "لم يتم العثور على نتائج مطابقة..لذا سيتم إرجاع جميع المنشورات".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          // إعادة تعيين متحكمات تفاصيل السيارة
          detailCarControllers.forEach((key, controller) {
            controller.clear();
          });

          // إعادة تعيين متغيرات الأقسام والنطاق الزمني
          selectedMainCategory = null;
          selectedSubCategory = null;
          selectedSubCategoryLevel2 = null;
          selectedTimeRange.value = "all_time";

          // يمكن أيضاً إعادة تعيين معرّف المدينة والمنطقة إن أردت ذلك
          // homeController.chosedIdCity.value = null;
          // areaController.idOfArea.value = null;

          // استدعاء دالة جلب المنشورات العامة بدون فلترة
          fetchSearchPosts(
            language: Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );

          if (isOpenINSubPost.value) {
            homeController.fetchPostsAll(
              idOfCateSearchBox.value,
              Get.find<ChangeLanguageController>()
                  .currentLocale
                  .value
                  .languageCode,
              null,
              null,
            );
          }
        } else {
          Get.snackbar(
            "نجاح".tr,
            "تم جلب البيانات بنجاح".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "خطأ".tr,
          "فشل في جلب البيانات".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        "خطأ".tr,
        "حدث خطأ أثناء محاولة الاتصال بالخادم".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //////////////////////...................فلترة العقارات....................//////////
// دالة تحويل الأرقام العربية إلى إنجليزية
  final Map<String, TextEditingController> detailRealestateControllers = {
    "عدد الغرف".tr: TextEditingController(),
    "عدد الحمامات".tr: TextEditingController(),
    "عدد الطوابق".tr: TextEditingController(),
    "مساحة البناء".tr: TextEditingController(),
    "مساحة الارض".tr: TextEditingController(),
    "عمر البناء".tr: TextEditingController(),
    "طريقة الدفع".tr: TextEditingController(),
    "السعر الأدنى".tr: TextEditingController(),
    "السعر الأعلى".tr: TextEditingController(),
  };
// متغيرات معرف المدينة ومعرف المنطقة يتم استخدامها من homeController و areaController

// دالة جمع الفلاتر
  Map<String, dynamic> getFiltersFromRealestateControllers() {
    final Map<String, dynamic> filters = {};

    // تجميع فلاتر التفاصيل من المتحكمات
    detailRealestateControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        String convertedText = convertArabicNumbers(controller.text);

        if (key == "السعر الأدنى".tr) {
          int? minPrice = int.tryParse(convertedText);
          if (minPrice != null && minPrice > 0) {
            filters["min_price"] = minPrice;
          }
        } else if (key == "السعر الأعلى".tr) {
          int? maxPrice = int.tryParse(convertedText);
          if (maxPrice != null && maxPrice > 0) {
            filters["max_price"] = maxPrice;
          }
        } else {
          filters[key] = convertedText;
        }
      }
    });

    // إضافة الفلاتر الخاصة بالأقسام إذا لم تكن null
    if (selectedMainCategory != null) {
      filters["القسم الرئيسي"] = selectedMainCategory;
    }
    if (selectedSubCategory != null) {
      filters["القسم الفرعي"] = selectedSubCategory;
    }
    if (selectedSubCategoryLevel2 != null) {
      filters["القسم الفرعي الثاني"] = selectedSubCategoryLevel2;
    }

    // إضافة معرف المدينة ومعرف المنطقة إن وُجدا
    if (homeController.chosedIdCity.value != null) {
      filters["id_city"] = homeController.chosedIdCity.value;
    }
    if (areaController.idOfArea.value != null) {
      filters["area_id"] = areaController.idOfArea.value;
    }

    // إضافة فلترة النطاق الزمني إذا تم تحديده
    if (selectedTimeRange.value.isNotEmpty) {
      filters["time_range"] = selectedTimeRange.value;
    }

    return filters;
  }

// دالة فلترة المنشورات
  // دالة فلترة المنشورات
  Future<void> filterPostsRealestate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
    );

    final Map<String, dynamic> filters = getFiltersFromRealestateControllers();

    if (filters.isEmpty ||
        (filters.length == 1 &&
            (filters.containsKey("min_price") ||
                filters.containsKey("max_price")))) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        "خطأ".tr,
        "يرجى إدخال قيم صالحة للفلترة".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    filters['language'] =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    try {
      final response = await http.post(
        Uri.parse('https://alamoodac.com/modac/public/filter-posts'),
        body: jsonEncode(filters),
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        homeController.postsListAll.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // في حال عدم وجود نتائج، يتم إعادة تعيين جميع القيم إلى حالتها الافتراضية
        if (searchPostsList.isEmpty) {
          Get.snackbar(
            duration: const Duration(seconds: 7),
            "تنبيه".tr,
            "لم يتم العثور على نتائج مطابقة..لذا سيتم إرجاع جميع المنشورات".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          // إعادة تعيين متحكمات تفاصيل السيارة
          detailRealestateControllers.forEach((key, controller) {
            controller.clear();
          });

          // إعادة تعيين متغيرات الأقسام والنطاق الزمني
          selectedMainCategory = null;
          selectedSubCategory = null;
          selectedSubCategoryLevel2 = null;
          selectedTimeRange.value = "all_time";

          // يمكن أيضاً إعادة تعيين معرّف المدينة والمنطقة إن أردت ذلك
          // homeController.chosedIdCity.value = null;
          // areaController.idOfArea.value = null;

          // استدعاء دالة جلب المنشورات العامة بدون فلترة
          fetchSearchPosts(
            language: Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );
          if (isOpenINSubPost.value) {
            homeController.fetchPostsAll(
              idOfCateSearchBox.value,
              Get.find<ChangeLanguageController>()
                  .currentLocale
                  .value
                  .languageCode,
              null,
              null,
            );
          }
        } else {
          Get.snackbar(
            "نجاح".tr,
            "تم جلب البيانات بنجاح".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "خطأ".tr,
          "فشل في جلب البيانات".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        "خطأ".tr,
        "حدث خطأ أثناء محاولة الاتصال بالخادم".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

//////////////////////////////////////////////////

  final Map<String, TextEditingController> detailAllTypesControllers = {
    "السعر الأدنى".tr: TextEditingController(),
    "السعر الأعلى".tr: TextEditingController(),
  };
// متغيرات معرف المدينة ومعرف المنطقة يتم استخدامها من homeController و areaController

// دالة جمع الفلاتر
  Map<String, dynamic> getFiltersFromAllTypesControllers() {
    final Map<String, dynamic> filters = {};

    // تجميع فلاتر التفاصيل من المتحكمات
    detailAllTypesControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        String convertedText = convertArabicNumbers(controller.text);

        if (key == "السعر الأدنى".tr) {
          int? minPrice = int.tryParse(convertedText);
          if (minPrice != null && minPrice > 0) {
            filters["min_price"] = minPrice;
          }
        } else if (key == "السعر الأعلى".tr) {
          int? maxPrice = int.tryParse(convertedText);
          if (maxPrice != null && maxPrice > 0) {
            filters["max_price"] = maxPrice;
          }
        } else {
          filters[key] = convertedText;
        }
      }
    });

    // إضافة الفلاتر الخاصة بالأقسام إذا لم تكن null
    if (selectedMainCategory != null) {
      filters["القسم الرئيسي"] = selectedMainCategory;
    }
    if (selectedSubCategory != null) {
      filters["القسم الفرعي"] = selectedSubCategory;
    }
    if (selectedSubCategoryLevel2 != null) {
      filters["القسم الفرعي الثاني"] = selectedSubCategoryLevel2;
    }

    // إضافة معرف المدينة ومعرف المنطقة إن وُجدا
    if (homeController.chosedIdCity.value != null) {
      filters["id_city"] = homeController.chosedIdCity.value;
    }
    if (areaController.idOfArea.value != null) {
      filters["area_id"] = areaController.idOfArea.value;
    }

    // إضافة فلترة النطاق الزمني إذا تم تحديده
    if (selectedTimeRange.value.isNotEmpty) {
      filters["time_range"] = selectedTimeRange.value;
    }

    return filters;
  }

// دالة فلترة المنشورات
  Future<void> filterPostsAllTypes(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
    );

    final Map<String, dynamic> filters = getFiltersFromAllTypesControllers();

    filters['language'] =
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode;

    try {
      final response = await http.post(
        Uri.parse('https://alamoodac.com/modac/public/filter-posts'),
        body: jsonEncode(filters),
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        homeController.postsListAll.value =
            jsonData.map((post) => Post.fromJson(post)).toList();

        // في حال عدم وجود نتائج، يتم إعادة تعيين جميع القيم إلى حالتها الافتراضية
        if (searchPostsList.isEmpty) {
          Get.snackbar(
            duration: const Duration(seconds: 7),
            "تنبيه".tr,
            "لم يتم العثور على نتائج مطابقة..لذا سيتم إرجاع جميع المنشورات".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          // إعادة تعيين متحكمات تفاصيل
          detailAllTypesControllers.forEach((key, controller) {
            controller.clear();
          });

          // إعادة تعيين متغيرات الأقسام والنطاق الزمني
          selectedMainCategory = null;
          selectedSubCategory = null;
          selectedSubCategoryLevel2 = null;
          selectedTimeRange.value = "all_time";

          // يمكن أيضاً إعادة تعيين معرّف المدينة والمنطقة إن أردت ذلك
          // homeController.chosedIdCity.value = null;
          // areaController.idOfArea.value = null;

          // استدعاء دالة جلب المنشورات العامة بدون فلترة
          fetchSearchPosts(
            language: Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );
          if (isOpenINSubPost.value) {
            homeController.fetchPostsAll(
              idOfCateSearchBox.value,
              Get.find<ChangeLanguageController>()
                  .currentLocale
                  .value
                  .languageCode,
              null,
              null,
            );
          }
        } else {
          Get.snackbar(
            "نجاح".tr,
            "تم جلب البيانات بنجاح".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "خطأ".tr,
          "فشل في جلب البيانات".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        "خطأ".tr,
        "حدث خطأ أثناء محاولة الاتصال بالخادم".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

///////////////........فلترة بقية الاقسام....................///////

  ///////.........العرض حسب.............................................................///////////////
  Future<void> fetchLatestPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/f/latest/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load latest posts');
      }
    } catch (e) {
      print("Error loading latest posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchOldestPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/oldest/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load oldest posts');
      }
    } catch (e) {
      print("Error loading oldest posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchCheapestPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/cheapest/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load cheapest posts');
      }
    } catch (e) {
      print("Error loading cheapest posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchMostExpensivePosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/most-expensive/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load most expensive posts');
      }
    } catch (e) {
      print("Error loading most expensive posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchHighestRatedPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/highest-rated/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load highest rated posts');
      }
    } catch (e) {
      print("Error loading highest rated posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchLowestRatedPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/lowest-rated/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load lowest rated posts');
      }
    } catch (e) {
      print("Error loading lowest rated posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchMostViewedPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/most-viewed/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load most viewed posts');
      }
    } catch (e) {
      print("Error loading most viewed posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

  Future<void> fetchLeastViewedPosts(
      {required String language, String? categoryId}) async {
    try {
      loadingSearchPosts.value = true;

      Map<String, String>? queryParams;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams = {'category_id': categoryId};
      }

      Uri uri = Uri(
        scheme: 'https',
        host: 'alamoodac.com',
        path: '/modac/public/least-viewed/$language',
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        searchPostsList.value =
            jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load least viewed posts');
      }
    } catch (e) {
      print("Error loading least viewed posts: $e");
    } finally {
      loadingSearchPosts.value = false;
    }
  }

///////////////////////////////////////////////

////////////////////////////////////////////////
  RxInt isOpenFromSub = 0.obs;
  final CarBrand defaultBrand = CarBrand(
    arabicName: 'غير مذكور',
    englishName: 'Not Specified',
    turkishName: 'Belirtilmemiş',
    kurdishName: 'Nehatî diyar kirin',
    iconData: Icons.question_mark,
  );

  CarBrand? selectedBrand;

  List<CarBrand> carBrands = [
    // ماركات عالمية
    CarBrand(
      arabicName: 'تويوتا',
      englishName: 'Toyota',
      turkishName: 'Toyota',
      kurdishName: 'Toyota',
      customLogo: 'assets/logos/toyota.svg',
    ),
    CarBrand(
      arabicName: 'فولكسفاغن',
      englishName: 'Volkswagen',
      turkishName: 'Volkswagen',
      kurdishName: 'Volkswagen',
      customLogo: 'assets/logos/volkswagen.svg',
    ),
    CarBrand(
      arabicName: 'فورد',
      englishName: 'Ford',
      turkishName: 'Ford',
      kurdishName: 'Ford',
      customLogo: 'assets/logos/ford.svg',
    ),
    CarBrand(
      arabicName: 'هوندا',
      englishName: 'Honda',
      turkishName: 'Honda',
      kurdishName: 'Honda',
      customLogo: 'assets/logos/honda.svg',
    ),
    CarBrand(
      arabicName: 'مرسيدس-بنز',
      englishName: 'Mercedes-Benz',
      turkishName: 'Mercedes-Benz',
      kurdishName: 'Mercedes-Benz',
      customLogo: 'assets/logos/mercedes.svg',
    ),
    CarBrand(
      arabicName: 'بي إم دبليو',
      englishName: 'BMW',
      turkishName: 'BMW',
      kurdishName: 'BMW',
      customLogo: 'assets/logos/bmw.svg',
    ),
    CarBrand(
      arabicName: 'نيسان',
      englishName: 'Nissan',
      turkishName: 'Nissan',
      kurdishName: 'Nissan',
      customLogo: 'assets/logos/nissan.svg',
    ),
    CarBrand(
      arabicName: 'أودي',
      englishName: 'Audi',
      turkishName: 'Audi',
      kurdishName: 'Audi',
      customLogo: 'assets/logos/audi.svg',
    ),

    // ماركات فاخرة
    CarBrand(
      arabicName: 'بورش',
      englishName: 'Porsche',
      turkishName: 'Porsche',
      kurdishName: 'Porsche',
      customLogo: 'assets/logos/porsche.svg',
    ),
    CarBrand(
      arabicName: 'فيراري',
      englishName: 'Ferrari',
      turkishName: 'Ferrari',
      kurdishName: 'Ferrari',
      customLogo: 'assets/logos/ferrari.svg',
    ),
    CarBrand(
      arabicName: 'لامبورغيني',
      englishName: 'Lamborghini',
      turkishName: 'Lamborghini',
      kurdishName: 'Lamborghini',
      customLogo: 'assets/logos/lamborghini.svg',
    ),
    CarBrand(
      arabicName: 'مازيراتي',
      englishName: 'Maserati',
      turkishName: 'Maserati',
      kurdishName: 'Maserati',
      customLogo: 'assets/logos/maserati.svg',
    ),
    CarBrand(
      arabicName: 'بنتلي',
      englishName: 'Bentley',
      turkishName: 'Bentley',
      kurdishName: 'Bentley',
      customLogo: 'assets/logos/bentley.svg',
    ),
    CarBrand(
      arabicName: 'رولز رويس',
      englishName: 'Rolls Royce',
      turkishName: 'Rolls Royce',
      kurdishName: 'Rolls Royce',
      customLogo: 'assets/logos/rolls.svg',
    ),

    // ماركات أمريكية
    CarBrand(
      arabicName: 'تسلا',
      englishName: 'Tesla',
      turkishName: 'Tesla',
      kurdishName: 'Tesla',
      customLogo: 'assets/logos/tesla.svg',
    ),
    CarBrand(
      arabicName: 'جيب',
      englishName: 'Jeep',
      turkishName: 'Jeep',
      kurdishName: 'Jeep',
      customLogo: 'assets/logos/jeep.svg',
    ),
    CarBrand(
      arabicName: 'شفروليه',
      englishName: 'Chevrolet',
      turkishName: 'Chevrolet',
      kurdishName: 'Chevrolet',
      customLogo: 'assets/logos/chevrolet.svg',
    ),
    CarBrand(
      arabicName: 'كاديلاك',
      englishName: 'Cadillac',
      turkishName: 'Cadillac',
      kurdishName: 'Cadillac',
      customLogo: 'assets/logos/cadillac.svg',
    ),

    // ماركات أوروبية
    CarBrand(
      arabicName: 'رينو',
      englishName: 'Renault',
      turkishName: 'Renault',
      kurdishName: 'Renault',
      customLogo: 'assets/logos/renault.svg',
    ),
    CarBrand(
      arabicName: 'بيجو',
      englishName: 'Peugeot',
      turkishName: 'Peugeot',
      kurdishName: 'Peugeot',
      customLogo: 'assets/logos/peugeot.svg',
    ),
    CarBrand(
      arabicName: 'فيات',
      englishName: 'Fiat',
      turkishName: 'Fiat',
      kurdishName: 'Fiat',
      customLogo: 'assets/logos/fiat.svg',
    ),
    CarBrand(
      arabicName: 'سيات',
      englishName: 'Seat',
      turkishName: 'Seat',
      kurdishName: 'Seat',
      customLogo: 'assets/logos/seat.svg',
    ),

    // ماركات آسيوية
    CarBrand(
      arabicName: 'هيونداي',
      englishName: 'Hyundai',
      turkishName: 'Hyundai',
      kurdishName: 'Hyundai',
      customLogo: 'assets/logos/hyundai.svg',
    ),
    CarBrand(
      arabicName: 'كيا',
      englishName: 'Kia',
      turkishName: 'Kia',
      kurdishName: 'Kia',
      customLogo: 'assets/logos/kia.svg',
    ),
    CarBrand(
      arabicName: 'سوزوكي',
      englishName: 'Suzuki',
      turkishName: 'Suzuki',
      kurdishName: 'Suzuki',
      customLogo: 'assets/logos/suzuki.svg',
    ),
    CarBrand(
      arabicName: 'مازدا',
      englishName: 'Mazda',
      turkishName: 'Mazda',
      kurdishName: 'Mazda',
      customLogo: 'assets/logos/mazda.svg',
    ),
    CarBrand(
      arabicName: 'سوبارو',
      englishName: 'Subaru',
      turkishName: 'Subaru',
      kurdishName: 'Subaru',
      customLogo: 'assets/logos/subaru.svg',
    ),

    // ماركات كهربائية
    CarBrand(
      arabicName: 'نيو',
      englishName: 'Nio',
      turkishName: 'Nio',
      kurdishName: 'Nio',
      customLogo: 'assets/logos/nio.svg',
    ),

    // ماركات تجارية
    CarBrand(
      arabicName: 'إيسوزو',
      englishName: 'Isuzu',
      turkishName: 'Isuzu',
      kurdishName: 'Isuzu',
      customLogo: 'assets/logos/isuzu.svg',
    ),
    CarBrand(
      arabicName: 'سكانيا',
      englishName: 'Scania',
      turkishName: 'Scania',
      kurdishName: 'Scania',
      customLogo: 'assets/logos/scania.svg',
    ),

    // خيارات عامة
    CarBrand(
      arabicName: 'غير مذكور',
      englishName: 'Not Specified',
      turkishName: 'Belirtilmemiş',
      kurdishName: 'Nehatî diyar kirin',
      iconData: Icons.question_mark,
    ),
    CarBrand(
      arabicName: 'أخرى',
      englishName: 'Other',
      turkishName: 'Diğer',
      kurdishName: 'Yên din',
      iconData: Icons.more_horiz,
    ),
  ];
  List<CarBrand> getCarBrands(String languageCode) {
    return carBrands.map((brand) {
      return CarBrand(
        arabicName: brand.getName(languageCode),
        englishName: brand.englishName,
        turkishName: brand.turkishName,
        kurdishName: brand.kurdishName,
        customLogo: brand.customLogo,
        iconData: brand.iconData,
      );
    }).toList();
  }

  /////////..................................Get All Stores...............................///////////////
  RxBool showDetailsStore = false.obs;
  Rxn<Stores> selectedStore = Rxn<Stores>();
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

  void setSelectedStore(Stores store) {
    selectedStore.value = store;
    fetchPublisherList(selectedStore.value?.id.toString() ?? "",
        Get.find<ChangeLanguageController>().currentLocale.value.languageCode);
    showDetailsStore.value = true;
  }

  RxBool loadingStores = false.obs;
  var StoresList = <Stores>[].obs;

  Future<void> fetchStoresList({
    required String language,
    String? searchName,
  }) async {
    try {
      loadingStores.value = true;

      // 1. بناء URI مع query parameter اختياري
      Uri uri = Uri.parse(
        'https://alamoodac.com/modac/public/stores/approved/$language',
      );
      if (searchName != null && searchName.trim().isNotEmpty) {
        uri = uri.replace(queryParameters: {'name': searchName.trim()});
      }

      // 2. إرسال الطلب
      final response = await http.get(uri);

      // 3. فحص الكود
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load store data (code ${response.statusCode})');
      }

      // 4. فكّ الاستجابة
      final Map<String, dynamic> decoded = json.decode(response.body);

      // 5. النجاح من الـ API؟
      if (decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'Unknown API error');
      }

      // 6. هل لدينا مفتاح data كمصفوفة؟
      final dynamic data = decoded['data'];
      if (data is List) {
        // تحوّل كل خريطة إلى Store
        StoresList.value = data
            .cast<Map<String, dynamic>>()
            .map((json) => Stores.fromJson(json))
            .toList();
      } else {
        // إما مفتاح data ليس قائمة، أو لا يوجد متاجر مطابقة
        StoresList.clear();
        final message =
            decoded['message'] as String? ?? 'لا توجد متاجر مطابقة للبحث.';
        Get.snackbar('Info', message);
        print("error get Data Stores");

        print(message);
      }
    } catch (e) {
      print('Error loading store data: $e');
      // يمكنك هنا عرض Snackbar أو Alert للمستخدم
    } finally {
      loadingStores.value = false;
    }
  }

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

  RxBool showPublishers = false.obs;
  TextEditingController publisherNameController = TextEditingController();
}

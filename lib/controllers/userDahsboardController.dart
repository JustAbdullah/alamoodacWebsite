import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../core/constant/appcolors.dart';
import '../core/data/model/subcategory_level_one.dart';
import '../core/data/model/Stores.dart';
import '../core/data/model/post.dart';
import '../core/localization/changelanguage.dart';
import 'LoadingController.dart';
import 'subscriptionController.dart';

class Userdahsboardcontroller extends GetxController {
      final subController = Get.put(SubscriptionController());

  RxBool showDashBoardUser = false.obs;
  RxInt countOfNumberPostUser = 0.obs;
  RxInt countOfViewPostUser = 0.obs;
  RxInt countOfNumberStoresUser = 0.obs;

  RxBool isGetDataFirstTime = false.obs;

  @override
  void onInit() {
    super.onInit();

    // تحميل المسار المحدد

    // التحقق إذا كانت البيانات قد تم تحميلها مسبقًا
    if (!isGetDataFirstTime.value) {
      final languageCode =
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode;
subController.fetchUserSubscriptions(   Get.find<LoadingController>().currentUser?.id ?? 0, languageCode);  
      fetchPosts(languageCode);
      fetchStroePuscher(languageCode);
      fetchStores(
          Get.find<LoadingController>().currentUser?.id ?? 0, languageCode);

      // تحديث الحالة إلى تم التحميل
      isGetDataFirstTime.value = true;
    }
  }

///////////////////////////////.......جــلب البيانات والذهاب إلى التفاصيل..................///////

  RxBool LoadingPosts = false.obs;
  var postsList = <Post>[].obs;
  RxInt countOfViewPostAuctionUser = 0.obs; // متغير لحفظ عدد منشورات المزادات
  // متغير لحفظ مجموع المشاهدات لجميع المنشورات

  Future<void> fetchPosts(String language) async {
    try {
      LoadingPosts.value = true;

      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/user-posts/${Get.find<LoadingController>().currentUser?.id ?? 0}/$language'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        // تحويل البيانات إلى قائمة من المنشورات
        postsList.value = jsonData.map((post) => Post.fromJson(post)).toList();

        // تهيئة قيم `RxInt` لكل منشور

        // تحديث عدد المنشورات
        countOfNumberPostUser.value = postsList.length;

        // حساب مجموع المشاهدات وعدد منشورات المزادات
        var totalViews = 0;
        var auctionPostCount = 0;

        for (var post in postsList) {
          totalViews += int.parse(post.views); // إضافة المشاهدات

          // إذا كان المنشور يخص قسم المزادات (category_id = 8)
          if (int.parse(post.categoryId) == 8) {
            auctionPostCount++;
          }
        }

        // تحديث عدد المشاهدات
        countOfViewPostUser.value = totalViews;
        print("عدد منشورات المزادات هو:$auctionPostCount");
        // تحديث عدد منشورات المزادات
        countOfViewPostAuctionUser.value = auctionPostCount;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error loading posts: $e");
    } finally {
      LoadingPosts.value = false;
    }
  }

  RxBool showDetailsPost = false.obs;
  RxInt currentPageIndex = 0.obs;
  Rxn<Post> selectedPost = Rxn<Post>();

  var categoryName = "";

  var subcategoryName = "";
  var subcategoryLevelTwoName = "";
  var postTitle = "";
  void setSelectedPost(Post post) {
    selectedPost.value = post;

    // التحقق من وجود ترجمات في القسم قبل الوصول إلى العنصر الأول
    categoryName = selectedPost.value?.category.translations.isNotEmpty == true
        ? selectedPost.value!.category.translations.first.name
        : '';

    // التحقق من وجود ترجمات في القسم الفرعي قبل الوصول إلى العنصر الأول
    subcategoryName =
        selectedPost.value?.subcategory.translations.isNotEmpty == true
            ? selectedPost.value!.subcategory.translations.first.name
            : '';

    // التحقق من وجود ترجمات في القسم الفرعي الثاني قبل الوصول إلى العنصر الأول
    subcategoryLevelTwoName =
        selectedPost.value?.subcategoryLevelTwo.translations.isNotEmpty == true
            ? selectedPost.value!.subcategoryLevelTwo.translations.first.name
            : 'noo';

    // التحقق من وجود ترجمات في المنشور قبل الوصول إلى العنصر الأول
    postTitle = selectedPost.value?.translations.isNotEmpty == true
        ? selectedPost.value!.translations.first.title
        : '';

    showDetailsPost.value = true;
  }

  ////////////////////////////////////////Stores.......................///////
  RxList<RxInt> storesPageIndexes = <RxInt>[].obs;

  var StoresList = <Stores>[].obs; // قائمة المتاجر المعتمدة
  RxBool isLoadingStores = false.obs;

  Future<void> fetchStores(int idUser, String language,
      {String? searchName}) async {
    isLoadingStores.value = true;

    try {
      // بناء الرابط لجلب المتاجر المعتمدة
      String endpoint =
          'https://alamoodac.com/modac/public/user/$idUser/store/$language';

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
          StoresList.value = fetchedStores;
          countOfNumberStoresUser.value = StoresList.length;

          // تحديث قائمة المتاجر المعتمدة
        } else {
          StoresList.value = []; // إذا لم تكن هناك متاجر
        }
      } else {}
    } catch (e) {
    } finally {
      isLoadingStores.value = false;
    }
  }

  ////////////.........../////
  RxBool isShowPostsOrStores = false.obs;
  Future<void> deletePost(int postId) async {
    final String apiUrl =
        "https://alamoodac.com/modac/public/posts/$postId"; // رابط الـ API للحذف

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // إذا كنت بحاجة إلى توكين
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        fetchPosts(Get.find<ChangeLanguageController>()
            .currentLocale
            .value
            .languageCode);
        // عرض سناكبر عند النجاح
        Get.snackbar(
          'نجاح',
          'تم حذف المنشور بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {

        // عرض سناكبر عند الفشل
        Get.snackbar(
          'فشل',
          'فشل حذف المنشور: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {

      // عرض سناكبر عند حدوث خطأ
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف المنشور: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> deleteStore(int storeId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://alamoodac.com/modac/public/stores/$storeId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          Get.snackbar('Success', 'Store deleted successfully.');

          fetchStores(
              Get.find<LoadingController>().currentUser?.id ?? 0,
              Get.find<ChangeLanguageController>()
                  .currentLocale
                  .value
                  .languageCode);
        } else {
          Get.snackbar('Error', data['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to delete store');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {}
  }

  ///////////////أولا جلب متجر-بيانات الناشر.........////////
  RxBool showStorePusherUser = false.obs;
  RxBool LoadingStorePuscher = false.obs;
  var StorePuscherList = <Stores>[].obs;
  Future<void> fetchStroePuscher(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LoadingStorePuscher.value = true;

    try {
      // بناء الرابط لجلب المتاجر المعتمدة
      String endpoint =
          'https://alamoodac.com/modac/public/user/${Get.find<LoadingController>().currentUser?.id.toString()}/store/$language';

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
          print(
              "isDoneGetDataInfo/////////////////////////////////////////////////////");
          print(data['data']);
          print("عدد الناشرين: ${data['data'].length}");
          print(
              "isDoneGetDataInfo///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
          print(
              "isDoneGetDataInfo/////////////////////////////////////////////////////");
          print(
              "////////////////////////////////////////////////////////////////////////////");
          StorePuscherList.value = fetchedStores;
          await prefs.setString('IsHaveInfoUser', 'Yes');
          // تحديث قائمة المتاجر المعتمدة
        } else {
          await prefs.setString('IsHaveInfoUser', 'No');
          StorePuscherList.value = []; // إذا لم تكن هناك متاجر
        }
      } else {}
    } catch (e) {
    } finally {
      LoadingStorePuscher.value = false;
    }
  }

  //////////////////////................تعديل بيانات النــاشر..................../////////
  int idStoreInEdit = 0;
  RxBool isShowEditPusher = false.obs;
  var uploadedImageUrls = "";
  LoadingController loadingController = LoadingController();
  var loading = false.obs;

  // رابط رفع الصور
  final String uploadApiUrl = "https://alamoodac.com/modac/public/upload";
  // قائمة الصور المختارة
  final images = <File>[].obs;

  // متحكمات النصوص
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneCell = TextEditingController();
  final TextEditingController phoneWhatUps = TextEditingController();

  // متغيرات الترجمة
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> translatedData = <Map<String, dynamic>>[].obs;
  String englishSlug = '';

  final List<String> targetLanguages = ['en', 'ar', 'tr', 'ku'];
  final translator = GoogleTranslator();
  final int maxRetryAttempts = 3;

  // بيانات الموقع الجغرافي
  Rxn<double> latitude = Rxn<double>();
  Rxn<double> longitude = Rxn<double>();
  RxBool isLoadingLocation = false.obs;

  // المتغيرات الخاصة بالأقسام الفرعية
  RxBool isHaveDayaSubOne = false.obs;
  var subCategories = <SubcategoryLevelOne>[].obs;

  // دالة مساعدة لإضافة الحقول غير الفارغة إلى البيانات
  void addIfNotEmpty(String key, dynamic value, Map<String, dynamic> data) {
    if (value != null && value.toString().trim().isNotEmpty) {
      data[key] = value;
    }
  }

  // دالة لتحويل الأرقام العربية إلى إنجليزية
  String convertArabicNumbers(String input) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    const englishDigits = '0123456789';
    return input.split('').map((char) {
      int index = arabicDigits.indexOf(char);
      return index != -1 ? englishDigits[index] : char;
    }).join('');
  }

  // --- وظائف الصور ---
  // اختيار الصور من الجهاز
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var file in pickedFiles) {
        images.add(File(file.path));
      }
    }
  }

  // إزالة صورة من القائمة
  void removeImage(int index) {
    images.removeAt(index);
  }

  // تحديث صورة معينة
  Future<void> updateImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images[index] = File(pickedFile.path);
    }
  }

  // رفع الصور إلى السيرفر (تُحدِّث متغير uploadedImageUrls إذا تم رفع صورة)
  Future uploadImagesToServer() async {
    try {
      List<String> uploadedUrls = [];
      if (images.isEmpty) {
        print("No images selected.");
        return;
      }
      print("Starting image upload...");
      var request = http.MultipartRequest('POST', Uri.parse(uploadApiUrl));
      for (var image in images) {
        if (await File(image.path).exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('images[]', image.path));
        } else {
          print("Image file not found: ${image.path}");
          continue;
        }
      }
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        uploadedUrls = List<String>.from(jsonData['image_urls']);
        uploadedImageUrls = uploadedUrls.join(',');
        print("Image upload finished, URLs: $uploadedImageUrls");
      } else {
        var responseData = await response.stream.bytesToString();
        Get.snackbar("Error", "Failed to upload images.");
        print("Image upload failed: $responseData");
      }
    } catch (e) {
      print("Exception during image upload: $e");
      Get.snackbar("Error", "Failed to upload images.");
    }
  }

  // --- وظائف الترجمة ---
  // دالة ترجمة النص مع إعادة المحاولة عند الفشل
  Future<Map<String, String>> _translateWithRetries(String text) async {
    final Map<String, String> translations = {};
    await Future.wait(targetLanguages.map((lang) async {
      int attempts = 0;
      bool success = false;
      while (attempts < maxRetryAttempts && !success) {
        try {
          final result = await translator.translate(text, to: lang);
          translations[lang] = result.text;
          success = true;
        } catch (e) {
          attempts++;
          print("Translation failed for $lang on attempt $attempts: $e");
          if (attempts == maxRetryAttempts) {
            translations[lang] = "Error: Unable to translate";
          }
        }
      }
    }));
    return translations;
  }

  // دالة ترجمة بيانات المتجر (تقوم بالترجمة فقط إذا تم إدخال الاسم أو الوصف)
  Future translateStoreData() async {
    try {
      isLoading.value = true;
      translatedData.clear();
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      // إذا لم يتم إدخال الاسم أو الوصف، لن نقوم بالترجمة
      if (name.isEmpty && description.isEmpty) {
        isLoading.value = false;
        return;
      }
      List<Map<String, dynamic>> translations = [];
      // لكل لغة مستهدفة
      for (var lang in targetLanguages) {
        Map<String, dynamic> trans = {'lang': lang};
        if (name.isNotEmpty) {
          final Map<String, String> nameTranslations =
              await _translateWithRetries(name);
          trans['name'] = nameTranslations[lang] ?? "";
          // إذا كانت اللغة الإنجليزية نستخدمها لحساب slug
          if (lang == 'en') {
            englishSlug =
                nameTranslations[lang]?.toLowerCase().replaceAll(' ', '-') ??
                    'default-slug';
          }
        }
        if (description.isNotEmpty) {
          final Map<String, String> descTranslations =
              await _translateWithRetries(description);
          trans['description'] = descTranslations[lang] ?? "";
        }
        translations.add(trans);
      }
      translatedData.value = translations;
      isLoading.value = false;
      print("Translation successful: $translatedData");
    } catch (e) {
      isLoading.value = false;
      print("Error during translation: $e");
      Get.snackbar("Error", "Failed to translate store data.");
    }
  }

  // --- وظيفة تحديث بيانات المتجر ---
  // تُحدث فقط الحقول التي تم إدخال قيمة لها
  Future<void> updateStoreData(
      int storeId, int? idCity, int? idSub, BuildContext context) async {
    try {
      // عرض مؤشر التحميل
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

      final Map<String, dynamic> requestData = {};
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      // إضافة حقل الصورة فقط إذا كانت قيمة uploadedImageUrls غير فارغة
      if (uploadedImageUrls.trim().isNotEmpty) {
        requestData['image'] = uploadedImageUrls;
        print("Uploaded image URLs: $uploadedImageUrls");
      }

      // إضافة أرقام الهواتف (إذا تم إدخالها)
      addIfNotEmpty(
          'phone_number', convertArabicNumbers(phoneCell.text), requestData);
      addIfNotEmpty('whatsapp_number', convertArabicNumbers(phoneWhatUps.text),
          requestData);

      // إذا تم إدخال الاسم أو الوصف، نحدث الـ slug والترجمات
      if (nameController.text.trim().isNotEmpty ||
          descriptionController.text.trim().isNotEmpty) {
        addIfNotEmpty('slug', englishSlug, requestData);
        if (translatedData.isNotEmpty) {
          requestData['translations'] = translatedData.map((translation) {
            return {
              'lang': translation['lang'],
              'name': (translation['name'] != null &&
                      translation['name'].toString().trim().isNotEmpty)
                  ? translation['name']
                  : null,
              'description': (translation['description'] != null &&
                      translation['description'].toString().trim().isNotEmpty)
                  ? translation['description']
                  : null,
            };
          }).toList();
        }
      }

      // إضافة الحقول الإضافية (المدينة، الفئة الفرعية، الإحداثيات)
      addIfNotEmpty('id_city', idCity?.toString(), requestData);
      addIfNotEmpty('sub_id', idSub?.toString(), requestData);
      addIfNotEmpty('latitude', latitude.value?.toString(), requestData);
      addIfNotEmpty('longitude', longitude.value?.toString(), requestData);

      final response = await http.put(
        Uri.parse('https://alamoodac.com/modac/public/stores/$storeId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success!", "Store updated successfully",
            backgroundColor: Colors.green);
      } else {
        print("Server error: ${response.body}");
        Get.snackbar("Failed!", "Failed to update store",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error during update: $e");
      Get.snackbar("Error!", "Error connecting to server",
          backgroundColor: Colors.red);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  // --- وظيفة معالجة بيانات المتجر ---
  // (ترفع الصور، تُترجم إذا دعت الحاجة، ثم تُحدِّث البيانات)
  Future<void> processStoreData(
      int storeId, int? idCity, int? idSub, BuildContext context) async {
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

      // إذا تم اختيار صور جديدة، يتم رفعها (وإلا لن يتم تعديل حقل الصورة)
      await uploadImagesToServer();
      // إذا تم إدخال الاسم أو الوصف، نقوم بالترجمة
      if (nameController.text.trim().isNotEmpty ||
          descriptionController.text.trim().isNotEmpty) {
        await translateStoreData();
      }
      await updateStoreData(storeId, idCity, idSub, context);
    } catch (e) {
      print("Exception during store data processing: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // --- وظائف الموقع الجغرافي ---
  Future<void> fetchCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      Get.snackbar("Success", "Location fetched successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch location: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void clearLocation() {
    latitude.value = null;
    longitude.value = null;
    Get.snackbar("Done", "Location cleared");
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<void> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Please grant location permission");
      }
    }
  }

  // --- وظيفة تحميل الأقسام الفرعية (مثال) ---
  Future<void> fetchSubcategories() async {
    if (subCategories.isEmpty) {
      isHaveDayaSubOne.value = false;
      try {
        final response = await http.get(Uri.parse(
            'https://alamoodac.com/modac/public/subcategories?category_id=1&language=${Get.find<ChangeLanguageController>().currentLocale.value.languageCode}'));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data != null) {
            var fetchedSubCategories = (data as List)
                .map((subcategory) => SubcategoryLevelOne.fromJson(subcategory))
                .toList();
            subCategories.value = fetchedSubCategories;
            isHaveDayaSubOne.value = true;
          } else {
            subCategories.clear();
          }
        }
      } catch (e) {
        print("Error fetching subcategories: $e");
      }
    }
  }

  Rxn<int> selectedPublisherId = Rxn<int>();
  Rxn<int> selectedIdPost = Rxn<int>();

  RxString selectedPublisher = "".obs;

  var latitudeEnter;
  var longitudeEnter;
/////////////////............../

Future<void> softDeleteUser(int id) async {
  // قم بتعديل الرابط ليتناسب مع مسار API الخاص بك
  final String url = 'https://alamoodac.com/modac/public/users/$id/soft-delete';
  
  try {
    // إرسال طلب حذف للمستخدم
    final response = await http.delete(Uri.parse(url));
    
    // التحقق من نجاح العملية
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("نجاح: ${data['success']}");
      // يمكنك هنا تحديث الحالة في الواجهة أو القيام بأي عملية أخرى
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("خطأ: ${data['error']}");
    }
  } catch (e) {
    // طبع الخطأ في حال حدوث استثناء (مثلاً فشل الاتصال)
    print("حدث خطأ أثناء عملية الحذف: $e");
  }
}


}

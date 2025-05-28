import 'dart:typed_data';

import 'package:alamoadac_website/viewMobile/OnAppPages/on_app_pages%20-%20Copy.dart';

import '../core/localization/changelanguage.dart';
import 'LoadingController.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import '../core/constant/appcolors.dart';
import '../core/data/model/subcategory_level_one.dart';
import 'settingsController.dart';
import 'userDahsboardController.dart';

class AddStorePushController extends GetxController {
  Userdahsboardcontroller userdahsboardcontroller =
      Get.put(Userdahsboardcontroller());
  final loadingController = Get.put(LoadingController());

//////////////////صورة لوجو او شعار الناشر....................../////
  var uploadedImageUrls = ""; // متغير لتخزين الصيغة النهائية للصور

  // متغير للانتظار
  var loading = false.obs;

  // اختيار الصور من الجهاز
  final String uploadApiUrl =
      "https://alamoodac.com/modac/public/upload"; // رابط رفع الصور
  final images = <Uint8List>[].obs;
  // تعديل دالة اختيار الصور
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        images.add(bytes);
      }
    }
  }

// تعديل دالة إزالة الصور
  void removeImage(int index) {
    images.removeAt(index);
  }

// تعديل دالة تحديث الصورة
  Future<void> updateImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      images[index] = bytes;
    }
  }

  // رفع الصور إلى السيرفر
  Future uploadImagesToServer() async {
    try {
      List<String> uploadedUrls = [];
      var request = http.MultipartRequest('POST', Uri.parse(uploadApiUrl));

      for (var imageBytes in images) {
        request.files.add(http.MultipartFile.fromBytes(
          'images[]',
          imageBytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
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
        loading.value = false;
        Get.snackbar("Error", "Failed to upload images.");
        print("Image upload failed");
      }
    } catch (e) {
      print("Exception during image upload: $e");
      loading.value = false;
      Get.snackbar("Error", "Failed to upload images.");
    }
  }

/////////..............صور تخص النشاط التجاري.....................///

//////////////////صورة لوجو او شعار الناشر....................../////
  final imagesBuss = <Uint8List>[].obs; // قائمة الصور المختارة
  var uploadedImageUrlsBuss = "";

// 2. تعديل دالة اختيار الصور
  Future<void> pickImagesBuss() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes(); // قراءة البيانات كـ bytes
        imagesBuss.add(bytes); // إضافة البيانات الخام
      }
    }
  }

// 3. تعديل دالة تحديث الصورة
  Future<void> updateImageBuss(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      imagesBuss[index] = bytes;
    }
  }

// 4. تعديل دالة رفع الصور
  Future uploadImagesToServerBuss() async {
    try {
      List<String> uploadedUrls = [];
      var request = http.MultipartRequest('POST', Uri.parse(uploadApiUrl));

      for (var imageBytes in imagesBuss) {
        request.files.add(http.MultipartFile.fromBytes(
          'images[]',
          imageBytes,
          filename: 'buss_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        uploadedUrls = List<String>.from(jsonData['image_urls']);
        uploadedImageUrlsBuss = uploadedUrls.join(',');
        print("Buss images uploaded: $uploadedImageUrlsBuss");
      } else {
        Get.snackbar("Error", "Failed to upload business images");
      }
    } catch (e) {
      print("Buss images upload error: $e");
      Get.snackbar("Error", "Failed to upload business images");
    }
  }

  void removeImageBuss(int index) {
    imagesBuss.removeAt(index);
  }

/////////////////////////////////////////////
  // ترجمة العنوان
  /////////////////نوع الحــساب

  final RxString accountType = 'personal'.obs;

  void setAccountType(String type) {
    accountType.value = type;
  }

  //////////////////////////
  // Controllers للنصوص والحقول

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneCell = TextEditingController();
  final TextEditingController phoneWhatUps = TextEditingController();

// Controllers للحقول الجديدة
  final TextEditingController accountTypeController =
      TextEditingController(); // يمكن ضبطها افتراضيًا بـ 'personal'
  final TextEditingController instagramLinkController = TextEditingController();
  final TextEditingController facebookLinkController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController companySummaryController =
      TextEditingController();
  final TextEditingController companySpecializationController =
      TextEditingController();
  // في AddStorePushController
  final TextEditingController workingHoursController = TextEditingController();

// متغير لحفظ روابط صور الشركة (إن وُجدت)
  RxString uploadedCompanyImages = ''.obs;

  String convertArabicNumbers(String input) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    const englishDigits = '0123456789';
    return input.split('').map((char) {
      int index = arabicDigits.indexOf(char);
      return index != -1 ? englishDigits[index] : char;
    }).join('');
  }

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> translatedData = <Map<String, dynamic>>[].obs;
  String englishSlug = ''; // لحفظ الترجمة الإنجليزية للاسم لاستخدامها في slug

// قائمة اللغات المستهدفة للترجمة

  final List<String> targetLanguages = ["ar", "en", "tr", "ku"];

  final translator = GoogleTranslator();

// عدد المحاولات القصوى عند فشل الترجمة
  final int maxRetryAttempts = 3;

  /// ترجمة بيانات المتجر (الاسم والوصف) مع إضافة الحقول الجديدة للترجمة
  Future translateStoreData() async {
    try {
      isLoading.value = true;
      translatedData.clear();

      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final workingHours =
          workingHoursController.text.trim(); // أضفنا الحقل الجديد

      if (name.isEmpty ||
          description.isEmpty ||
          (accountType.value == 'commercial' && workingHours.isEmpty)) {
        Get.snackbar("Error", "الرجاء تعبئة جميع الحقول المطلوبة");
        isLoading.value = false;
        return;
      }

      final Map<String, String> nameTranslations =
          await _translateWithRetries(name);
      final Map<String, String> descriptionTranslations =
          await _translateWithRetries(description);
      final Map<String, String> workingHoursTranslations =
          await _translateWithRetries(workingHours); // ترجمة الحقل الجديد

      englishSlug =
          nameTranslations['en']?.toLowerCase().replaceAll(' ', '-') ?? 'slug';

      // تحديث البيانات المترجمة بالحقل الجديد
      List<Map<String, dynamic>> translations = [];
      targetLanguages.forEach((lang) {
        translations.add({
          'lang': lang,
          'name': nameTranslations[lang] ?? "ترجمة فاشلة",
          'description': descriptionTranslations[lang] ?? "ترجمة فاشلة",
          'working_hours': accountType.value == 'commercial'
              ? (workingHoursTranslations[lang] ?? "ترجمة فاشلة")
              : "", // تخليها فاضية أو تحذفها
          'company_summary': accountType.value == 'commercial'
              ? companySummaryController.text.trim()
              : "",
          'company_specialization': accountType.value == 'commercial'
              ? companySpecializationController.text.trim()
              : "",
        });
      });

      translatedData.value = translations;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "فشل في ترجمة بيانات المتجر");
    }
  }

  /// الترجمة مع إعادة المحاولة عند الفشل
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

  /// إرسال البيانات إلى الخادم مع تضمين الحقول الجديدة
  Future sendStoreDataToServer(BuildContext context) async {
    try {
      String numberPhoneCell = "";
      String numberPhoneWhat = "";
      if (phoneCell.text.isNotEmpty) {
        numberPhoneCell = convertArabicNumbers(phoneCell.text);
      }
      if (phoneWhatUps.text.isNotEmpty) {
        numberPhoneWhat = convertArabicNumbers(phoneWhatUps.text);
      }

      // تكوين البيانات المطلوبة للإرسال مع الحقول الجديدة
      final requestData = {
        'user_id': loadingController
            .currentUser?.id, // تأكد من استخدام معرف المستخدم الصحيح
        'image': uploadedImageUrls, // الصورة الرئيسية للمتجر
        'slug': englishSlug, // استخدام الترجمة الإنجليزية كـ slug
        'main_category_id': 1,
        'sub_id': 2,
        'id_city': 1,
        'phone_number': numberPhoneCell.toString(),
        'whatsapp_number': numberPhoneWhat.toString(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        // الحقول الجديدة
        'account_type': accountType.value.toString(),
        'instagram_link': instagramUrl.text.toString(),
        'facebook_link': facebookUrl.text.toString(),
        'linkedin_link': linkedinUrl.text.toString(), // رابط لينكدإن
        'youtube_link': youtubeUrl.text.toString(), // رابط يوتيوب
        'website': websiteUrl.text.toString(),
        'working_hours': workingHoursController.text.toString(),

        /// الحقل الجديد في جدول الناشرين الرئيسي
        'company_summary': companySummaryController.text.toString(),
        'company_specialization':
            companySpecializationController.text.toString(),
        'company_images': uploadedImageUrlsBuss,
        'translations': translatedData,
      };

      // استدعاء واجهة برمجية للخادم
      final Uri uri = Uri.parse('https://alamoodac.com/modac/public/stores');

      if (!await _checkIfApiExists(uri)) {
        // دالة للتحقق من وجود الـ API
        throw Exception('API endpoint not found');
      }

      final preCheck = await http
          .get(Uri.parse('https://alamoodac.com/modac/public/stores'));
      if (preCheck.statusCode == 404) {
        throw Exception('API غير موجود');
      }

      // إرسال البيانات
      final response = await http.post(
        Uri.parse('https://alamoodac.com/modac/public/stores'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer your_token',
        },
        body: jsonEncode(requestData),
      );

      // تحقق من الحالة
      if (response.statusCode == 200) {
        Get.snackbar('نجاح', 'تم الحفظ بنجاح');
        userdahsboardcontroller.isGetDataFirstTime.value = false;
        userdahsboardcontroller.onInit();
        userdahsboardcontroller.fetchStroePuscher(
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode);

        Get.toNamed(
          '/settings-mobile/', // المسار مع المعلمة الديناميكية
          // إرسال الكائن كامل
        );
        homeController.sendMessage(
            userId: loadingController.currentUser?.id, whatType: 4);
        homeController.isMenu();

        restValues();
      } else {
        Get.snackbar('خطأ', 'حدث خطأ: ${response.body}');
        print(response.body);
      }
    } on http.ClientException catch (e) {
      Get.snackbar('خطأ اتصال', 'تعذر الاتصال بالخادم');
      print(e);
    } catch (e) {
      Get.snackbar('خطأ غير متوقع', e.toString());
      print(e);
    }
  }

  Future<bool> _checkIfApiExists(Uri uri) async {
    try {
      final response = await http.get(uri);
      return response.statusCode != 404;
    } catch (e) {
      return false;
    }
  }

  /// عملية شاملة لمعالجة بيانات المتجر: رفع الصور، الترجمة، وإرسال البيانات للخادم
  Future<void> processStoreData(BuildContext context) async {
    try {
      print("بدء عملية معالجة بيانات المتجر");

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
      print("تم عرض مؤشر التحميل");

      // رفع الصور إلى الخادم
      print("بدء رفع الصور الرئيسية");
      await uploadImagesToServer();
      print("انتهى رفع الصور الرئيسية");

      // رفع الصور الخاصة بالحساب التجاري إذا كان نوع الحساب 'commercial'
      if (accountType.value == 'commercial') {
        print("الحساب تجاري، بدء رفع صور النشاط التجاري");
        await uploadImagesToServerBuss();
        print("انتهى رفع صور النشاط التجاري");
      } else {
        print("حساب عادي، لا حاجة لرفع صور النشاط التجاري");
      }

      // ترجمة بيانات المتجر (العنوان والوصف والحقول الإضافية)
      print("بدء عملية الترجمة");
      await translateStoreData();
      print("انتهت عملية الترجمة");

      if (translatedData.isEmpty) {
        print("فشل الترجمة: قائمة الترجمات فارغة");
        loading.value = false;
        Get.snackbar("خطا في العنوان".tr,
            "هنالك خطا في ترجمة العنوان وإضافته حاول مجددًا بوقت لاحق".tr,
            backgroundColor: Colors.red);
        return;
      }

      // إرسال بيانات المتجر إلى الخادم
      print("بدء إرسال البيانات إلى الخادم");
      await sendStoreDataToServer(context);
      print("انتهى إرسال البيانات إلى الخادم");
    } catch (e) {
      print("Exception during store data processing: $e");
      Get.snackbar("خطأ".tr, "حدث خطأ غير متوقع.".tr);
    } finally {
      // إخفاء مؤشر التحميل
      // Navigator.of(context, rootNavigator: true).pop();
      print("تم إخفاء مؤشر التحميل");
    }
  }

  // Variables for location data
  Rxn<double> latitude = Rxn<double>();
  Rxn<double> longitude = Rxn<double>();
  RxBool isLoadingLocation = false.obs;

// Function to check and request location permission if not granted
  Future<void> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("خطأ".tr, "يرجى منح إذن الوصول إلى الموقع الجغرافي".tr);
        print("Permission denied for location access.");
      } else {
        print("Location permission granted after request.");
      }
    } else {
      print("Location permission already granted.");
    }
  }

// Function to check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    print("Location service enabled: $enabled");
    return enabled;
  }

// Function to get the current location with timeout and fallback accuracy
  Future<void> fetchCurrentLocation() async {
    try {
      isLoadingLocation.value = true; // Start loading
      print("بدء الحصول على الموقع الجغرافي");

      // Ensure location permission is granted before proceeding
      await ensureLocationPermission();

      // Attempt to get location with high accuracy with a timeout of 10 seconds
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () async {
          print("Timeout with high accuracy, trying with medium accuracy");
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
          );
        },
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      Get.snackbar("نجاح".tr, "تم الحصول على الموقع الجغرافي بنجاح".tr);
      print(
          "تم الحصول على الموقع: Lat=${position.latitude}, Long=${position.longitude}");
    } catch (e) {
      Get.snackbar("خطأ".tr, "تعذر الحصول على الموقع الجغرافي: $e");
      print("Error fetching location: $e");
    } finally {
      isLoadingLocation.value = false; // Stop loading
      print("انتهت عملية الحصول على الموقع");
    }
  }

// Function to clear the location data
  void clearLocation() {
    latitude.value = null;
    longitude.value = null;
    Get.snackbar("تم".tr, "تم مسح الموقع الجغرافي".tr);
    print("تم مسح بيانات الموقع");
  }

  ///////////////////////////////////////
  int? idSubAddIntoStoreOrdUpdate;
  RxBool isHaveDayaSubOne = false.obs; // متغير حالة التحميل
  var subCategories = <SubcategoryLevelOne>[].obs; // قائمة قابلة للمراقبة
  final facebookUrl = TextEditingController();
  final instagramUrl = TextEditingController();
  final websiteUrl = TextEditingController();
  final linkedinUrl = TextEditingController();
  final youtubeUrl = TextEditingController();

  // دالة تحميل الأقسام الفرعية
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
        } else {}
      } catch (e) {
      } finally {}
    }
  }

  final RxInt currentStep = 0.obs;
  final PageController pageController = PageController();

  void nextStep(BuildContext context) {
    if (currentStep.value < 4) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update(); // إضافة هذه السطر
    } else {
      processStoreData(context);
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void nextStepEdit(BuildContext context, var idStore) {
    if (currentStep.value < 4) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update(); // إضافة هذه السطر
    } else {
      processStoreDataEdit(context, idStore);
    }
  }

  // التأكد من صحة البيانات قبل الانتقال
  /*bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        return accountType.value.isNotEmpty;
      case 1:
        return nameController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty &&
            phoneCell.text.isNotEmpty &&
            phoneWhatUps.text.isNotEmpty;
      case 2:
        return facebookUrl.text.isNotEmpty ||
            instagramUrl.text.isNotEmpty ||
            websiteUrl.text.isNotEmpty ||
            linkedinUrl.text.isNotEmpty ||
            youtubeUrl.text.isNotEmpty;
      case 3:
        return images.isNotEmpty &&
            latitude.value != null &&
            longitude.value != null;
      default:
        return true;
    }
  }*/

  // تعديل دورة حياة الصفحة
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  restValues() {
    Get.find<Userdahsboardcontroller>().isShowEditPusher.value = false;
    final settingsController = Get.find<Settingscontroller>();
    settingsController.showinfoPusherData.value = false;
    currentStep.value = 0;
    nameController.clear();
    descriptionController.clear();
    phoneCell.clear();
    phoneWhatUps.clear();
    accountTypeController.clear();
    instagramLinkController.clear();
    facebookLinkController.clear();
    websiteController.clear();
    companySummaryController.clear();
    companySpecializationController.clear();
    workingHoursController.clear();
    images.clear();
    imagesBuss.clear();
    // Get.back();
  }

  //////////////////تعديل................///////////////
  var idStoretoEdit = 0;

  /// إرسال البيانات إلى الخادم مع تضمين الحقول الجديدة
  Future sendStoreDataToServerEdit(BuildContext context, var idStore) async {
    try {
      String numberPhoneCell = "";
      String numberPhoneWhat = "";
      if (phoneCell.text.isNotEmpty) {
        numberPhoneCell = convertArabicNumbers(phoneCell.text);
      }
      if (phoneWhatUps.text.isNotEmpty) {
        numberPhoneWhat = convertArabicNumbers(phoneWhatUps.text);
      }

      // تكوين البيانات المطلوبة للإرسال مع الحقول الجديدة
      final requestData = {
        'image': uploadedImageUrls, // الصورة الرئيسية للمتجر
        'slug': englishSlug, // استخدام الترجمة الإنجليزية كـ slug
        'main_category_id': 1,
        'sub_id': 2,
        'id_city': 1,
        'phone_number': numberPhoneCell.toString(),
        'whatsapp_number': numberPhoneWhat.toString(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        // الحقول الجديدة
        'account_type': accountType.value.toString(),
        'instagram_link': instagramUrl.text.toString(),
        'facebook_link': facebookUrl.text.toString(),
        'linkedin_link': linkedinUrl.text.toString(), // رابط لينكدإن
        'youtube_link': youtubeUrl.text.toString(), // رابط يوتيوب
        'website': websiteUrl.text.toString(),
        'working_hours': workingHoursController.text.toString(),

        /// الحقل الجديد في جدول الناشرين الرئيسي
        'company_summary': companySummaryController.text.toString(),
        'company_specialization':
            companySpecializationController.text.toString(),
        'company_images': uploadedImageUrlsBuss,
        'translations': translatedData,
      };

      // استدعاء واجهة برمجية للخادم
      final Uri uri =
          Uri.parse('https://alamoodac.com/modac/public/stores/$idStore');

      if (!await _checkIfApiExistsEdit(uri)) {
        // دالة للتحقق من وجود الـ API
        throw Exception('API endpoint not found');
      }

      final preCheck = await http
          .get(Uri.parse('https://alamoodac.com/modac/public/stores/$idStore'));
      if (preCheck.statusCode == 404) {
        throw Exception('API غير موجود');
      }

      // إرسال البيانات
      final response = await http.put(
        Uri.parse('https://alamoodac.com/modac/public/stores/$idStore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      // تحقق من الحالة
      if (response.statusCode == 200) {
        Get.snackbar('نجاح'.tr, 'تم الحفظ بنجاح'.tr);
        userdahsboardcontroller.isGetDataFirstTime.value = false;
        userdahsboardcontroller.onInit();
        userdahsboardcontroller.fetchStroePuscher(
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode);

        restValues();
      } else {
        Get.snackbar('خطأ', 'حدث خطأ: ${response.body}');
        print(response.body);
      }
    } on http.ClientException catch (e) {
      Get.snackbar('خطأ اتصال', 'تعذر الاتصال بالخادم');
      print(e);
    } catch (e) {
      Get.snackbar('خطأ غير متوقع', e.toString());
      print(e);
    }
  }

  Future<bool> _checkIfApiExistsEdit(Uri uri) async {
    try {
      final response = await http.get(uri);
      return response.statusCode != 404;
    } catch (e) {
      return false;
    }
  }

  /// عملية شاملة لمعالجة بيانات المتجر: رفع الصور، الترجمة، وإرسال البيانات للخادم
  Future<void> processStoreDataEdit(BuildContext context, var idStore) async {
    try {
      print("بدء عملية معالجة بيانات المتجر");

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
      print("تم عرض مؤشر التحميل");

      // رفع الصور إلى الخادم
      print("بدء رفع الصور الرئيسية");
      await uploadImagesToServer();
      print("انتهى رفع الصور الرئيسية");

      // رفع الصور الخاصة بالحساب التجاري إذا كان نوع الحساب 'commercial'
      if (accountType.value == 'commercial') {
        print("الحساب تجاري، بدء رفع صور النشاط التجاري");
        await uploadImagesToServerBuss();
        print("انتهى رفع صور النشاط التجاري");
      } else {
        print("حساب عادي، لا حاجة لرفع صور النشاط التجاري");
      }

      // ترجمة بيانات المتجر (العنوان والوصف والحقول الإضافية)
      print("بدء عملية الترجمة");
      await translateStoreData();
      print("انتهت عملية الترجمة");

      if (translatedData.isEmpty) {
        print("فشل الترجمة: قائمة الترجمات فارغة");
        loading.value = false;
        Get.snackbar("خطا في العنوان".tr,
            "هنالك خطا في ترجمة العنوان وإضافته حاول مجددًا بوقت لاحق".tr,
            backgroundColor: Colors.red);
        return;
      }

      // إرسال بيانات المتجر إلى الخادم
      print("بدء إرسال البيانات إلى الخادم");
      await sendStoreDataToServerEdit(context, idStore);
      print("انتهى إرسال البيانات إلى الخادم");
    } catch (e) {
      print("Exception during store data processing: $e");
      Get.snackbar("خطأ".tr, "حدث خطأ غير متوقع.".tr);
    } finally {
      // إخفاء مؤشر التحميل
      Navigator.of(context, rootNavigator: true).pop();
      print("تم إخفاء مؤشر التحميل");
    }
  }

  final FocusNode nameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode whatsappFocus = FocusNode();
  final FocusNode companySummaryFocus = FocusNode();
  final FocusNode companySpecializationFocus = FocusNode();
}

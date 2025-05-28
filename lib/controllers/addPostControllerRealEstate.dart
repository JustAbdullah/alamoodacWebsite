import 'dart:typed_data';

import 'LoadingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import '../core/constant/appcolors.dart';
import '../core/data/model/City.dart';
import '../core/data/model/subcategory_level_one.dart';
import '../core/data/model/subcategory_level_two.dart';
import '../core/localization/changelanguage.dart';
import 'areaController.dart';
import 'home_controller.dart';

class Addpostcontrollerrealestate extends GetxController {
  RxInt currentStep = 0.obs; // خطوات التقدم
  RxBool showAdd = false.obs;
  AreaController areaController = Get.put(AreaController());

  final List<String> targetLanguages = ["ar", "en", "tr", "ku"];

  var uploadedImageUrls = ""; // متغير لتخزين الصيغة النهائية للصور
  int idCate = 0;
  int? idSub = null;
  int? idSubTwo = null;
  HomeController homeController = Get.put(HomeController());
  // متغير للانتظار
  var loading = false.obs;

  // اختيار الصور من الجهاز
  final String uploadApiUrl =
      "https://alamoodac.com/modac/public/upload"; // رابط رفع الصور
  //////////Image Web.............
  final images = <Uint8List>[].obs; // تغيير File إلى Uint8List

// 3. تعديل دوال إدارة الصور
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes(); // قراءة البيانات كـ bytes
        images.add(bytes);
      }
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  Future<void> updateImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      images[index] = bytes;
    }
  }

// 4. تعديل دالة رفع الصور
  Future<void> uploadImagesToServer() async {
    try {
      List<String> uploadedUrls = [];

      if (images.isEmpty) {
        loading.value = false;
        Get.snackbar("Error", "No images selected.");
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(uploadApiUrl));

      for (var imageBytes in images) {
        request.files.add(http.MultipartFile.fromBytes(
          'images[]',
          imageBytes,
          filename: 'post_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        uploadedUrls = List<String>.from(jsonData['image_urls']);
        uploadedImageUrls = uploadedUrls.join(',');
      } else {
        Get.snackbar("Error", "Failed to upload images:");
      }
    } catch (e) {
      print("Upload error: $e");
      loading.value = false;
      Get.snackbar("Error", "Failed to upload images: ${e.toString()}");
    }
  }

  // ترجمة العنوان
  final TextEditingController titleController = TextEditingController();
  RxList<Map<String, dynamic>> translatedTitles = <Map<String, dynamic>>[].obs;
  final translator = GoogleTranslator();

  // قائمة اللغات المستهدفة

  /// عدد المحاولات القصوى عند فشل الترجمة
  final int maxRetryAttempts = 3;

  /// ترجمة العنوان
  Future<void> processTitle() async {
    try {
      print("Starting title translation...");
      translatedTitles.clear(); // حذف الترجمات السابقة
      final titleValue = titleController.text.trim();
      if (titleValue.isNotEmpty) {
        final Map<String, String> translatedText =
            await _translateTextWithRetries(titleValue);

        // تشكيل هيكل الترجمة بما يتوافق مع الصيغة المطلوبة
        List<Map<String, dynamic>> translations = [];
        translatedText.forEach((lang, translation) {
          translations.add({
            'language': lang,
            'title': translation,
          });
        });

        translatedTitles.value = translations;
      }
      print("Title translation finished.");
    } catch (e) {
      print("Error during title translation: $e");
      Get.snackbar("Error", "Failed to process title: $e");
    }
  }

  /// ترجمة النصوص مع إعادة المحاولة عند الفشل

  Future<Map<String, String>> _translateTextWithRetries(String text) async {
    final Map<String, String> translations = {};
    await Future.wait(targetLanguages.map((originalLang) async {
      String langToUse = originalLang;
      // شرط التحويل إلى السورانية
      if (originalLang == 'ku') {
        langToUse = 'ckb'; // إجبار استخدام ckb للترجمة
      }

      int attempts = 0;
      bool success = false;
      while (attempts < 3 && !success) {
        try {
          final result = await translator.translate(text, to: langToUse);
          translations[originalLang] = result.text; // الاحتفاظ بـ ku كمفتاح
          success = true;
        } catch (e) {
          attempts++;
          if (attempts == 3) {
            translations[originalLang] = "Error: Unable to translate";
          }
        }
      }
    }));
    return translations;
  }

  /// ترجمة التفاصيل

  final Map<String, TextEditingController> detailControllers = {
    "السعر": TextEditingController(),
    "الحي-المنطقة": TextEditingController(),
    "عدد الغرف": TextEditingController(),
    "عدد الحمامات": TextEditingController(),
    "عدد الطوابق": TextEditingController(),
    "مساحة البناء": TextEditingController(),
    "مساحة الارض": TextEditingController(),
    "عمر البناء": TextEditingController(),
    "طريقة الدفع": TextEditingController(),
    "تفاصيل اضافية": TextEditingController(),
  };

  RxList<Map<String, dynamic>> translatedDetails = <Map<String, dynamic>>[].obs;

  Future<void> processDetails() async {
    try {
      print("Starting details translation...");
      translatedDetails.clear();

      List<Future<void>> futures = [];
      for (var entry in detailControllers.entries) {
        final detailName = entry.key;
        final detailValue = entry.value.text.trim();

        if (detailValue.isNotEmpty) {
          futures.add(_translateDetailWithRetries(detailName, detailValue));
        }
      }

      await Future.wait(futures); // انتظار اكتمال الترجمات
      print("Details translation finished.");
    } catch (e) {
      print("Error during details translation: $e");
      Get.snackbar("Error", "Failed to process details: $e");
    }
  }

  Future<void> _translateDetailWithRetries(
      String detailName, String detailValue) async {
    try {
      Map<String, dynamic> detailTranslation = {
        'detail_name': detailName,
        'detail_value': detailValue,
        'translations': []
      };
      for (String originalLang in targetLanguages) {
        String langToUse = originalLang;
        // شرط التحويل إلى السورانية
        if (originalLang == 'ku') {
          langToUse = 'ckb'; // إجبار استخدام ckb للترجمة
        }

        int attempts = 0;
        bool success = false;
        while (attempts < 3 && !success) {
          try {
            final translatedName =
                await translator.translate(detailName, to: langToUse);
            final translatedValue =
                await translator.translate(detailValue, to: langToUse);
            detailTranslation['translations'].add({
              'language': originalLang, // الاحتفاظ بـ ku كمفتاح
              'translated_detail_name': translatedName.text,
              'translated_detail_value': translatedValue.text,
            });
            success = true;
          } catch (e) {
            attempts++;
            if (attempts == 3) {
              detailTranslation['translations'].add({
                'language': originalLang,
                'translated_detail_name': "Error",
                'translated_detail_value': "Error",
              });
            }
          }
        }
      }
      translatedDetails.add(detailTranslation);
    } catch (e) {
      print("Error translating detail $detailName: $e");
    }
  }

  // إنشاء المنشور
  // Post Creation
  Future<void> createPost(Map<String, dynamic> postData) async {
    try {
      loading.value = true;
      var response = await http.post(
        Uri.parse("https://alamoodac.com/modac/public/one-post"),
        body: json.encode(postData),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        loading.value = false;
      } else {
        loading.value = false;
      }
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> executePostCreation(var storeId, var long, var lat,
      int categoryId, String status, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: AppColors.TheMain,
        ),
      ),
    );

    if (categoryId == 0) {
      Get.snackbar("Error", "Please select main category",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    if (images.isEmpty) {
      Get.snackbar("Error", "Please upload images before creating the post",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter the title",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    for (var entry in detailControllers.entries) {
      if (entry.value.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter ${entry.key}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.redColor);
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
    }

    await uploadImagesToServer();
    if (uploadedImageUrls.isEmpty) {
      loading.value = false;
      Get.snackbar("Error", "Image upload failed", backgroundColor: Colors.red);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    await processTitle();
    if (translatedTitles.isEmpty) {
      loading.value = false;
      Get.snackbar("Error", "Title translation failed",
          backgroundColor: Colors.red);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    await processDetails();
    if (translatedDetails.isEmpty) {
      loading.value = false;
      Get.snackbar("Error", "Details translation failed",
          backgroundColor: Colors.red);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    var postData = {
      'store_id': storeId,
      'user_id': Get.find<LoadingController>().currentUser?.id,
      'category_id': categoryId,
      'subcategory_id': idSub,
      'subcategory_level2_id': idSubTwo,
      'id_city': homeController.chosedIdCity.value,
      'area_id': areaController.idOfArea.value,
      'status': status,
      'images': uploadedImageUrls,
      'latitude': lat,
      'longitude': long,
      'translations': translatedTitles,
      'details': translatedDetails.map((detail) {
        // التحويل لحقل السعر فقط
        if (detail['detail_name'] == 'السعر') {
          return {
            ...detail,
            'detail_value':
                convertArabicToEnglishNumbers(detail['detail_value']),
            'translations': detail['translations'].map((translation) {
              return {
                ...translation,
                'translated_detail_value': convertArabicToEnglishNumbers(
                    translation['translated_detail_value']),
              };
            }).toList(),
          };
        }
        return detail; // إرجاع البيانات الأخرى بدون تعديل
      }).toList(),
    };

    await createPost(postData);

    Navigator.of(context, rootNavigator: true).pop();
    isAddPost.value = false;
    homeController.sendMessage(
        userId: Get.find<LoadingController>().currentUser?.id, whatType: 4);
  }

  RxBool isAddPost = false.obs;

  void resetFields() {
    isAddPost.value = false;

    isHaveDayaSubOne.value = false;

    isHaveSubTwo.value = false;
    images.clear();
    titleController.clear();

    detailControllers.forEach((_, c) => c.clear());
    translatedTitles.clear();
    translatedDetails.clear();
    idCate = 0;
    idSub = null;
    idSubTwo = null;
    subCategories.clear();
    subcategoriesLevelTwo.clear();
  }

  void hideAll() {
    isAddPost.value = false;
    showAdd.value = false;
    resetFields();
  } ///////////////////////...المـــدينة...///////////

  RxBool isHaveDayaSubOne = false.obs; // متغير حالة التحميل
  var subCategories = <SubcategoryLevelOne>[].obs; // قائمة قابلة للمراقبة

  // دالة تحميل الأقسام الفرعية
  Future<void> fetchSubcategories(
    int Theid,
  ) async {
    if (subCategories.isEmpty) {
      isHaveDayaSubOne.value = false;
      try {
        final response = await http.get(Uri.parse(
            'https://alamoodac.com/modac/public/subcategories?category_id=$Theid&language=${Get.find<ChangeLanguageController>().currentLocale.value.languageCode}'));

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

  ///////////////////////////////////////// الأقسام الفرعية الثانوية..................////////////
  RxBool isHaveSubTwo = false.obs;
  var subcategoriesLevelTwo = <SubcategoryLevelTwo>[].obs;
  Future<void> fetchSubcategoriesLevelTwo(
    int subCategoryLevelOneId,
  ) async {
    try {
      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/subcategories-level-two?sub_category_level_one_id=$subCategoryLevelOneId&language=${Get.find<ChangeLanguageController>().currentLocale.value.languageCode}'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data != null && data['data'] != null) {
          var fetchedSubCategoriesTwo = (data['data'] as List)
              .map((subcategoryTwo) =>
                  SubcategoryLevelTwo.fromJson(subcategoryTwo))
              .toList();

          if (fetchedSubCategoriesTwo.isNotEmpty) {
            subcategoriesLevelTwo.value = fetchedSubCategoriesTwo;
            isHaveSubTwo.value =
                true; // تعيين showTheSubTwo إلى true إذا كانت البيانات غير فارغة
          } else {
            subcategoriesLevelTwo.clear();
            isHaveSubTwo.value =
                false; // تعيين showTheSubTwo إلى false إذا كانت البيانات فارغة
          }
        } else {
          subcategoriesLevelTwo.clear();
          isHaveSubTwo.value =
              false; // تعيين showTheSubTwo إلى false إذا كانت البيانات غير موجودة
        }
      } else {
        subcategoriesLevelTwo.clear();
        isHaveSubTwo.value =
            false; // تعيين showTheSubTwo إلى false في حال فشل الـ API
      }
    } catch (e) {
      print('Error occurred: $e');
      subcategoriesLevelTwo.clear();
      isHaveSubTwo.value =
          false; // تعيين showTheSubTwo إلى false في حال حدوث خطأ
    } finally {}
  }

  String? nameArea;
  void nextStep() {
    if (currentStep < 4) currentStep++;
  }

  void previousStep() {
    if (currentStep > 0) currentStep--;
  }

  void resetAll() {
    currentStep.value = 0; // إعادة الخطوات إلى البداية
    showAdd.value = false; // إخفاء الواجهة
    resetFields(); // إعادة تعيين الحقول
  }

  RxString nameOfCatee = "".obs;

  /////////////////////يوجد شهادات .....................
  RxBool isHaveCv = false.obs;
  String convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicNumbers.length; i++) {
      input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }
    return input;
  }
}

import 'dart:convert';
import 'dart:async';
import 'package:alamoadac_website/viewMobile/OnAppPages/on_app_pages%20-%20Copy.dart';

import '../core/data/model/MessageModel.dart';
import 'LoadingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constant/appcolors.dart';
import '../core/data/model/PackageModel.dart';
import 'AuthController.dart';
import 'package:http/http.dart' as http;

class Settingscontroller extends GetxController {
  final TextEditingController textControllerPhone = TextEditingController();

  AuthController authController = Get.put(AuthController());
  LoadingController loadingController = Get.put(LoadingController());

  // Flags for UI visibility
  RxBool showChoseLang = false.obs;
  RxBool showCoins = false.obs;
  RxBool showNotiv = false.obs;
  RxBool saveAccount = false.obs;
  RxBool enterDataSaveAccountOne = false.obs;
  RxBool enterDataSaveAccountTwo = false.obs;
  RxBool showStore = false.obs;
  RxBool showStoreData = false.obs;

  RxBool showPhone = false.obs;
  RxBool showPack = false.obs;
  RxBool showLocation = false.obs;
  RxBool choseTra = false.obs;
  RxBool showTerms = false.obs;
  RxBool deleteAccount = false.obs;
  RxBool signOut = false.obs;
  RxBool showMode = false.obs;
  RxBool showPusher = false.obs;
  RxBool showinfoPusherData = false.obs;

  // Variables for location data
  Rxn<double> latitude = Rxn<double>();
  Rxn<double> longitude = Rxn<double>();
  RxBool isLoadingLocation = false.obs;

/////////////////////Just Get MapSearching...................//////
  Future<void> fetchMapSearching() async {
    try {
      isLoadingLocation.value = true; // Start loading
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      Get.snackbar("نجاح".tr, "تم الحصول على الموقع الجغرافي بنجاح".tr);
    } catch (e) {
      Get.snackbar("خطأ".tr, "تعذر الحصول على الموقع الجغرافي: $e");
    } finally {
      isLoadingLocation.value = false; // Stop loading
    }
  }

  // Function to get the current location
  Future<void> fetchCurrentLocation() async {
    try {
      isLoadingLocation.value = true; // Start loading
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      authController.updateLocation(loadingController.currentUser?.id ?? 0,
          position.latitude, position.longitude);
      Get.snackbar("نجاح".tr, "تم الحصول على الموقع الجغرافي بنجاح".tr);
    } catch (e) {
      Get.snackbar("خطأ".tr, "تعذر الحصول على الموقع الجغرافي: $e");
    } finally {
      isLoadingLocation.value = false; // Stop loading
    }
  }

  // Function to clear the location
  void clearLocation() {
    latitude.value = null;
    longitude.value = null;
    Get.snackbar("تم".tr, "تم مسح الموقع الجغرافي".tr);
  }

  // Check if location is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // Check and request permission if not granted
  Future<void> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("خطأ".tr, "يرجى منح إذن الوصول إلى الموقع الجغرافي".tr);
      }
    }
  }

  Future<void> SignOutMobile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.reload();
      final authController = Get.find<AuthController>();
      final loadingController = Get.find<LoadingController>();
      authController.currentUser = null;
      loadingController.currentUser = null;
      // هذه السطور السحرية تحل المشكلة
      Get.forceAppUpdate();
      //////////////////////////////////////////////////////...... await Get.offAll(() => LoadingApp());
      Get.reload<AuthController>(force: true);
      Get.reload<LoadingController>(force: true);
      homeController.isChosedHome();
      Get.toNamed(
        '/mobile', // المسار مع المعلمة الديناميكية
        // إرسال الكائن كامل
      );
    } catch (e) {
      print('SignOut Error: $e');
    }
  }

  Future<void> SignOutDeskTop() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.reload();
      final authController = Get.find<AuthController>();
      final loadingController = Get.find<LoadingController>();
      authController.currentUser = null;
      loadingController.currentUser = null;
      // هذه السطور السحرية تحل المشكلة
      Get.forceAppUpdate();
      //////////////////////////////////////////////////////...... await Get.offAll(() => LoadingApp());
      Get.reload<AuthController>(force: true);
      Get.reload<LoadingController>(force: true);
      Get.toNamed(
        '/desktop', // المسار مع المعلمة الديناميكية
        // إرسال الكائن كامل
      );
    } catch (e) {
      print('SignOut Error: $e');
    }
  }

  final TextEditingController QuOneText = TextEditingController();
  final TextEditingController QuTwoText = TextEditingController();
  final TextEditingController AnsOneText = TextEditingController();
  final TextEditingController AnsTwoText = TextEditingController();
  final phoneNumberText = TextEditingController().obs;

  // Verify Account
  Future<void> verifyAccount({
    required String phone,
    required String securityQuestion1,
    required String securityAnswer1,
    required String securityQuestion2,
    required String securityAnswer2,
    required BuildContext context,
  }) async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // تغيير نمط واجهة النظام (مثل الشريط العلوي)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // جعل شريط الحالة شفافًا
        statusBarIconBrightness:
            Brightness.dark, // تغيير سطوع أيقونات شريط الحالة
      ),
    );
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
        'https://alamoodac.com/modac/public/users/verify-account/${loadingController.currentUser?.id ?? 0}');
    try {
      final response = await http.post(
        url,
        body: {
          'phone': phone,
          'security_question_1': securityQuestion1,
          'security_answer_1': securityAnswer1,
          'security_question_2': securityQuestion2,
          'security_answer_2': securityAnswer2,
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar('نجحت العملية'.tr,
            'لقد تم بنجاح توثيق حسابك..شُكرا لاهتمامك بالأمان'.tr,
            backgroundColor: Colors.green[600]);
        enterDataSaveAccountOne.value = false;
        enterDataSaveAccountTwo.value = false;

        saveAccount.value = false;

        //////////////////////////////////////////////////////......   Get.to(OnAppPages());
      } else {
        Get.snackbar('خطا! في العملية'.tr, data['error'],
            backgroundColor: Colors.red[600]);

        print(data['error']);
      }
    } catch (e) {
      Get.snackbar('خطا! في العملية'.tr, 'An error occurred',
          backgroundColor: Colors.red[600]);
      print(e);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  restValue() {
    showChoseLang.value = false;
    showCoins.value = false;
    showNotiv.value = false;
    saveAccount.value = false;
    enterDataSaveAccountOne.value = false;
    enterDataSaveAccountTwo.value = false;
    showStore.value = false;
    showStoreData.value = false;

    showPhone.value = false;
    showPack.value = false;
    showLocation.value = false;
    choseTra.value = false;
    showTerms.value = false;
    deleteAccount.value = false;
    signOut.value = false;
    showMode.value = false;
    showPusher.value = false;
    showinfoPusherData.value = false;
  }

  ////////////////////////////////////..............
  var packages = <PackageModel>[].obs;
  var isLoadingPackages = false.obs;

  Future<void> fetchPackages(String code) async {
    isLoadingPackages.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://alamoodac.com/modac/public/packages/$code')); // ضع رابط الـ API الصحيح هنا

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          packages.value =
              data.map((package) => PackageModel.fromJson(package)).toList();
        }
      } else {
        print('خطأ في جلب الباقات: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب الباقات: $e');
    } finally {
      isLoadingPackages.value = false;
    }
  }

  var showAboutUs = false.obs;
  var showPrivacyPolicy = false.obs;

  var currentPage = ''.obs; // 'about', 'terms', 'privacy', or ''

  void openPage(String pageType) {
    currentPage.value = pageType;
  }

  void closePage() {
    currentPage.value = '';
  }

  bool isAboutVisible() => currentPage.value == 'about';
  bool isTermsVisible() => currentPage.value == 'terms';
  bool isPrivacyVisible() => currentPage.value == 'privacy';

  //////////
  RxBool showAskToPromotedAd = false.obs;
  RxBool showAskToDeleteAccount = false.obs;

////////
  Future<void> softDeleteUserMobile() async {
    // قم بتعديل الرابط ليتناسب مع مسار API الخاص بك
    final String url =
        'https://alamoodac.com/modac/public/delete-user/${loadingController.currentUser?.id ?? 0}';

    try {
      // إرسال طلب حذف للمستخدم
      final response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("نجاح: ${data['success']}");
        Get.snackbar(
          "تم الحذف".tr,
          "تم حذف الحساب بشكل نهائي".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        SignOutMobile();

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

  Future<void> softDeleteUserDeskTop() async {
    // قم بتعديل الرابط ليتناسب مع مسار API الخاص بك
    final String url =
        'https://alamoodac.com/modac/public/delete-user/${loadingController.currentUser?.id ?? 0}';

    try {
      // إرسال طلب حذف للمستخدم
      final response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("نجاح: ${data['success']}");
        Get.snackbar(
          "تم الحذف".tr,
          "تم حذف الحساب بشكل نهائي".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        SignOutDeskTop();

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

  RxBool isShowAddCode = false.obs;
  /////////////////////////
  RxBool showMessages = false.obs;
  var messages = <MessageModel>[].obs;
  var isLoadingMessages = false.obs;
  Future<void> fetchMessages(int idUser) async {
    print("ISGetDataMessage");
    isLoadingMessages.value = true;

    final String endpoint =
        'https://alamoodac.com/modac/public/messages/user/$idUser';

    try {
      print("ISGetDataMessageOne.....................");
      // نضع مهلة 10 ثواني، وبعدها نرمي TimeoutException
      final response = await http
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Request to $endpoint timed out');
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        // لو الاستجابة من Laravel ترجع success=false والـ status=404
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> data = body['data'];
          messages.value =
              data.map((json) => MessageModel.fromJson(json)).toList();
          print("ISGetDataMessageDone: ${messages.length} messages");
        } else {
          print(
              "ISGetDataMessageEmptyOrError: ${body['message'] ?? 'no data'}");
          messages.clear();
        }
      } else {
        print('ISGetDataMessageHTTPError: ${response.statusCode}');
        messages.clear();
      }
    } on TimeoutException catch (te) {
      print('❌ TimeoutException: $te');
      messages.clear();
    } catch (e, st) {
      print('❌ Exception fetching messages: $e');
      print(st);
      messages.clear();
    } finally {
      isLoadingMessages.value = false;
      print("ISGetDataMessageEnd");
    }
  }

  ///
  RxBool isLoadingMessagesDelete = false.obs;
  Future<void> deleteMessage(int messageId) async {
    // مؤقت حذف فردي (يمكنك إضافة obs لحالة حذف منفرد إذا أحببت)
    isLoadingMessagesDelete.value = true;
    try {
      final url =
          Uri.parse('https://alamoodac.com/modac/public/messages/$messageId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true) {
          // إزالة الرسالة من القائمة محليًا
          messages.removeWhere((msg) => msg.id == messageId);
          Get.snackbar(
            'تم الحذف'.tr,
            'تم حذف الرسالة بنجاح'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'فشل الحذف'.tr,
            body['error'] ?? 'حدث خطأ غير متوقع'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'فشل الحذف'.tr,
          'خطأ في الاتصال: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ'.tr,
        'تعذر الاتصال بالخادم'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoadingMessagesDelete.value = false;
    }
  }
}

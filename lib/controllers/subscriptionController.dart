import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/data/model/Subscription.dart';
import '../core/data/model/SubscriptionCode.dart';
import '../core/localization/changelanguage.dart';
import 'LoadingController.dart';

class SubscriptionController extends GetxController {
  RxBool isDoneSub = false.obs;
  String selectedTheSections = "كل الأقسام";
  int IdTheSections = 99;

  Future<void> createSubscriptionRequest({
    required int packageId,
    required String selectedSections,
    required int sectionId,
    required BuildContext context,
  }) async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );

    try {
      final userId = Get.find<LoadingController>().currentUser?.id;

      if (userId == null) {
        Navigator.of(context, rootNavigator: true).pop(); // إغلاق التحميل
        Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم.");
        return;
      }

      final url =
          Uri.parse('https://alamoodac.com/modac/public/subscriptions/request');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'user_id': userId,
          'package_id': packageId,
          'selected_sections': selectedSections,
          'section_id': sectionId,
          'payment_details': "طــلب إشتراك للباقة",
        }),
      );

      Navigator.of(context, rootNavigator: true).pop(); // إغلاق التحميل

      if (response.statusCode == 201) {
        isDoneSub.value = true;
        IdTheSections = 99;
        selectedTheSections = "selectedTheSections";

        Get.snackbar("تم الطلب".tr, "تم إرسال طلب الاشتراك بنجاح.".tr);
      } else {
        isDoneSub.value = false;

        print(response.body);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // إغلاق التحميل
      print("$e");
    }
  }

///////////////////

  var subscriptions = <Subscription>[].obs;
  var isLoading = false.obs;
  final baseUrl = 'https://alamoodac.com/modac/public/subscriptions/user';

  Future<void> fetchUserSubscriptions(int userId, String language) async {
    print("isGoingGetDataUser.....");
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/$language'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        subscriptions.value = data
            .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        subscriptions.clear();
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateSubscriptionCode(int subscriptionId) async {
    try {
      // 1. التحقق من صحة المعرف
      print('[DEBUG] محاولة توليد كود للاشتراك ID: $subscriptionId');
      if (subscriptionId <= 0) {
        throw 'معرف الاشتراك غير صالح (القيمة: $subscriptionId)';
      }

      // 2. تحضير بيانات الطلب
      final requestBody = {
        'subscription_id': subscriptionId,
      };
      print('[DEBUG] Request Body: $requestBody');

      // 3. إرسال الطلب
      final response = await http
          .post(
            Uri.parse(
                'https://alamoodac.com/modac/public/subscriptions/generate-code'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: 10));

      // 4. تسجيل استجابة السيرفر بالكامل
      print('[DEBUG] Response Status: ${response.statusCode}');
      print('[DEBUG] Response Body: ${response.body}');

      // 5. معالجة الاستجابة
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 5.1 حالة النجاح
        print('[SUCCESS] تم توليد الكود: ${responseData['code']}');
        Get.snackbar(
          'تم بنجاح'.tr,
          'تم توليد الكود'.tr,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );

        // 6. تحديث البيانات
        final userId = Get.find<LoadingController>().currentUser?.id;
        if (userId != null) {
          await fetchUserSubscriptions(
            userId,
            Get.find<ChangeLanguageController>()
                .currentLocale
                .value
                .languageCode,
          );
        }
      } else {
        // 5.2 حالة الفشل
        final errorMsg = responseData['error'] ??
            responseData['message'] ??
            'فشل غير معروف (Status: ${response.statusCode})';
        print('[ERROR] $errorMsg');
        throw errorMsg;
      }
    } on SocketException catch (e) {
      // 7. معالجة أخطاء الاتصال
      final errorMsg = 'مشكلة في الاتصال بالخادم: ${e.message}';
      print('[NETWORK ERROR] $errorMsg');
      Get.snackbar(
        'خطأ في الاتصال',
        errorMsg,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    } on TimeoutException catch (e) {
      // 8. معالجة انتهاء المهلة
      final errorMsg = 'انتهت مهلة الاتصال بالخادم';
      print('[TIMEOUT ERROR] $errorMsg');
      Get.snackbar(
        'مهلة انتهت',
        errorMsg,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
      );
    } catch (e) {
      // 9. معالجة جميع الأخطاء الأخرى
      print('[UNEXPECTED ERROR] ${e.toString()}');
      print('Stack Trace: ${e}');
      Get.snackbar(
        'خطأ غير متوقع',
        'حدث خطأ: ${e.toString()}',
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  final RxList<SubscriptionCode> codes = <SubscriptionCode>[].obs;
  final RxBool isLoadingCode = false.obs;

  Future<void> fetchCodes(int subscriptionId) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            'https://alamoodac.com/modac/public/subscriptions/codes/$subscriptionId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        codes.value = data.map((e) => SubscriptionCode.fromJson(e)).toList();
      } else {
        codes.clear();
      }
    } catch (e) {
      print('Error fetching codes: $e');
      codes.clear();
    } finally {
      isLoading.value = false;
    }
  }

///////
  final TextEditingController codeController = TextEditingController();
  final RxBool isActivating = false.obs;

  Future<void> redeemSubscriptionCode(BuildContext context) async {
    print(codeController.text.toString().trim());
    final userId = Get.find<LoadingController>().currentUser?.id;
    if (userId == null) return;

    isActivating.value = true;

    try {
      final response = await http
          .post(
            Uri.parse(
                'https://alamoodac.com/modac/public/subscriptions/redeem-code'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'code': codeController.text.toString().trim(),
            }),
          )
          .timeout(Duration(seconds: 15));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // تحديث بيانات المستخدم
        await fetchUserSubscriptions(
          userId,
          Get.find<ChangeLanguageController>().currentLocale.value.languageCode,
        );

        Get.snackbar(
          'مبروك!'.tr,
          'تم تفعيل الباقة بنجاح'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      } else {
        _handleErrorResponse(response.statusCode, responseData);
      }
    } on SocketException {
      _showNetworkError();
    } on TimeoutException {
      _showTimeoutError();
    } catch (e) {
      _showGenericError(e);
    } finally {
      codeController.clear();
      isActivating.value = false;
    }
  }

  void _handleErrorResponse(int statusCode, Map<String, dynamic> response) {
    final messages = {
      403: 'الكود خاص بالحساب الرئيسي ولا يمكن استخدامه هنا',
      404: 'الكود غير صحيح أو منتهي الصلاحية',
      410: 'انتهت صلاحية الاشتراك الأساسي',
      422: 'يوجد خطأ في البيانات المدخلة',
    };

    Get.snackbar(
      'خطأ',
      response['message'] ?? messages[statusCode] ?? 'حدث خطأ غير متوقع',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showNetworkError() {
    Get.snackbar(
      'مشكلة في الاتصال',
      'تأكد من اتصالك بالإنترنت وحاول مجدداً',
      backgroundColor: Colors.orange,
    );
  }

  void _showTimeoutError() {
    Get.snackbar(
      'مهلة الاتصال',
      'تجاوزت مدة الانتظار، حاول مجدداً',
      backgroundColor: Colors.orange,
    );
  }

  void _showGenericError(dynamic e) {
    Get.snackbar(
      'خطأ غير متوقع',
      e.toString(),
      backgroundColor: Colors.red,
    );
    print('Activation Error: $e');
  }
}
/////////


  




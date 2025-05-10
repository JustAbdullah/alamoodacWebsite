import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/data/model/PromotedAd.dart';

import 'package:http/http.dart' as http;

import 'LoadingController.dart';

class PromotedadController extends GetxController {
  static const String baseUrl = 'https://alamoodac.com/modac/public';

  RxBool loadingAds = false.obs;
  var adsList = <PromotedAd>[].obs;

// دالة لجلب الإعلانات بناءً على الحالة واللغة
  Future<void> fetchAds(String adStatus, String language) async {
    try {
      loadingAds.value = true;

      final response = await http.get(
        Uri.parse('$baseUrl/ads/status/$adStatus/$language'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        adsList.value = jsonData.map((ad) => PromotedAd.fromJson(ad)).toList();
        print("//////////////");

        print("تم جلب البيانات بنجاح");
        print("//////////////");
        print("الاعلانات المروجة");

        // إذا أردت تهيئة قيم RxInt أو غيرها لكل إعلان يمكن إضافتها هنا
      } else {
        throw Exception('فشل في جلب الإعلانات: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      // يمكنك إضافة معالجة الأخطاء هنا إذا لزم الأمر
    } finally {
      loadingAds.value = false;
    }
  }

  // إنشاء إعلان جديد
  Future createAd(int postId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ads/create'),
      body: json.encode({
        'user_id': Get.find<LoadingController>().currentUser?.id,
        'post_id': postId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        "تم بنجاح".tr,
        "تم إرسال طلب الممول بنجاح".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
      return PromotedAd.fromJson(json.decode(response.body));
    } else {
      Get.snackbar(
        "خطأ".tr,
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      print(response.body);
      throw Exception('فشل في إنشاء الإعلان: ${response.body}');
    }
  }

  // تفعيل الإعلان
  static Future<PromotedAd> activateAd(int adId, DateTime endTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ads/activate/$adId'),
      body: json.encode({
        'ad_end_time': endTime.toIso8601String(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PromotedAd.fromJson(json.decode(response.body));
    } else {
      throw Exception('فشل في تفعيل الإعلان: ${response.body}');
    }
  }

  // حذف إعلان
  static Future<void> deleteAd(int adId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ads/delete/$adId'),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في حذف الإعلان: ${response.body}');
    }
  }
}

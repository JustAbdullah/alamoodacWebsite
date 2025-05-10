import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/appservices.dart';

class ChangeLanguageController extends GetxController {
  // اللغة الحالية
  var currentLocale = Locale('ar').obs;

  // تغيير اللغة
  void changeLanguage(String langCode) {
    if (!['ar', 'en', 'tr', 'ku'].contains(langCode)) {
      langCode = 'ar'; // لغة افتراضية إذا كانت اللغة غير مدعومة
    }
    var locale = Locale(langCode);
    currentLocale.value = locale;
    Get.updateLocale(locale);
    saveLanguage(langCode);
  }

  // حفظ اللغة في SharedPreferences
  void saveLanguage(String langCode) {
    Get.find<AppServices>().sharedPreferences.setString('lang', langCode);
  }

  // استعادة اللغة عند التشغيل
  @override
  void onInit() {
    super.onInit();
    String? savedLang =
        Get.find<AppServices>().sharedPreferences.getString('lang');
    if (savedLang != null) {
      currentLocale.value = Locale(savedLang);
      Get.updateLocale(Locale(savedLang));
    } else {
      // إذا لم يتم حفظ اللغة، استخدام لغة الجهاز
      String deviceLang = Get.deviceLocale?.languageCode ?? 'ar';
      currentLocale.value = Locale(deviceLang);
      Get.updateLocale(Locale(deviceLang));
    }
  }
}

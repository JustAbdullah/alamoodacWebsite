import 'dart:convert';
import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/data/model/user.dart';
import '../viewMobile/LoadingScreen/loadingApp.dart';
import '../viewMobile/OnAppPages/on_app_pages.dart';

class LoadingController extends GetxController {
  var isLoading = RxBool(true);
  var isGo = RxBool(false); // متغير جديد للتحكم في عملية الانتقال
  User? currentUser;
  var isMobile = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    update();
  }

  Future<void> loadUserData() async {
    if (isGo.value) return; // إذا كانت isGo = true، لا تنفذ العملية مرة أخرى

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // التحقق مما إذا كانت هذه أول مرة يُفتح فيها التطبيق
    String? firstTimeFlag = prefs.getString('firstTimeFlag');
    bool isFirstTime = firstTimeFlag == null || firstTimeFlag == 'isFirstTime';

    int delaySeconds = isFirstTime ? 3 : 3;
    await Future.delayed(Duration(seconds: delaySeconds));

    if (isFirstTime) {
      await prefs.setString('firstTimeFlag', 'isNotFirstTime');

      await Future.delayed(Duration(milliseconds: 500)); // ⏳ تأخير بسيط
      isGo.value = true; // تحديث المتغير بعد الانتقال
      isMobile.value ? Get.offAll(() => HomeScreen()) : null;
      return;
    }

    String? userData = prefs.getString('user');
    await Future.delayed(Duration(milliseconds: 500)); // ⏳ تأخير بسيط

    if (userData != null) {
      currentUser = User.fromJson(jsonDecode(userData));
      update();
    }
    update();
    isGo.value = true; // تحديث المتغير بعد الانتقال
    isMobile.value ? Get.offAll(() => HomeScreen()) : null;
  }

  Future<void> loadUserDataOnUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    // الانتظار لمدة 3 ثوانٍ (يمكنك تعديلها إذا دعت الحاجة)
    await Future.delayed(Duration(seconds: 1));

    if (userData != null) {
      currentUser = User.fromJson(jsonDecode(userData));
      update();
      isMobile.value ? Get.offAll(() => HomeScreen()) : null;
    } else {
      isMobile.value ? Get.offAll(() => HomeScreen()) : null;
      update(); // تنفيذ أي عملية في حال عدم وجود بيانات للمستخدم.
    }
  }

  Future<void> loadUserDataLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    // الانتظار لمدة 3 ثوانٍ (يمكنك تعديلها إذا دعت الحاجة)
    await Future.delayed(Duration(seconds: 1));

    if (userData != null) {
      currentUser = User.fromJson(jsonDecode(userData));
      update();
    } else {
      update(); // تنفيذ أي عملية في حال عدم وجود بيانات للمستخدم.
    }
  }
}

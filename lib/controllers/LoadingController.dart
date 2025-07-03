import 'dart:convert';
import 'package:alamoadac_website/viewMobile/HomeScreen/home_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/data/model/user.dart';
import 'package:http/http.dart' as http;

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
    
String _baseUrl ="https://alamoodac.com/modac/public";
Future<void> useFreePost(int userId) async {
  isLoading.value = true;
  final uri = Uri.parse('$_baseUrl/user/$userId/use-free-post');

  try {
    final response = await http.post(uri, headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer YOUR_TOKEN',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['success'] == true && body['user'] != null) {
        // نقرأ بيانات المستخدم كاملة من المفتاح 'user'
        final updatedUser = User.fromJson(body['user']);
        currentUser = updatedUser;

        // خزّن النموذج المحدث بالكامل في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(updatedUser.toJson()));

        Get.snackbar(
          'نجاح',
          'تم تحديث بيانات المستخدم بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'خطأ من السيرفر',
          body['message'] ?? 'فشل تحديث بيانات المستخدم',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'خطأ HTTP',
        'رمز الحالة: ${response.statusCode}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'استثناء',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
    // يعيد تحميل بيانات المستخدم من SharedPreferences أو من السيرفر
    await loadUserDataOnUpdate();
  }
}

}
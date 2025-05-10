import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constant/appcolors.dart';
import '../core/data/model/user.dart';
import '../viewMobile/Auth/ans_que_forget.dart';
import '../viewMobile/Auth/login_screen.dart';
import '../viewMobile/Auth/new_password.dart';
import '../viewsDeskTop/AuthDeskTop/ans_que_forget_destkop.dart';
import '../viewsDeskTop/AuthDeskTop/new_password_desktop.dart';
import 'LoadingController.dart';

class AuthController extends GetxController {
  RxBool isGoFromWeb = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool showTerms = false.obs;
  RxBool isHoveringTerms = false.obs;
  LoadingController loadingController = Get.put(LoadingController());
  var message = RxString('');
  User? currentUser;
  Future<void> register(String name, String password) async {
    final snackBarContext = Get.context;
    waitCheckData.value = true;
    message.value = '';

    if (name.isEmpty || password.isEmpty) {
      message.value = 'جميع الحقول مطلوبة';
      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ',
          message.value,
          backgroundColor: Colors.yellow[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
      waitCheckData.value = false;
      return;
    }

    try {
      var url = Uri.parse('https://alamoodac.com/modac/public/register');
      var response = await http.post(
        url,
        body: {
          'name': name,
          'password': password,
          'phone': '0',
        },
      );

      waitCheckData.value = false;

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('user')) {
          currentUser = User.fromJson(responseBody['user']);
          await saveUserToPreferences(currentUser!);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
          message.value = 'تم إنشاء الحساب بنجاح'.tr;
          if (snackBarContext != null) {
            Get.snackbar(
              'تمت بنجاح'.tr,
              message.value,
              backgroundColor: Colors.green[700],
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
            );
          }

          await Future.delayed(Duration(milliseconds: 500));
          final prefs = await SharedPreferences.getInstance();
          loadingController.currentUser = currentUser;
          update();
          loadingController.loadUserDataOnUpdate();
        } else if (responseBody.containsKey('error')) {
          var error = responseBody['error'];

          // عرض رسائل الأخطاء من الـ API
          if (error is Map && error.containsKey('name')) {
            String errorMessage = error['name'][0];
            if (snackBarContext != null) {
              Get.snackbar(
                'خطأ'.tr,
                errorMessage,
                backgroundColor: Colors.red[700],
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
              );
              waitCheckData.value = false;
            }
          } else if (error is Map && error.containsKey('password')) {
            String errorMessage = error['password'][0];
            if (snackBarContext != null) {
              Get.snackbar(
                'خطأ'.tr,
                errorMessage,
                backgroundColor: Colors.red[700],
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
              );
              waitCheckData.value = false;
            }
          }
        }
      } else {
        var error = jsonDecode(response.body);
        message.value = error['error'] ?? 'فشلت العملية'.tr;
        if (snackBarContext != null) {
          Get.snackbar(
            'خطأ'.tr,
            message.value,
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
          waitCheckData.value = false;
        }
      }
    } catch (e) {
      print("//////////////////////////////////////////////////////");
      print(e);
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      message.value =
          'قد يكون الاسم محجوز او كلمة المرور ضعيفة  هنالك خطا حاليًا حاول مجددًا باسم اخر وتاكد بإن كلمة المرور قوية'
              .tr;
      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ'.tr,
          message.value,
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
        );

        waitCheckData.value = false;
      }
    }
  }

  // دالة لتسجيل الدخول
  Future<void> login(String name, String password) async {
    waitCheckData.value = true;
    message.value = '';

    // التحقق من المدخلات
    if (name.isEmpty || password.isEmpty) {
      message.value = 'جميع الحقول مطلوبة'.tr;
      Get.snackbar(
        'خطأ'.tr,
        message.value,
        backgroundColor: Colors.yellow[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      waitCheckData.value = false;
      return;
    }

    var url = Uri.parse('https://alamoodac.com/modac/public/login');
    var response = await http.post(
      url,
      body: {
        'name': name,
        'password': password,
      },
    );

    waitCheckData.value = false;

    if (response.statusCode == 200) {
      message.value = 'تم تسجيل الدخول بنجاح'.tr;
      var responseBody = jsonDecode(response.body);
      currentUser = User.fromJson(responseBody['user']);
      await saveUserToPreferences(currentUser!);

      await Future.delayed(Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      loadingController.currentUser = currentUser;
      update();
      loadingController.loadUserDataOnUpdate();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      Get.snackbar(
        'تمت بنجاح'.tr,
        message.value,
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } else {
      var error = jsonDecode(response.body);
      message.value = error['error'] ?? 'فشلت العملية'.tr;

      Get.snackbar(
        'فشلت العملية'.tr,
        'كلمة المرور او الاسم مدخل بطريقة خاطئة او كليهما تاكد وحاول مجددًا'.tr,
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 7),
      );
    }
  }

  // دالة لحفظ بيانات المستخدم
  Future<void> saveUserToPreferences(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // دالة لتحديث كلمة المرور
  Future<void> resetPassword(
      String name, String phone, String newPassword) async {
    waitCheckData.value = true;
    message.value = '';

    var url = Uri.parse('https://example.com/api/reset-password');
    var response = await http.post(
      url,
      body: {
        'name': name,
        'phone': phone,
        'password': newPassword,
      },
    );

    waitCheckData.value = false;

    if (response.statusCode == 200) {
      message.value = 'تم تغيير كلمة المرور بنجاح';
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      var error = jsonDecode(response.body);
      message.value = error['error'] ?? 'فشلت العملية';
    }
  }

  // دالة لتحديث رقم الهاتف

  Future<void> updatePhone(String newPhone) async {
    final snackBarContext = Get.context;
    waitCheckData.value = true;
    message.value = '';

    var url = Uri.parse(
        'https://example.com/api/update-phone/${loadingController.currentUser?.id}');

    // إرسال الطلب لتحديث الموقع
    var response = await http.post(
      url,
      body: {
        'phone': newPhone,
      },
    );

    waitCheckData.value = false;

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      currentUser = User.fromJson(responseBody['user']);
      await saveUserToPreferences(currentUser!);

      if (responseBody['success'] != null) {
        // إذا تم تحديث الموقع بنجاح
        message.value = responseBody['success'];
        await loadingController.loadUserDataOnUpdate();
        if (snackBarContext != null) {
          Get.snackbar(
            'نجاح',
            "تم حفظ رقم هاتفك  في قاعدة البيانات بنجاح",
            backgroundColor: Colors.green[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
        }
      }
    } else {
      // في حالة حدوث خطأ
      var error = jsonDecode(response.body);
      message.value = error['error'] ?? 'فشلت العملية';

      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ',
          "لم يتم تخزين رقم هاتفك  في قاعدة البيانات حاول مجددًا",
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> updateLocation(
      int userId, double latitude, double longitude) async {
    final snackBarContext = Get.context;
    waitCheckData.value = true;
    message.value = '';

    var url =
        Uri.parse('https://alamoodac.com/modac/public/update-location/$userId');

    // إرسال الطلب لتحديث الموقع
    var response = await http.post(
      url,
      body: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    waitCheckData.value = false;

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      currentUser = User.fromJson(responseBody['user']);
      await saveUserToPreferences(currentUser!);

      if (responseBody['success'] != null) {
        // إذا تم تحديث الموقع بنجاح
        message.value = responseBody['success'];
        await loadingController.loadUserDataLocation();
        if (snackBarContext != null) {
          Get.snackbar(
            'نجاح'.tr,
            "تم حفظ موقعك الجغرافي في قاعدة البيانات بنجاح".tr,
            backgroundColor: Colors.green[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
        }
      }
    } else {
      // في حالة حدوث خطأ
      var error = jsonDecode(response.body);
      message.value = error['error'] ?? 'فشلت العملية'.tr;

      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ'.tr,
          "لم يتم تخزين الموقع الجغرافي في قاعدة البيانات حاول مجددًا".tr,
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
    }
  }

/////////////////////////////////////////////.........................///////////////

  final TextEditingController textControllerName = TextEditingController();
  final TextEditingController textControllerPassword = TextEditingController();

  RxBool isButtonEnabledNext = false.obs;
  RxBool isButtonEnabledEnd = false.obs;
  RxBool showNameText = true.obs;
  RxBool showPasswordText = false.obs;
  RxString nameEnter = "".obs;
  RxString passwordEnter = "".obs;
  RxBool waitCheckData = false.obs;

  @override
  void onInit() {
    super.onInit();
    textControllerName.addListener(() {
      isButtonEnabledNext.value = textControllerName.text.isNotEmpty;
    });
    textControllerPassword.addListener(() {
      isButtonEnabledEnd.value = textControllerPassword.text.isNotEmpty;
    });
  }

  onMove() {
    isButtonEnabledNext.value = false;
    isButtonEnabledEnd.value = false;
    showNameText.value = true;
    showPasswordText.value = false;
    nameEnter.value = "";
    passwordEnter.value = "";
    message.value = "";
    waitCheckData.value = false;
    textControllerName.clear();
    textControllerPassword.clear();
  }

  ///////////////////////////////////////الإستعادة والحذف وجلب بيانات عند فقدان كلمة المرور........../////////////
  // Get User Data

  final TextEditingController nameUserForget = TextEditingController();
  final TextEditingController PhoneNumberForget = TextEditingController();

  final TextEditingController anwOneForget = TextEditingController();
  final TextEditingController anwTwoForget = TextEditingController();
  final TextEditingController newPassworsInForget = TextEditingController();

  RxInt idUserInForget = 0.obs;
  RxString UserAnwOneInForgt = "".obs;
  RxString UserAnwTwoInForgt = "".obs;
  Future<void> getUserData(
      String name, String phone, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
          child: CircularProgressIndicator(
        color: AppColors.TheMain,
        backgroundColor: AppColors.whiteColor,
      )),
    );
    final url =
        Uri.parse('https://alamoodac.com/modac/public/users/get-user-data');
    try {
      final response = await http.post(
        url,
        body: {
          'name': name,
          'phone': phone,
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        // Handle user data
        idUserInForget.value = data['user_id']; // هنا يتم التعامل مع RxInt
        UserAnwOneInForgt.value = data['security_question_1'] ?? '';
        UserAnwTwoInForgt.value = data['security_question_2'] ?? '';
        if (isGoFromWeb.value) {
          Get.back(); // إغلاق نافذة التسجيل
          Get.dialog(
            AnsQueForgetDestkop(), // فتح نافذة تسجيل الدخول
            barrierDismissible: true,
          );
        } else {
          Get.to(AnsQueForget());
        }

        Get.snackbar('تم!'.tr, 'تم الان قم بإدخال إجابات الاسئلة التالية'.tr,
            backgroundColor: AppColors.TheMain);
      } else {
        Get.snackbar('خطا!'.tr, 'رقم الهاتف او الاسم غير صالحين'.tr,
            backgroundColor: AppColors.redColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      print("The Error is>...........");
      print(e);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Verify Answers
  Future<void> verifyAnswers(
      int userId, String answer1, String answer2, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
          child: CircularProgressIndicator(
        color: AppColors.TheMain,
        backgroundColor: AppColors.whiteColor,
      )),
    );
    final url =
        Uri.parse('https://alamoodac.com/modac/public/users/verify-answers');
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'answer_1': answer1,
          'answer_2': answer2,
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar('نجحت!'.tr,
            'نجحت عملية التحقق من هويتك..قم بإستعادة كلمة المرور الان'.tr,
            backgroundColor: Colors.green);

        if (isGoFromWeb.value) {
          Get.back(); // إغلاق نافذة تسجيل الدخول
          Get.dialog(
            NewPasswordInForgetDeskTop(),
            barrierDismissible: true,
          );
        } else {
          Get.to(NewPasswordInForget());
        }
      } else {
        Get.snackbar(
            'فشلت!'.tr,
            'البيانات التى أدخلتها غير صحيحة..حاول مجددًا بإستخدام بيانات صحيحة'
                .tr,
            backgroundColor: AppColors.redColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      print("The Erorr is02>...........");
      print(e);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Update Password
  Future<void> updatePassword(
      int userId, String newPassword, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
          child: CircularProgressIndicator(
        color: AppColors.TheMain,
        backgroundColor: AppColors.whiteColor,
      )),
    );
    final url =
        Uri.parse('https://alamoodac.com/modac/public/users/update-password');
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'new_password': newPassword,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('نجحت!'.tr,
            'نجحت عملية إستعادة كلمة المرور بنجاح! قم بستجيل دخولك الان'.tr,
            backgroundColor: Colors.green[600]);
        if (isGoFromWeb.value) {
          Get.back();
          isGoFromWeb.value = false;
        } else {
          Get.to(LoginScreen());
        }
      } else {
        Get.snackbar(
            'خطا!'.tr, 'خطا! لم تستطع من إدخال كلمة مرور جديدة حاول مجددًا'.tr,
            backgroundColor: AppColors.redColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      print("The Erorr is03>...........");
      print(e);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value == true
        ? isPasswordVisible.value = false
        : isPasswordVisible.value = true;
  }

  RxBool isFormValid = false.obs;

  void validateForm() {
    final nameValid = textControllerName.text.trim().length >= 3;
    final passValid = textControllerPassword.text.trim().length >= 4;
    isFormValid.value = nameValid && passValid;
  }

//////////////////////////////

  Future<void> registerMobile(String name, String password) async {
    final snackBarContext = Get.context;
    waitCheckData.value = true;
    message.value = '';

    if (name.isEmpty || password.isEmpty) {
      message.value = 'جميع الحقول مطلوبة';
      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ',
          message.value,
          backgroundColor: Colors.yellow[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
      waitCheckData.value = false;
      return;
    }

    try {
      var url = Uri.parse('https://alamoodac.com/modac/public/register');
      var response = await http.post(
        url,
        body: {
          'name': name,
          'password': password,
          'phone': '0',
        },
      );

      waitCheckData.value = false;

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('user')) {
          currentUser = User.fromJson(responseBody['user']);
          await saveUserToPreferences(currentUser!);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
          message.value = 'تم إنشاء الحساب بنجاح'.tr;
          if (snackBarContext != null) {
            Get.snackbar(
              'تمت بنجاح'.tr,
              message.value,
              backgroundColor: Colors.green[700],
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
            );
          }

          await Future.delayed(Duration(milliseconds: 500));
          final prefs = await SharedPreferences.getInstance();

          loadingController.loadUserDataOnUpdate();
        } else if (responseBody.containsKey('error')) {
          var error = responseBody['error'];

          // عرض رسائل الأخطاء من الـ API
          if (error is Map && error.containsKey('name')) {
            String errorMessage = error['name'][0];
            if (snackBarContext != null) {
              Get.snackbar(
                'خطأ'.tr,
                errorMessage,
                backgroundColor: Colors.red[700],
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
              );
              waitCheckData.value = false;
            }
          } else if (error is Map && error.containsKey('password')) {
            String errorMessage = error['password'][0];
            if (snackBarContext != null) {
              Get.snackbar(
                'خطأ'.tr,
                errorMessage,
                backgroundColor: Colors.red[700],
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
              );
              waitCheckData.value = false;
            }
          }
        }
      } else {
        var error = jsonDecode(response.body);
        message.value = error['error'] ?? 'فشلت العملية'.tr;
        if (snackBarContext != null) {
          Get.snackbar(
            'خطأ'.tr,
            message.value,
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
          waitCheckData.value = false;
        }
      }
    } catch (e) {
      print("//////////////////////////////////////////////////////");
      print(e);
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      print("//////////////////////////////////////////////////////");
      message.value =
          'قد يكون الاسم محجوز او كلمة المرور ضعيفة  هنالك خطا حاليًا حاول مجددًا باسم اخر وتاكد بإن كلمة المرور قوية'
              .tr;
      if (snackBarContext != null) {
        Get.snackbar(
          'خطأ'.tr,
          message.value,
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
        );

        waitCheckData.value = false;
      }
    }
  }

  // دالة لتسجيل الدخول
  Future<void> loginMobile(String name, String password) async {
    waitCheckData.value = true;
    message.value = '';

    // التحقق من المدخلات
    if (name.isEmpty || password.isEmpty) {
      message.value = 'جميع الحقول مطلوبة'.tr;
      Get.snackbar(
        'خطأ'.tr,
        message.value,
        backgroundColor: Colors.yellow[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      waitCheckData.value = false;
      return;
    }

    var url = Uri.parse('https://alamoodac.com/modac/public/login');
    var response = await http.post(
      url,
      body: {
        'name': name,
        'password': password,
      },
    );

    waitCheckData.value = false;

    if (response.statusCode == 200) {
      message.value = 'تم تسجيل الدخول بنجاح'.tr;
      var responseBody = jsonDecode(response.body);
      currentUser = User.fromJson(responseBody['user']);
      await saveUserToPreferences(currentUser!);

      await Future.delayed(Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      loadingController.loadUserDataOnUpdate();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      Get.snackbar(
        'تمت بنجاح'.tr,
        message.value,
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } else {
      var error = jsonDecode(response.body);
      message.value = error['error'] ?? 'فشلت العملية'.tr;

      Get.snackbar(
        'فشلت العملية'.tr,
        'كلمة المرور او الاسم مدخل بطريقة خاطئة او كليهما تاكد وحاول مجددًا'.tr,
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 7),
      );
    }
  }
}

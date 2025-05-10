import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../../controllers/ThemeController.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constant/appcolors.dart';

class AuctionDetailsScreen extends StatefulWidget {
  @override
  _AuctionDetailsScreenState createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  final ThemeController themeController = Get.find();

  final HomeController controller = Get.put(HomeController());
  Timer? _timer;
  RxString countdown = ''.obs;
  var currency = 'IQD'.obs; // العملة الافتراضية
  double exchangeRate = 0.00076; // سعر الصرف

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (controller.auction.value != null) {
        final endTime = controller.auction.value!.endTime;
        final remaining = endTime.difference(DateTime.now());
        if (remaining.isNegative) {
          countdown.value = "المزاد انتهى!".tr;
          _timer?.cancel();
        } else {
          countdown.value =
              "${remaining.inDays} يوم ${remaining.inHours % 24} ساعة ${remaining.inMinutes % 60} دقيقة ${remaining.inSeconds % 60} ثانية";
        }
      }
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  String getConvertedPrice(String price) {
    String cleanedPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
    double priceValue = double.tryParse(cleanedPrice) ?? 0.0;
    final numberFormat = NumberFormat("#,###");

    if (currency.value == 'USD') {
      return numberFormat.format(priceValue * exchangeRate) + 'دولار'.tr;
    }
    return numberFormat.format(priceValue) + 'دينار'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // عرض `SizedBox`
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.auction.value == null) {
          return Center(
              child: Text(
            'المزاد غير متوفر.'.tr,
            style: TextStyle(
              color: AppColors.textColor(themeController.isDarkMode.value),
            ),
          ));
        }

        final auction = controller.auction.value!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرقم التعريفي
              Row(
                children: [
                  Text(
                    'رقم المزاد:'.tr,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DinarOne',
                        color: AppColors.textColor(
                            themeController.isDarkMode.value)),
                  ),
                  Text(
                    '${auction.id}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DinarOne',
                        color: AppColors.textColor(
                            themeController.isDarkMode.value)),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // السعر الحالي والسعر الابتدائي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السعر الحالي'.tr,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'DinarOne',
                            color: AppColors.textColor(
                                themeController.isDarkMode.value)),
                      ),
                      Text(
                        getConvertedPrice(auction.currentPrice.toString()),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'DinarOne',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'السعر الابتدائي'.tr,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'DinarOne',
                            color: AppColors.textColor(
                                themeController.isDarkMode.value)),
                      ),
                      Text(
                        getConvertedPrice(auction.startPrice.toString()),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'DinarOne',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // بداية ونهاية المزاد
              Text(
                'بداية المزاد:'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'DinarOne',
                    color:
                        AppColors.textColor(themeController.isDarkMode.value)),
              ),
              Text(
                formatDateTime(
                  auction.startTime,
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor(themeController.isDarkMode.value),
                  fontFamily: 'DinarOne',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'نهاية المزاد:'.tr,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'DinarOne',
                    color:
                        AppColors.textColor(themeController.isDarkMode.value)),
              ),
              Obx(() => Text(
                    countdown.value.isNotEmpty
                        ? countdown.value
                        : formatDateTime(auction.endTime),
                    style: TextStyle(
                      fontSize: 18,
                      color: countdown.value == "المزاد انتهى!"
                          ? Colors.red
                          : AppColors.textColor(
                              themeController.isDarkMode.value),
                      fontFamily: 'DinarOne',
                    ),
                  )),
              SizedBox(height: 10),

              // حالة المزاد
              Text(
                'حالة المزاد:'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'DinarOne',
                  color: AppColors.textColor(themeController.isDarkMode.value),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: auction.status == "active" ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  auction.status == "active" ? 'نشط'.tr : 'منتهي'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DinarOne',
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

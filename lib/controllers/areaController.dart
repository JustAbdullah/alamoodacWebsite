import 'package:get/get.dart';

import '../core/data/model/Area.dart';

class AreaController extends GetxController {
  final idOfArea = Rx<int?>(null); // يجب أن يكون Rx<int?> وليس RxInt?
  Rx<String?> selectedAreaName = Rx<String?>(null); // تغيير هنا
  final Map<int, List<Area>> cityAreas = {
    /// 1. بغداد (تمت إضافة 10 مناطق جديدة)
    1: [
      Area(id: 101, name: "الرصافة", cityId: 1),
      Area(id: 102, name: "الكرادة", cityId: 1),
      Area(id: 103, name: "المنصور", cityId: 1),
      Area(id: 104, name: "الأعظمية", cityId: 1),
      Area(id: 105, name: "الكاظمية", cityId: 1),
      Area(id: 106, name: "الصدر الأولى", cityId: 1),
      Area(id: 107, name: "الجادرية", cityId: 1),
      Area(id: 108, name: "البياع", cityId: 1),
      Area(id: 109, name: "الشعب", cityId: 1),
      Area(id: 110, name: "اليرموك", cityId: 1),
      Area(id: 111, name: "الوزيرية", cityId: 1),
      Area(id: 112, name: "الزعفرانية", cityId: 1),
      Area(id: 113, name: "الدورة", cityId: 1),
      Area(id: 114, name: "الغزالية", cityId: 1),
      Area(id: 115, name: "الحبيبية", cityId: 1),
      Area(id: 116, name: "النهروان", cityId: 1),
      Area(id: 117, name: "الرشيد", cityId: 1),
      Area(id: 118, name: "الطارمية", cityId: 1),
      Area(id: 119, name: "السبع أبكار", cityId: 1),
      Area(id: 120, name: "الوشاش", cityId: 1),
    ],

    /// 2. البصرة (تمت إضافة 8 مناطق جديدة)
    2: [
      Area(id: 201, name: "البصرة القديمة", cityId: 2),
      Area(id: 202, name: "حي التنومة", cityId: 2),
      Area(id: 203, name: "حي العشار", cityId: 2),
      Area(id: 204, name: "حي الجزائر", cityId: 2),
      Area(id: 205, name: "حي القبلة", cityId: 2),
      Area(id: 206, name: "أبو الخصيب", cityId: 2),
      Area(id: 207, name: "الهارثة", cityId: 2),
      Area(id: 208, name: "المدينة", cityId: 2),
      Area(id: 209, name: "الزبير", cityId: 2),
      Area(id: 210, name: "الفاو", cityId: 2),
      Area(id: 211, name: "القرنة", cityId: 2),
      Area(id: 212, name: "الشعيبة", cityId: 2),
      Area(id: 213, name: "الخورة", cityId: 2),
      Area(id: 214, name: "البراضعية", cityId: 2),
      Area(id: 215, name: "الجبيلة", cityId: 2),
      Area(id: 216, name: "العدالة", cityId: 2),
    ],

    /// 3. نينوى (تمت إضافة 7 مناطق جديدة)
    3: [
      Area(id: 301, name: "الموصل القديمة", cityId: 3),
      Area(id: 302, name: "حي النور", cityId: 3),
      Area(id: 303, name: "حي الزهراء", cityId: 3),
      Area(id: 304, name: "حي التحرير", cityId: 3),
      Area(id: 305, name: "حي القادسية", cityId: 3),
      Area(id: 306, name: "حي المنصور", cityId: 3),
      Area(id: 307, name: "حي السكك", cityId: 3),
      Area(id: 308, name: "حي الوحدة", cityId: 3),
      Area(id: 309, name: "حي البكر", cityId: 3),
      Area(id: 310, name: "حي الشفاء", cityId: 3),
      Area(id: 311, name: "حي العدالة", cityId: 3),
      Area(id: 312, name: "حي الرشيد", cityId: 3),
      Area(id: 313, name: "حي الكرامة", cityId: 3),
      Area(id: 314, name: "حي البعث", cityId: 3),
    ],

    /// 4. أربيل (تمت إضافة 6 مناطق جديدة)
    4: [
      Area(id: 401, name: "معسكر", cityId: 4),
      Area(id: 402, name: "عرصاتا", cityId: 4),
      Area(id: 403, name: "دارتو", cityId: 4),
      Area(id: 404, name: "عينكاوة", cityId: 4),
      Area(id: 405, name: "كردستان", cityId: 4),
      Area(id: 406, name: "سيتاك", cityId: 4),
      Area(id: 407, name: "شورش", cityId: 4),
      Area(id: 408, name: "نورك", cityId: 4),
      Area(id: 409, name: "كسنزان", cityId: 4),
      Area(id: 410, name: "بهرز", cityId: 4),
      Area(id: 411, name: "قلات", cityId: 4),
      Area(id: 412, name: "باستورة", cityId: 4),
    ],

    /// 5. دهوك (تمت إضافة 5 مناطق جديدة)
    5: [
      Area(id: 501, name: "دهوك الجديدة", cityId: 5),
      Area(id: 502, name: "محمودية", cityId: 5),
      Area(id: 503, name: "هفتان", cityId: 5),
      Area(id: 504, name: "ميسوري", cityId: 5),
      Area(id: 505, name: "باشمة", cityId: 5),
      Area(id: 506, name: "كسنزان", cityId: 5),
      Area(id: 507, name: "زاويته", cityId: 5),
      Area(id: 508, name: "شيلادزه", cityId: 5),
      Area(id: 509, name: "دوميز", cityId: 5),
      Area(id: 510, name: "بامرني", cityId: 5),
      Area(id: 511, name: "سولاف", cityId: 5),
    ],

    /// 6. السليمانية (تمت إضافة 6 مناطق جديدة)
    6: [
      Area(id: 601, name: "سرشم", cityId: 6),
      Area(id: 602, name: "تاني", cityId: 6),
      Area(id: 603, name: "أسكان", cityId: 6),
      Area(id: 604, name: "بريادةر", cityId: 6),
      Area(id: 605, name: "جواركا", cityId: 6),
      Area(id: 606, name: "ميكائيل", cityId: 6),
      Area(id: 607, name: "رزكاري", cityId: 6),
      Area(id: 608, name: "شورش", cityId: 6),
      Area(id: 609, name: "بازيان", cityId: 6),
      Area(id: 610, name: "قادر كرم", cityId: 6),
      Area(id: 611, name: "سيد صادق", cityId: 6),
      Area(id: 612, name: "بنجوين", cityId: 6),
    ],

    /// 7. كركوك (تمت إضافة 5 مناطق جديدة)
    7: [
      Area(id: 701, name: "الرشاد", cityId: 7),
      Area(id: 702, name: "الزنجيلي", cityId: 7),
      Area(id: 703, name: "الطوبجي", cityId: 7),
      Area(id: 704, name: "النور", cityId: 7),
      Area(id: 705, name: "السلام", cityId: 7),
      Area(id: 706, name: "المصلى", cityId: 7),
      Area(id: 707, name: "الواسطي", cityId: 7),
      Area(id: 708, name: "الخضراء", cityId: 7),
      Area(id: 709, name: "العباس", cityId: 7),
      Area(id: 710, name: "الحرية", cityId: 7),
      Area(id: 711, name: "الزهور", cityId: 7),
    ],

    /// 8. النجف (تمت إضافة 5 مناطق جديدة)
    8: [
      Area(id: 801, name: "الأنباري", cityId: 8),
      Area(id: 802, name: "الخضراء", cityId: 8),
      Area(id: 803, name: "الحنانة", cityId: 8),
      Area(id: 804, name: "المشراق", cityId: 8),
      Area(id: 805, name: "العباسية", cityId: 8),
      Area(id: 806, name: "الغري", cityId: 8),
      Area(id: 807, name: "الزهراء", cityId: 8),
      Area(id: 808, name: "النهضة", cityId: 8),
      Area(id: 809, name: "الكرامة", cityId: 8),
      Area(id: 810, name: "السلام", cityId: 8),
      Area(id: 811, name: "الفيحاء", cityId: 8),
    ],

    /// 9. كربلاء (تمت إضافة 5 مناطق جديدة)
    9: [
      Area(id: 901, name: "المخيم", cityId: 9),
      Area(id: 902, name: "باب بغداد", cityId: 9),
      Area(id: 903, name: "العباسية", cityId: 9),
      Area(id: 904, name: "الحسينية", cityId: 9),
      Area(id: 905, name: "الحر", cityId: 9),
      Area(id: 906, name: "الخيرات", cityId: 9),
      Area(id: 907, name: "الزهراء", cityId: 9),
      Area(id: 908, name: "النهضة", cityId: 9),
      Area(id: 909, name: "الكرامة", cityId: 9),
      Area(id: 910, name: "السلام", cityId: 9),
      Area(id: 911, name: "الفيحاء", cityId: 9),
    ],

    /// 10. ذي قار (تمت إضافة 5 مناطق جديدة)
    10: [
      Area(id: 1001, name: "الحكيمية", cityId: 10),
      Area(id: 1002, name: "الجمهورية", cityId: 10),
      Area(id: 1003, name: "النهضة", cityId: 10),
      Area(id: 1004, name: "الجزيرة", cityId: 10),
      Area(id: 1005, name: "العدل", cityId: 10),
      Area(id: 1006, name: "الفيحاء", cityId: 10),
      Area(id: 1007, name: "الزهراء", cityId: 10),
      Area(id: 1008, name: "الكرامة", cityId: 10),
      Area(id: 1009, name: "السلام", cityId: 10),
      Area(id: 1010, name: "العباس", cityId: 10),
      Area(id: 1011, name: "الرشيد", cityId: 10),
    ],

    /// 11. الأنبار (تمت إضافة 5 مناطق جديدة)
    11: [
      Area(id: 1101, name: "التاميم", cityId: 11),
      Area(id: 1102, name: "الخالدية", cityId: 11),
      Area(id: 1103, name: "النداء", cityId: 11),
      Area(id: 1104, name: "الرحالة", cityId: 11),
      Area(id: 1105, name: "الكرابلة", cityId: 11),
      Area(id: 1106, name: "العبيدي", cityId: 11),
      Area(id: 1107, name: "الرمادي الجديدة", cityId: 11),
      Area(id: 1108, name: "الفلوجة الجديدة", cityId: 11),
      Area(id: 1109, name: "الهبانية", cityId: 11),
      Area(id: 1110, name: "الرطبة", cityId: 11),
      Area(id: 1111, name: "القائم", cityId: 11),
    ],

    /// 12. ديالى (تمت إضافة 5 مناطق جديدة)
    12: [
      Area(id: 1201, name: "المقدادية", cityId: 12),
      Area(id: 1202, name: "الخالص", cityId: 12),
      Area(id: 1203, name: "بلدروز", cityId: 12),
      Area(id: 1204, name: "المنصورية", cityId: 12),
      Area(id: 1205, name: "الخضراء", cityId: 12),
      Area(id: 1206, name: "الطالبية", cityId: 12),
      Area(id: 1207, name: "الزهراء", cityId: 12),
      Area(id: 1208, name: "النهضة", cityId: 12),
      Area(id: 1209, name: "الكرامة", cityId: 12),
      Area(id: 1210, name: "السلام", cityId: 12),
      Area(id: 1211, name: "الفيحاء", cityId: 12),
    ],

    /// 13. ميسان (تمت إضافة 5 مناطق جديدة)
    13: [
      Area(id: 1301, name: "العمارة الجديدة", cityId: 13),
      Area(id: 1302, name: "الطلائع", cityId: 13),
      Area(id: 1303, name: "الكرامة", cityId: 13),
      Area(id: 1304, name: "النهضة", cityId: 13),
      Area(id: 1305, name: "الدفاع", cityId: 13),
      Area(id: 1306, name: "السلام", cityId: 13),
      Area(id: 1307, name: "الزهراء", cityId: 13),
      Area(id: 1308, name: "العباس", cityId: 13),
      Area(id: 1309, name: "الرشيد", cityId: 13),
      Area(id: 1310, name: "الفيحاء", cityId: 13),
      Area(id: 1311, name: "الكرخ", cityId: 13),
    ],

    /// 14. بابل (تمت إضافة 5 مناطق جديدة)
    14: [
      Area(id: 1401, name: "الحلة الجديدة", cityId: 14),
      Area(id: 1402, name: "الأسرة", cityId: 14),
      Area(id: 1403, name: "العباس", cityId: 14),
      Area(id: 1404, name: "النهضة", cityId: 14),
      Area(id: 1405, name: "الزوارة", cityId: 14),
      Area(id: 1406, name: "الكرخ", cityId: 14),
      Area(id: 1407, name: "الزهراء", cityId: 14),
      Area(id: 1408, name: "الكرامة", cityId: 14),
      Area(id: 1409, name: "السلام", cityId: 14),
      Area(id: 1410, name: "الفيحاء", cityId: 14),
      Area(id: 1411, name: "الرشيد", cityId: 14),
    ],

    /// 15. القادسية (تمت إضافة 5 مناطق جديدة)
    15: [
      Area(id: 1501, name: "الشنافية", cityId: 15),
      Area(id: 1502, name: "الديوانية الجديدة", cityId: 15),
      Area(id: 1503, name: "الرشيد", cityId: 15),
      Area(id: 1504, name: "الكرادة", cityId: 15),
      Area(id: 1505, name: "الزهراء", cityId: 15),
      Area(id: 1506, name: "الحرية", cityId: 15),
      Area(id: 1507, name: "النهضة", cityId: 15),
      Area(id: 1508, name: "الكرامة", cityId: 15),
      Area(id: 1509, name: "السلام", cityId: 15),
      Area(id: 1510, name: "الفيحاء", cityId: 15),
      Area(id: 1511, name: "العباس", cityId: 15),
    ],

    /// 16. صلاح الدين (تمت إضافة 5 مناطق جديدة)
    16: [
      Area(id: 1601, name: "الدور", cityId: 16),
      Area(id: 1602, name: "الشرقاط", cityId: 16),
      Area(id: 1603, name: "تكريت الجديدة", cityId: 16),
      Area(id: 1604, name: "الضلوعية", cityId: 16),
      Area(id: 1605, name: "السامر", cityId: 16),
      Area(id: 1606, name: "اليعربية", cityId: 16),
      Area(id: 1607, name: "الزهراء", cityId: 16),
      Area(id: 1608, name: "النهضة", cityId: 16),
      Area(id: 1609, name: "الكرامة", cityId: 16),
      Area(id: 1610, name: "السلام", cityId: 16),
      Area(id: 1611, name: "الفيحاء", cityId: 16),
    ],

    /// 17. المثنى (تمت إضافة 5 مناطق جديدة)
    17: [
      Area(id: 1701, name: "الرومي", cityId: 17),
      Area(id: 1702, name: "الخضر", cityId: 17),
      Area(id: 1703, name: "النهضة", cityId: 17),
      Area(id: 1704, name: "الجامعة", cityId: 17),
      Area(id: 1705, name: "السلام", cityId: 17),
      Area(id: 1706, name: "الفيحاء", cityId: 17),
      Area(id: 1707, name: "الزهراء", cityId: 17),
      Area(id: 1708, name: "الكرامة", cityId: 17),
      Area(id: 1709, name: "الرشيد", cityId: 17),
      Area(id: 1710, name: "العباس", cityId: 17),
      Area(id: 1711, name: "الدفاع", cityId: 17),
    ],

    /// 18. واسط (تمت إضافة 5 مناطق جديدة)
    18: [
      Area(id: 1801, name: "الحي الصناعي", cityId: 18),
      Area(id: 1802, name: "الكرخ", cityId: 18),
      Area(id: 1803, name: "الرسالة", cityId: 18),
      Area(id: 1804, name: "الزهراء", cityId: 18),
      Area(id: 1805, name: "النهضة", cityId: 18),
      Area(id: 1806, name: "العباس", cityId: 18),
      Area(id: 1807, name: "الكرامة", cityId: 18),
      Area(id: 1808, name: "السلام", cityId: 18),
      Area(id: 1809, name: "الفيحاء", cityId: 18),
      Area(id: 1810, name: "الرشيد", cityId: 18),
      Area(id: 1811, name: "الدفاع", cityId: 18),
    ],
  };

  List<Area> getAreasByCityId(int cityId) {
    return cityAreas[cityId] ?? [];
  }

  final Map<int, List<Area>> cityAreasEn = {
    /// 1. Baghdad
    1: [
      Area(id: 101, name: "Al-Rusafa", cityId: 1),
      Area(id: 102, name: "Al-Karrada", cityId: 1),
      Area(id: 103, name: "Al-Mansour", cityId: 1),
      Area(id: 104, name: "Al-A'zamiyah", cityId: 1),
      Area(id: 105, name: "Al-Kadhimiya", cityId: 1),
      Area(id: 106, name: "Al-Sadr City", cityId: 1),
      Area(id: 107, name: "Al-Jadriya", cityId: 1),
      Area(id: 108, name: "Al-Bayaa", cityId: 1),
      Area(id: 109, name: "Al-Shaab", cityId: 1),
      Area(id: 110, name: "Al-Yarmouk", cityId: 1),
      Area(id: 111, name: "Al-Waziriya", cityId: 1),
      Area(id: 112, name: "Al-Za'faraniya", cityId: 1),
      Area(id: 113, name: "Al-Dora", cityId: 1),
      Area(id: 114, name: "Al-Ghazaliya", cityId: 1),
      Area(id: 115, name: "Al-Habibiya", cityId: 1),
      Area(id: 116, name: "Al-Nahrawan", cityId: 1),
      Area(id: 117, name: "Al-Rashid", cityId: 1),
      Area(id: 118, name: "Al-Tarmiyah", cityId: 1),
      Area(id: 119, name: "Al-Saba Abkar", cityId: 1),
      Area(id: 120, name: "Al-Washash", cityId: 1),
    ],

    /// 2. Basra
    2: [
      Area(id: 201, name: "Old Basra", cityId: 2),
      Area(id: 202, name: "Al-Tanuma", cityId: 2),
      Area(id: 203, name: "Al-Ashar", cityId: 2),
      Area(id: 204, name: "Al-Jazair", cityId: 2),
      Area(id: 205, name: "Al-Qibla", cityId: 2),
      Area(id: 206, name: "Abu Al-Khaseeb", cityId: 2),
      Area(id: 207, name: "Al-Hartha", cityId: 2),
      Area(id: 208, name: "Al-Madina", cityId: 2),
      Area(id: 209, name: "Al-Zubair", cityId: 2),
      Area(id: 210, name: "Al-Faw", cityId: 2),
      Area(id: 211, name: "Al-Qurna", cityId: 2),
      Area(id: 212, name: "Al-Shuaiba", cityId: 2),
      Area(id: 213, name: "Al-Khora", cityId: 2),
      Area(id: 214, name: "Al-Baradiya", cityId: 2),
      Area(id: 215, name: "Al-Jubaila", cityId: 2),
      Area(id: 216, name: "Al-Adala", cityId: 2),
    ],

    /// 3. Nineveh
    3: [
      Area(id: 301, name: "Old Mosul", cityId: 3),
      Area(id: 302, name: "Al-Nour", cityId: 3),
      Area(id: 303, name: "Al-Zahraa", cityId: 3),
      Area(id: 304, name: "Al-Tahrir", cityId: 3),
      Area(id: 305, name: "Al-Qadisiyah", cityId: 3),
      Area(id: 306, name: "Al-Mansour", cityId: 3),
      Area(id: 307, name: "Al-Sikkak", cityId: 3),
      Area(id: 308, name: "Al-Wehda", cityId: 3),
      Area(id: 309, name: "Al-Bakr", cityId: 3),
      Area(id: 310, name: "Al-Shifaa", cityId: 3),
      Area(id: 311, name: "Al-Adala", cityId: 3),
      Area(id: 312, name: "Al-Rashid", cityId: 3),
      Area(id: 313, name: "Al-Karama", cityId: 3),
      Area(id: 314, name: "Al-Baath", cityId: 3),
    ],

    /// 4. Erbil
    4: [
      Area(id: 401, name: "Masif", cityId: 4),
      Area(id: 402, name: "Ainkawa", cityId: 4),
      Area(id: 403, name: "Daratu", cityId: 4),
      Area(id: 404, name: "Ain Kawa", cityId: 4),
      Area(id: 405, name: "Kurdistan", cityId: 4),
      Area(id: 406, name: "Setak", cityId: 4),
      Area(id: 407, name: "Shorsh", cityId: 4),
      Area(id: 408, name: "Nork", cityId: 4),
      Area(id: 409, name: "Kasanazan", cityId: 4),
      Area(id: 410, name: "Bahrz", cityId: 4),
      Area(id: 411, name: "Qalat", cityId: 4),
      Area(id: 412, name: "Bastora", cityId: 4),
    ],

    /// 5. Duhok
    5: [
      Area(id: 501, name: "New Duhok", cityId: 5),
      Area(id: 502, name: "Mahmoudiya", cityId: 5),
      Area(id: 503, name: "Haftan", cityId: 5),
      Area(id: 504, name: "Misuri", cityId: 5),
      Area(id: 505, name: "Bashma", cityId: 5),
      Area(id: 506, name: "Kasanazan", cityId: 5),
      Area(id: 507, name: "Zawita", cityId: 5),
      Area(id: 508, name: "Shiladze", cityId: 5),
      Area(id: 509, name: "Domiz", cityId: 5),
      Area(id: 510, name: "Bamerni", cityId: 5),
      Area(id: 511, name: "Sulav", cityId: 5),
    ],

    /// 6. Sulaymaniyah
    6: [
      Area(id: 601, name: "Sarcham", cityId: 6),
      Area(id: 602, name: "Tani", cityId: 6),
      Area(id: 603, name: "Askan", cityId: 6),
      Area(id: 604, name: "Briyadr", cityId: 6),
      Area(id: 605, name: "Gawraka", cityId: 6),
      Area(id: 606, name: "Mikail", cityId: 6),
      Area(id: 607, name: "Rizgari", cityId: 6),
      Area(id: 608, name: "Shorsh", cityId: 6),
      Area(id: 609, name: "Bazyan", cityId: 6),
      Area(id: 610, name: "Qadir Karam", cityId: 6),
      Area(id: 611, name: "Said Sadiq", cityId: 6),
      Area(id: 612, name: "Penjwin", cityId: 6),
    ],

    /// 7. Kirkuk
    7: [
      Area(id: 701, name: "Al-Rashad", cityId: 7),
      Area(id: 702, name: "Al-Zanjili", cityId: 7),
      Area(id: 703, name: "Al-Tobchi", cityId: 7),
      Area(id: 704, name: "Al-Nour", cityId: 7),
      Area(id: 705, name: "Al-Salam", cityId: 7),
      Area(id: 706, name: "Al-Musalla", cityId: 7),
      Area(id: 707, name: "Al-Wasiti", cityId: 7),
      Area(id: 708, name: "Al-Khadra", cityId: 7),
      Area(id: 709, name: "Al-Abbas", cityId: 7),
      Area(id: 710, name: "Al-Hurriya", cityId: 7),
      Area(id: 711, name: "Al-Zuhour", cityId: 7),
    ],

    /// 8. Najaf
    8: [
      Area(id: 801, name: "Al-Anbari", cityId: 8),
      Area(id: 802, name: "Al-Khadra", cityId: 8),
      Area(id: 803, name: "Al-Hanana", cityId: 8),
      Area(id: 804, name: "Al-Mishraq", cityId: 8),
      Area(id: 805, name: "Al-Abbasiya", cityId: 8),
      Area(id: 806, name: "Al-Ghari", cityId: 8),
      Area(id: 807, name: "Al-Zahraa", cityId: 8),
      Area(id: 808, name: "Al-Nahda", cityId: 8),
      Area(id: 809, name: "Al-Karama", cityId: 8),
      Area(id: 810, name: "Al-Salam", cityId: 8),
      Area(id: 811, name: "Al-Faiha", cityId: 8),
    ],

    /// 9. Karbala
    9: [
      Area(id: 901, name: "Al-Mukhayam", cityId: 9),
      Area(id: 902, name: "Bab Baghdad", cityId: 9),
      Area(id: 903, name: "Al-Abbasiya", cityId: 9),
      Area(id: 904, name: "Al-Husseiniya", cityId: 9),
      Area(id: 905, name: "Al-Hurr", cityId: 9),
      Area(id: 906, name: "Al-Khayrat", cityId: 9),
      Area(id: 907, name: "Al-Zahraa", cityId: 9),
      Area(id: 908, name: "Al-Nahda", cityId: 9),
      Area(id: 909, name: "Al-Karama", cityId: 9),
      Area(id: 910, name: "Al-Salam", cityId: 9),
      Area(id: 911, name: "Al-Faiha", cityId: 9),
    ],

    /// 10. Dhi Qar
    10: [
      Area(id: 1001, name: "Al-Hakimiya", cityId: 10),
      Area(id: 1002, name: "Al-Jumhuriya", cityId: 10),
      Area(id: 1003, name: "Al-Nahda", cityId: 10),
      Area(id: 1004, name: "Al-Jazeera", cityId: 10),
      Area(id: 1005, name: "Al-Adl", cityId: 10),
      Area(id: 1006, name: "Al-Faiha", cityId: 10),
      Area(id: 1007, name: "Al-Zahraa", cityId: 10),
      Area(id: 1008, name: "Al-Karama", cityId: 10),
      Area(id: 1009, name: "Al-Salam", cityId: 10),
      Area(id: 1010, name: "Al-Abbas", cityId: 10),
      Area(id: 1011, name: "Al-Rashid", cityId: 10),
    ],

    /// 11. Anbar
    11: [
      Area(id: 1101, name: "Al-Tameem", cityId: 11),
      Area(id: 1102, name: "Al-Khalidiya", cityId: 11),
      Area(id: 1103, name: "Al-Nidaa", cityId: 11),
      Area(id: 1104, name: "Al-Rahala", cityId: 11),
      Area(id: 1105, name: "Al-Karabla", cityId: 11),
      Area(id: 1106, name: "Al-Abidi", cityId: 11),
      Area(id: 1107, name: "New Ramadi", cityId: 11),
      Area(id: 1108, name: "New Fallujah", cityId: 11),
      Area(id: 1109, name: "Al-Habbaniya", cityId: 11),
      Area(id: 1110, name: "Al-Rutba", cityId: 11),
      Area(id: 1111, name: "Al-Qaim", cityId: 11),
    ],

    /// 12. Diyala
    12: [
      Area(id: 1201, name: "Al-Muqdadiya", cityId: 12),
      Area(id: 1202, name: "Al-Khalis", cityId: 12),
      Area(id: 1203, name: "Baladrooz", cityId: 12),
      Area(id: 1204, name: "Al-Mansouriya", cityId: 12),
      Area(id: 1205, name: "Al-Khadra", cityId: 12),
      Area(id: 1206, name: "Al-Talibiya", cityId: 12),
      Area(id: 1207, name: "Al-Zahraa", cityId: 12),
      Area(id: 1208, name: "Al-Nahda", cityId: 12),
      Area(id: 1209, name: "Al-Karama", cityId: 12),
      Area(id: 1210, name: "Al-Salam", cityId: 12),
      Area(id: 1211, name: "Al-Faiha", cityId: 12),
    ],

    /// 13. Maysan
    13: [
      Area(id: 1301, name: "New Amara", cityId: 13),
      Area(id: 1302, name: "Al-Talaea", cityId: 13),
      Area(id: 1303, name: "Al-Karama", cityId: 13),
      Area(id: 1304, name: "Al-Nahda", cityId: 13),
      Area(id: 1305, name: "Al-Difa", cityId: 13),
      Area(id: 1306, name: "Al-Salam", cityId: 13),
      Area(id: 1307, name: "Al-Zahraa", cityId: 13),
      Area(id: 1308, name: "Al-Abbas", cityId: 13),
      Area(id: 1309, name: "Al-Rashid", cityId: 13),
      Area(id: 1310, name: "Al-Faiha", cityId: 13),
      Area(id: 1311, name: "Al-Karkh", cityId: 13),
    ],

    /// 14. Babylon
    14: [
      Area(id: 1401, name: "New Hilla", cityId: 14),
      Area(id: 1402, name: "Al-Usra", cityId: 14),
      Area(id: 1403, name: "Al-Abbas", cityId: 14),
      Area(id: 1404, name: "Al-Nahda", cityId: 14),
      Area(id: 1405, name: "Al-Zawra", cityId: 14),
      Area(id: 1406, name: "Al-Karkh", cityId: 14),
      Area(id: 1407, name: "Al-Zahraa", cityId: 14),
      Area(id: 1408, name: "Al-Karama", cityId: 14),
      Area(id: 1409, name: "Al-Salam", cityId: 14),
      Area(id: 1410, name: "Al-Faiha", cityId: 14),
      Area(id: 1411, name: "Al-Rashid", cityId: 14),
    ],

    /// 15. Al-Qadisiyah
    15: [
      Area(id: 1501, name: "Al-Shanafiya", cityId: 15),
      Area(id: 1502, name: "New Diwaniya", cityId: 15),
      Area(id: 1503, name: "Al-Rashid", cityId: 15),
      Area(id: 1504, name: "Al-Karrada", cityId: 15),
      Area(id: 1505, name: "Al-Zahraa", cityId: 15),
      Area(id: 1506, name: "Al-Hurriya", cityId: 15),
      Area(id: 1507, name: "Al-Nahda", cityId: 15),
      Area(id: 1508, name: "Al-Karama", cityId: 15),
      Area(id: 1509, name: "Al-Salam", cityId: 15),
      Area(id: 1510, name: "Al-Faiha", cityId: 15),
      Area(id: 1511, name: "Al-Abbas", cityId: 15),
    ],

    /// 16. Salah ad-Din
    16: [
      Area(id: 1601, name: "Al-Dour", cityId: 16),
      Area(id: 1602, name: "Al-Sharqat", cityId: 16),
      Area(id: 1603, name: "New Tikrit", cityId: 16),
      Area(id: 1604, name: "Al-Dhuluiya", cityId: 16),
      Area(id: 1605, name: "Al-Samir", cityId: 16),
      Area(id: 1606, name: "Al-Ya'rubiya", cityId: 16),
      Area(id: 1607, name: "Al-Zahraa", cityId: 16),
      Area(id: 1608, name: "Al-Nahda", cityId: 16),
      Area(id: 1609, name: "Al-Karama", cityId: 16),
      Area(id: 1610, name: "Al-Salam", cityId: 16),
      Area(id: 1611, name: "Al-Faiha", cityId: 16),
    ],

    /// 17. Al-Muthanna
    17: [
      Area(id: 1701, name: "Al-Rumi", cityId: 17),
      Area(id: 1702, name: "Al-Khidr", cityId: 17),
      Area(id: 1703, name: "Al-Nahda", cityId: 17),
      Area(id: 1704, name: "Al-Jamiya", cityId: 17),
      Area(id: 1705, name: "Al-Salam", cityId: 17),
      Area(id: 1706, name: "Al-Faiha", cityId: 17),
      Area(id: 1707, name: "Al-Zahraa", cityId: 17),
      Area(id: 1708, name: "Al-Karama", cityId: 17),
      Area(id: 1709, name: "Al-Rashid", cityId: 17),
      Area(id: 1710, name: "Al-Abbas", cityId: 17),
      Area(id: 1711, name: "Al-Difa", cityId: 17),
    ],

    /// 18. Wasit
    18: [
      Area(id: 1801, name: "Industrial Area", cityId: 18),
      Area(id: 1802, name: "Al-Karkh", cityId: 18),
      Area(id: 1803, name: "Al-Risala", cityId: 18),
      Area(id: 1804, name: "Al-Zahraa", cityId: 18),
      Area(id: 1805, name: "Al-Nahda", cityId: 18),
      Area(id: 1806, name: "Al-Abbas", cityId: 18),
      Area(id: 1807, name: "Al-Karama", cityId: 18),
      Area(id: 1808, name: "Al-Salam", cityId: 18),
      Area(id: 1809, name: "Al-Faiha", cityId: 18),
      Area(id: 1810, name: "Al-Rashid", cityId: 18),
      Area(id: 1811, name: "Al-Difa", cityId: 18),
    ],
  };

  List<Area> getAreasByCityIdEn(int cityId) {
    return cityAreasEn[cityId] ?? [];
  }

  //////////////////////
  final Map<int, List<Area>> cityAreasTr = {
    /// 1. Bağdat (10 yeni bölge eklendi)
    1: [
      Area(id: 101, name: "Rasafa", cityId: 1),
      Area(id: 102, name: "Karrada", cityId: 1),
      Area(id: 103, name: "Mansur", cityId: 1),
      Area(id: 104, name: "A'zamiyah", cityId: 1),
      Area(id: 105, name: "Kadhimiyah", cityId: 1),
      Area(id: 106, name: "Birinci Sadr", cityId: 1),
      Area(id: 107, name: "Caderiye", cityId: 1),
      Area(id: 108, name: "Bayaa", cityId: 1),
      Area(id: 109, name: "Şaab", cityId: 1),
      Area(id: 110, name: "Yarmuk", cityId: 1),
      Area(id: 111, name: "Veziriyye", cityId: 1),
      Area(id: 112, name: "Zafranıye", cityId: 1),
      Area(id: 113, name: "Dora", cityId: 1),
      Area(id: 114, name: "Ghazaliya", cityId: 1),
      Area(id: 115, name: "Habibiye", cityId: 1),
      Area(id: 116, name: "Nahrawan", cityId: 1),
      Area(id: 117, name: "Reşid", cityId: 1),
      Area(id: 118, name: "Tarmiyah", cityId: 1),
      Area(id: 119, name: "Yedi Abkar", cityId: 1),
      Area(id: 120, name: "Washash", cityId: 1),
    ],

    /// 2. Basra (8 yeni bölge eklendi)
    2: [
      Area(id: 201, name: "Eski Basra", cityId: 2),
      Area(id: 202, name: "Tanuma", cityId: 2),
      Area(id: 203, name: "Aşar", cityId: 2),
      Area(id: 204, name: "Cezayir", cityId: 2),
      Area(id: 205, name: "Kıble", cityId: 2),
      Area(id: 206, name: "Abu Hüsib", cityId: 2),
      Area(id: 207, name: "Haritha", cityId: 2),
      Area(id: 208, name: "Medina", cityId: 2),
      Area(id: 209, name: "Zübeyr", cityId: 2),
      Area(id: 210, name: "Faw", cityId: 2),
      Area(id: 211, name: "Kurnah", cityId: 2),
      Area(id: 212, name: "Şaiba", cityId: 2),
      Area(id: 213, name: "Hura", cityId: 2),
      Area(id: 214, name: "Baradiye", cityId: 2),
      Area(id: 215, name: "Cubayla", cityId: 2),
      Area(id: 216, name: "Adalet", cityId: 2),
    ],

    /// 3. Ninova (7 yeni bölge eklendi)
    3: [
      Area(id: 301, name: "Eski Musul", cityId: 3),
      Area(id: 302, name: "Nur", cityId: 3),
      Area(id: 303, name: "Zehra", cityId: 3),
      Area(id: 304, name: "Tehrir", cityId: 3),
      Area(id: 305, name: "Kadisiyye", cityId: 3),
      Area(id: 306, name: "Mansur", cityId: 3),
      Area(id: 307, name: "Sikkak", cityId: 3),
      Area(id: 308, name: "Birlik", cityId: 3),
      Area(id: 309, name: "Bakr", cityId: 3),
      Area(id: 310, name: "Şifa", cityId: 3),
      Area(id: 311, name: "Adalet", cityId: 3),
      Area(id: 312, name: "Reşid", cityId: 3),
      Area(id: 313, name: "Onur", cityId: 3),
      Area(id: 314, name: "Diriliş", cityId: 3),
    ],

    /// 4. Erbil (6 yeni bölge eklendi)
    4: [
      Area(id: 401, name: "Kamp", cityId: 4),
      Area(id: 402, name: "Arsata", cityId: 4),
      Area(id: 403, name: "Dartu", cityId: 4),
      Area(id: 404, name: "Aynkawa", cityId: 4),
      Area(id: 405, name: "Kürdistan", cityId: 4),
      Area(id: 406, name: "Sitak", cityId: 4),
      Area(id: 407, name: "Şoruş", cityId: 4),
      Area(id: 408, name: "Nurk", cityId: 4),
      Area(id: 409, name: "Kisnazan", cityId: 4),
      Area(id: 410, name: "Behriz", cityId: 4),
      Area(id: 411, name: "Kalet", cityId: 4),
      Area(id: 412, name: "Bastura", cityId: 4),
    ],

    /// 5. Duhok (5 yeni bölge eklendi)
    5: [
      Area(id: 501, name: "Yeni Duhok", cityId: 5),
      Area(id: 502, name: "Mahmudiyye", cityId: 5),
      Area(id: 503, name: "Heftan", cityId: 5),
      Area(id: 504, name: "Misuri", cityId: 5),
      Area(id: 505, name: "Başma", cityId: 5),
      Area(id: 506, name: "Kisnazan", cityId: 5),
      Area(id: 507, name: "Zaviye", cityId: 5),
      Area(id: 508, name: "Şiladeze", cityId: 5),
      Area(id: 509, name: "Dumiz", cityId: 5),
      Area(id: 510, name: "Bamerni", cityId: 5),
      Area(id: 511, name: "Sulaf", cityId: 5),
    ],

    /// 6. Süleymaniye (6 yeni bölge eklendi)
    6: [
      Area(id: 601, name: "Sershem", cityId: 6),
      Area(id: 602, name: "Tani", cityId: 6),
      Area(id: 603, name: "Eskan", cityId: 6),
      Area(id: 604, name: "Briyader", cityId: 6),
      Area(id: 605, name: "Cevarka", cityId: 6),
      Area(id: 606, name: "Mikael", cityId: 6),
      Area(id: 607, name: "Rezkarı", cityId: 6),
      Area(id: 608, name: "Şoruş", cityId: 6),
      Area(id: 609, name: "Baziyan", cityId: 6),
      Area(id: 610, name: "Kadir Kerem", cityId: 6),
      Area(id: 611, name: "Seyyid Sadık", cityId: 6),
      Area(id: 612, name: "Bencüin", cityId: 6),
    ],

    /// 7. Kerkük (5 yeni bölge eklendi)
    7: [
      Area(id: 701, name: "Reşad", cityId: 7),
      Area(id: 702, name: "Zenceili", cityId: 7),
      Area(id: 703, name: "Tupici", cityId: 7),
      Area(id: 704, name: "Nur", cityId: 7),
      Area(id: 705, name: "Selam", cityId: 7),
      Area(id: 706, name: "Musalla", cityId: 7),
      Area(id: 707, name: "Vasiti", cityId: 7),
      Area(id: 708, name: "Yeşil", cityId: 7),
      Area(id: 709, name: "Abbas", cityId: 7),
      Area(id: 710, name: "Özgürlük", cityId: 7),
      Area(id: 711, name: "Çiçekler", cityId: 7),
    ],

    /// 8. Necef (5 yeni bölge eklendi)
    8: [
      Area(id: 801, name: "Enbarili", cityId: 8),
      Area(id: 802, name: "Yeşil", cityId: 8),
      Area(id: 803, name: "Hanane", cityId: 8),
      Area(id: 804, name: "Meşrak", cityId: 8),
      Area(id: 805, name: "Abbasiyye", cityId: 8),
      Area(id: 806, name: "Ghuri", cityId: 8),
      Area(id: 807, name: "Zehra", cityId: 8),
      Area(id: 808, name: "Nehda", cityId: 8),
      Area(id: 809, name: "Onur", cityId: 8),
      Area(id: 810, name: "Selam", cityId: 8),
      Area(id: 811, name: "Fiyaha", cityId: 8),
    ],

    /// 9. Kerbela (5 yeni bölge eklendi)
    9: [
      Area(id: 901, name: "Kamp", cityId: 9),
      Area(id: 902, name: "Bağdat Kapısı", cityId: 9),
      Area(id: 903, name: "Abbasiyye", cityId: 9),
      Area(id: 904, name: "Hüseyniye", cityId: 9),
      Area(id: 905, name: "Hür", cityId: 9),
      Area(id: 906, name: "Hayırlar", cityId: 9),
      Area(id: 907, name: "Zehra", cityId: 9),
      Area(id: 908, name: "Nehda", cityId: 9),
      Area(id: 909, name: "Onur", cityId: 9),
      Area(id: 910, name: "Selam", cityId: 9),
      Area(id: 911, name: "Fiyaha", cityId: 9),
    ],

    /// 10. Dhi Qar (5 yeni bölge eklendi)
    10: [
      Area(id: 1001, name: "Hekimiyye", cityId: 10),
      Area(id: 1002, name: "Cumhuriyet", cityId: 10),
      Area(id: 1003, name: "Nehda", cityId: 10),
      Area(id: 1004, name: "Ada", cityId: 10),
      Area(id: 1005, name: "Adalet", cityId: 10),
      Area(id: 1006, name: "Fiyaha", cityId: 10),
      Area(id: 1007, name: "Zehra", cityId: 10),
      Area(id: 1008, name: "Onur", cityId: 10),
      Area(id: 1009, name: "Selam", cityId: 10),
      Area(id: 1010, name: "Abbas", cityId: 10),
      Area(id: 1011, name: "Reşid", cityId: 10),
    ],

    /// 11. Enbar (5 yeni bölge eklendi)
    11: [
      Area(id: 1101, name: "Tamim", cityId: 11),
      Area(id: 1102, name: "Halidiyye", cityId: 11),
      Area(id: 1103, name: "Nida", cityId: 11),
      Area(id: 1104, name: "Rehale", cityId: 11),
      Area(id: 1105, name: "Karrable", cityId: 11),
      Area(id: 1106, name: "Abidi", cityId: 11),
      Area(id: 1107, name: "Yeni Ramadi", cityId: 11),
      Area(id: 1108, name: "Yeni Falluca", cityId: 11),
      Area(id: 1109, name: "Habaniya", cityId: 11),
      Area(id: 1110, name: "Ratba", cityId: 11),
      Area(id: 1111, name: "Kaim", cityId: 11),
    ],

    /// 12. Diyala (5 yeni bölge eklendi)
    12: [
      Area(id: 1201, name: "Mekdadiye", cityId: 12),
      Area(id: 1202, name: "Halis", cityId: 12),
      Area(id: 1203, name: "Beldruz", cityId: 12),
      Area(id: 1204, name: "Mansuriye", cityId: 12),
      Area(id: 1205, name: "Yeşil", cityId: 12),
      Area(id: 1206, name: "Talibiyye", cityId: 12),
      Area(id: 1207, name: "Zehra", cityId: 12),
      Area(id: 1208, name: "Nehda", cityId: 12),
      Area(id: 1209, name: "Onur", cityId: 12),
      Area(id: 1210, name: "Selam", cityId: 12),
      Area(id: 1211, name: "Fiyaha", cityId: 12),
    ],

    /// 13. Maysan (5 yeni bölge eklendi)
    13: [
      Area(id: 1301, name: "Yeni İmara", cityId: 13),
      Area(id: 1302, name: "Öncüler", cityId: 13),
      Area(id: 1303, name: "Onur", cityId: 13),
      Area(id: 1304, name: "Nehda", cityId: 13),
      Area(id: 1305, name: "Savunma", cityId: 13),
      Area(id: 1306, name: "Selam", cityId: 13),
      Area(id: 1307, name: "Zehra", cityId: 13),
      Area(id: 1308, name: "Abbas", cityId: 13),
      Area(id: 1309, name: "Reşid", cityId: 13),
      Area(id: 1310, name: "Fiyaha", cityId: 13),
      Area(id: 1311, name: "Kerh", cityId: 13),
    ],

    /// 14. Babil (5 yeni bölge eklendi)
    14: [
      Area(id: 1401, name: "Yeni Hilla", cityId: 14),
      Area(id: 1402, name: "Aile", cityId: 14),
      Area(id: 1403, name: "Abbas", cityId: 14),
      Area(id: 1404, name: "Nehda", cityId: 14),
      Area(id: 1405, name: "Zuarah", cityId: 14),
      Area(id: 1406, name: "Kerh", cityId: 14),
      Area(id: 1407, name: "Zehra", cityId: 14),
      Area(id: 1408, name: "Onur", cityId: 14),
      Area(id: 1409, name: "Selam", cityId: 14),
      Area(id: 1410, name: "Fiyaha", cityId: 14),
      Area(id: 1411, name: "Reşid", cityId: 14),
    ],

    /// 15. Kadisiyye (5 yeni bölge eklendi)
    15: [
      Area(id: 1501, name: "Şenafiye", cityId: 15),
      Area(id: 1502, name: "Yeni Diwaniye", cityId: 15),
      Area(id: 1503, name: "Reşid", cityId: 15),
      Area(id: 1504, name: "Karrada", cityId: 15),
      Area(id: 1505, name: "Zehra", cityId: 15),
      Area(id: 1506, name: "Özgürlük", cityId: 15),
      Area(id: 1507, name: "Nehda", cityId: 15),
      Area(id: 1508, name: "Onur", cityId: 15),
      Area(id: 1509, name: "Selam", cityId: 15),
      Area(id: 1510, name: "Fiyaha", cityId: 15),
      Area(id: 1511, name: "Abbas", cityId: 15),
    ],

    /// 16. Salahaddin (5 yeni bölge eklendi)
    16: [
      Area(id: 1601, name: "Dor", cityId: 16),
      Area(id: 1602, name: "Şerqat", cityId: 16),
      Area(id: 1603, name: "Yeni Tekrit", cityId: 16),
      Area(id: 1604, name: "Doluya", cityId: 16),
      Area(id: 1605, name: "Samir", cityId: 16),
      Area(id: 1606, name: "Yarabiyah", cityId: 16),
      Area(id: 1607, name: "Zehra", cityId: 16),
      Area(id: 1608, name: "Nehda", cityId: 16),
      Area(id: 1609, name: "Onur", cityId: 16),
      Area(id: 1610, name: "Selam", cityId: 16),
      Area(id: 1611, name: "Fiyaha", cityId: 16),
    ],

    /// 17. Muthanna (5 yeni bölge eklendi)
    17: [
      Area(id: 1701, name: "Rumi", cityId: 17),
      Area(id: 1702, name: "Hidir", cityId: 17),
      Area(id: 1703, name: "Nehda", cityId: 17),
      Area(id: 1704, name: "Üniversite", cityId: 17),
      Area(id: 1705, name: "Selam", cityId: 17),
      Area(id: 1706, name: "Fiyaha", cityId: 17),
      Area(id: 1707, name: "Zehra", cityId: 17),
      Area(id: 1708, name: "Onur", cityId: 17),
      Area(id: 1709, name: "Reşid", cityId: 17),
      Area(id: 1710, name: "Abbas", cityId: 17),
      Area(id: 1711, name: "Savunma", cityId: 17),
    ],

    /// 18. Wasit (5 yeni bölge eklendi)
    18: [
      Area(id: 1801, name: "Sanayi", cityId: 18),
      Area(id: 1802, name: "Kerh", cityId: 18),
      Area(id: 1803, name: "Mesaj", cityId: 18),
      Area(id: 1804, name: "Zehra", cityId: 18),
      Area(id: 1805, name: "Nehda", cityId: 18),
      Area(id: 1806, name: "Abbas", cityId: 18),
      Area(id: 1807, name: "Onur", cityId: 18),
      Area(id: 1808, name: "Selam", cityId: 18),
      Area(id: 1809, name: "Fiyaha", cityId: 18),
      Area(id: 1810, name: "Reşid", cityId: 18),
      Area(id: 1811, name: "Savunma", cityId: 18),
    ],
  };

  List<Area> getAreasByCityIdTr(int cityId) {
    return cityAreasTr[cityId] ?? [];
  }

  final Map<int, List<Area>> cityAreasKr = {
    /// 1. Bexda (10 herêmê nû zêde kirin)
    1: [
      Area(id: 101, name: "Rasafa", cityId: 1),
      Area(id: 102, name: "Karrada", cityId: 1),
      Area(id: 103, name: "Mansur", cityId: 1),
      Area(id: 104, name: "A'zamiyah", cityId: 1),
      Area(id: 105, name: "Kadhimiyah", cityId: 1),
      Area(id: 106, name: "Sadrê Yekem", cityId: 1),
      Area(id: 107, name: "Caderî", cityId: 1),
      Area(id: 108, name: "Bayaa", cityId: 1),
      Area(id: 109, name: "Şaab", cityId: 1),
      Area(id: 110, name: "Yarmuk", cityId: 1),
      Area(id: 111, name: "Veziriyye", cityId: 1),
      Area(id: 112, name: "Zafranî", cityId: 1),
      Area(id: 113, name: "Dora", cityId: 1),
      Area(id: 114, name: "Ghazaliya", cityId: 1),
      Area(id: 115, name: "Habibiye", cityId: 1),
      Area(id: 116, name: "Nahrawan", cityId: 1),
      Area(id: 117, name: "Reşid", cityId: 1),
      Area(id: 118, name: "Tarmiyah", cityId: 1),
      Area(id: 119, name: "Heft Abkar", cityId: 1),
      Area(id: 120, name: "Washash", cityId: 1),
    ],

    /// 2. Basra (8 herêmê nû zêde kirin)
    2: [
      Area(id: 201, name: "Basra Kevn", cityId: 2),
      Area(id: 202, name: "Tanûma", cityId: 2),
      Area(id: 203, name: "Aşar", cityId: 2),
      Area(id: 204, name: "Cezayir", cityId: 2),
      Area(id: 205, name: "Qible", cityId: 2),
      Area(id: 206, name: "Ebu Xusib", cityId: 2),
      Area(id: 207, name: "Haritha", cityId: 2),
      Area(id: 208, name: "Medina", cityId: 2),
      Area(id: 209, name: "Zübeyr", cityId: 2),
      Area(id: 210, name: "Faw", cityId: 2),
      Area(id: 211, name: "Kurnah", cityId: 2),
      Area(id: 212, name: "Şaiba", cityId: 2),
      Area(id: 213, name: "Hura", cityId: 2),
      Area(id: 214, name: "Baradîye", cityId: 2),
      Area(id: 215, name: "Cûbayla", cityId: 2),
      Area(id: 216, name: "Adalet", cityId: 2),
    ],

    /// 3. Ninova (7 herêmê nû zêde kirin)
    3: [
      Area(id: 301, name: "Mûsil Kevn", cityId: 3),
      Area(id: 302, name: "Nur", cityId: 3),
      Area(id: 303, name: "Zehra", cityId: 3),
      Area(id: 304, name: "Tehrîr", cityId: 3),
      Area(id: 305, name: "Kadisîye", cityId: 3),
      Area(id: 306, name: "Mansur", cityId: 3),
      Area(id: 307, name: "Sikkak", cityId: 3),
      Area(id: 308, name: "Yekîtî", cityId: 3),
      Area(id: 309, name: "Bakr", cityId: 3),
      Area(id: 310, name: "Şifa", cityId: 3),
      Area(id: 311, name: "Adalet", cityId: 3),
      Area(id: 312, name: "Reşid", cityId: 3),
      Area(id: 313, name: "Şeref", cityId: 3),
      Area(id: 314, name: "Jiyana Nû", cityId: 3),
    ],

    /// 4. Erbil (6 herêmê nû zêde kirin)
    4: [
      Area(id: 401, name: "Kamp", cityId: 4),
      Area(id: 402, name: "Arsata", cityId: 4),
      Area(id: 403, name: "Dartu", cityId: 4),
      Area(id: 404, name: "Aynkawa", cityId: 4),
      Area(id: 405, name: "Kurdistan", cityId: 4),
      Area(id: 406, name: "Sitak", cityId: 4),
      Area(id: 407, name: "Şoruş", cityId: 4),
      Area(id: 408, name: "Nûrk", cityId: 4),
      Area(id: 409, name: "Kisnazan", cityId: 4),
      Area(id: 410, name: "Behriz", cityId: 4),
      Area(id: 411, name: "Kalet", cityId: 4),
      Area(id: 412, name: "Bastura", cityId: 4),
    ],

    /// 5. Duhok (5 herêmê nû zêde kirin)
    5: [
      Area(id: 501, name: "Duhokê Nû", cityId: 5),
      Area(id: 502, name: "Mahmudiyê", cityId: 5),
      Area(id: 503, name: "Heftan", cityId: 5),
      Area(id: 504, name: "Misuri", cityId: 5),
      Area(id: 505, name: "Başma", cityId: 5),
      Area(id: 506, name: "Kisnazan", cityId: 5),
      Area(id: 507, name: "Zavîte", cityId: 5),
      Area(id: 508, name: "Şiladeze", cityId: 5),
      Area(id: 509, name: "Dumiz", cityId: 5),
      Area(id: 510, name: "Bamerni", cityId: 5),
      Area(id: 511, name: "Sulaf", cityId: 5),
    ],

    /// 6. Süleymaniye (6 herêmê nû zêde kirin)
    6: [
      Area(id: 601, name: "Sershem", cityId: 6),
      Area(id: 602, name: "Tani", cityId: 6),
      Area(id: 603, name: "Eskan", cityId: 6),
      Area(id: 604, name: "Briyader", cityId: 6),
      Area(id: 605, name: "Cevarka", cityId: 6),
      Area(id: 606, name: "Mikael", cityId: 6),
      Area(id: 607, name: "Rezkarî", cityId: 6),
      Area(id: 608, name: "Şoruş", cityId: 6),
      Area(id: 609, name: "Baziyan", cityId: 6),
      Area(id: 610, name: "Kadir Kerem", cityId: 6),
      Area(id: 611, name: "Seyyid Sadik", cityId: 6),
      Area(id: 612, name: "Bencüin", cityId: 6),
    ],

    /// 7. Kerkuk (5 herêmê nû zêde kirin)
    7: [
      Area(id: 701, name: "Reşad", cityId: 7),
      Area(id: 702, name: "Zenceilî", cityId: 7),
      Area(id: 703, name: "Tupîcî", cityId: 7),
      Area(id: 704, name: "Nur", cityId: 7),
      Area(id: 705, name: "Silav", cityId: 7),
      Area(id: 706, name: "Musalla", cityId: 7),
      Area(id: 707, name: "Vasîtî", cityId: 7),
      Area(id: 708, name: "Kesk", cityId: 7),
      Area(id: 709, name: "Abbas", cityId: 7),
      Area(id: 710, name: "Azadî", cityId: 7),
      Area(id: 711, name: "Gulan", cityId: 7),
    ],

    /// 8. Necef (5 herêmê nû zêde kirin)
    8: [
      Area(id: 801, name: "Enbarî", cityId: 8),
      Area(id: 802, name: "Kesk", cityId: 8),
      Area(id: 803, name: "Hanane", cityId: 8),
      Area(id: 804, name: "Meşrak", cityId: 8),
      Area(id: 805, name: "Abbasiyê", cityId: 8),
      Area(id: 806, name: "Ghuri", cityId: 8),
      Area(id: 807, name: "Zehra", cityId: 8),
      Area(id: 808, name: "Nehda", cityId: 8),
      Area(id: 809, name: "Şeref", cityId: 8),
      Area(id: 810, name: "Silav", cityId: 8),
      Area(id: 811, name: "Fiyaha", cityId: 8),
    ],

    /// 9. Karbala (5 herêmê nû zêde kirin)
    9: [
      Area(id: 901, name: "Kampa", cityId: 9),
      Area(id: 902, name: "Deriyê Baghdad", cityId: 9),
      Area(id: 903, name: "Abbasiyê", cityId: 9),
      Area(id: 904, name: "Hüseynîye", cityId: 9),
      Area(id: 905, name: "Azad", cityId: 9),
      Area(id: 906, name: "Xeyrî", cityId: 9),
      Area(id: 907, name: "Zehra", cityId: 9),
      Area(id: 908, name: "Nehda", cityId: 9),
      Area(id: 909, name: "Şeref", cityId: 9),
      Area(id: 910, name: "Silav", cityId: 9),
      Area(id: 911, name: "Fiyaha", cityId: 9),
    ],

    /// 10. Dhi Qar (5 herêmê nû zêde kirin)
    10: [
      Area(id: 1001, name: "Hekimiyê", cityId: 10),
      Area(id: 1002, name: "Cumhuriyet", cityId: 10),
      Area(id: 1003, name: "Nehda", cityId: 10),
      Area(id: 1004, name: "Ada", cityId: 10),
      Area(id: 1005, name: "Adalet", cityId: 10),
      Area(id: 1006, name: "Fiyaha", cityId: 10),
      Area(id: 1007, name: "Zehra", cityId: 10),
      Area(id: 1008, name: "Şeref", cityId: 10),
      Area(id: 1009, name: "Silav", cityId: 10),
      Area(id: 1010, name: "Abbas", cityId: 10),
      Area(id: 1011, name: "Reşid", cityId: 10),
    ],

    /// 11. Anbar (5 herêmê nû zêde kirin)
    11: [
      Area(id: 1101, name: "Tamim", cityId: 11),
      Area(id: 1102, name: "Xalidiyê", cityId: 11),
      Area(id: 1103, name: "Nida", cityId: 11),
      Area(id: 1104, name: "Rehale", cityId: 11),
      Area(id: 1105, name: "Karrable", cityId: 11),
      Area(id: 1106, name: "Abidi", cityId: 11),
      Area(id: 1107, name: "Ramadîya Nû", cityId: 11),
      Area(id: 1108, name: "Fallûcaya Nû", cityId: 11),
      Area(id: 1109, name: "Habaniya", cityId: 11),
      Area(id: 1110, name: "Ratba", cityId: 11),
      Area(id: 1111, name: "Kaim", cityId: 11),
    ],

    /// 12. Diyala (5 herêmê nû zêde kirin)
    12: [
      Area(id: 1201, name: "Mekdadîye", cityId: 12),
      Area(id: 1202, name: "Xalîs", cityId: 12),
      Area(id: 1203, name: "Beldruz", cityId: 12),
      Area(id: 1204, name: "Mansurîye", cityId: 12),
      Area(id: 1205, name: "Kesk", cityId: 12),
      Area(id: 1206, name: "Talibiyê", cityId: 12),
      Area(id: 1207, name: "Zehra", cityId: 12),
      Area(id: 1208, name: "Nehda", cityId: 12),
      Area(id: 1209, name: "Şeref", cityId: 12),
      Area(id: 1210, name: "Silav", cityId: 12),
      Area(id: 1211, name: "Fiyaha", cityId: 12),
    ],

    /// 13. Maysan (5 herêmê nû zêde kirin)
    13: [
      Area(id: 1301, name: "Îmaraya Nû", cityId: 13),
      Area(id: 1302, name: "Pêşeng", cityId: 13),
      Area(id: 1303, name: "Şeref", cityId: 13),
      Area(id: 1304, name: "Nehda", cityId: 13),
      Area(id: 1305, name: "Parastin", cityId: 13),
      Area(id: 1306, name: "Silav", cityId: 13),
      Area(id: 1307, name: "Zehra", cityId: 13),
      Area(id: 1308, name: "Abbas", cityId: 13),
      Area(id: 1309, name: "Reşid", cityId: 13),
      Area(id: 1310, name: "Fiyaha", cityId: 13),
      Area(id: 1311, name: "Kerh", cityId: 13),
    ],

    /// 14. Babil (5 herêmê nû zêde kirin)
    14: [
      Area(id: 1401, name: "Hilla Nû", cityId: 14),
      Area(id: 1402, name: "Malbat", cityId: 14),
      Area(id: 1403, name: "Abbas", cityId: 14),
      Area(id: 1404, name: "Nehda", cityId: 14),
      Area(id: 1405, name: "Zuarah", cityId: 14),
      Area(id: 1406, name: "Kerh", cityId: 14),
      Area(id: 1407, name: "Zehra", cityId: 14),
      Area(id: 1408, name: "Şeref", cityId: 14),
      Area(id: 1409, name: "Silav", cityId: 14),
      Area(id: 1410, name: "Fiyaha", cityId: 14),
      Area(id: 1411, name: "Reşid", cityId: 14),
    ],

    /// 15. Qadisiyah (5 herêmê nû zêde kirin)
    15: [
      Area(id: 1501, name: "Şenafîye", cityId: 15),
      Area(id: 1502, name: "Diwanîya Nû", cityId: 15),
      Area(id: 1503, name: "Reşid", cityId: 15),
      Area(id: 1504, name: "Karrada", cityId: 15),
      Area(id: 1505, name: "Zehra", cityId: 15),
      Area(id: 1506, name: "Azadî", cityId: 15),
      Area(id: 1507, name: "Nehda", cityId: 15),
      Area(id: 1508, name: "Şeref", cityId: 15),
      Area(id: 1509, name: "Silav", cityId: 15),
      Area(id: 1510, name: "Fiyaha", cityId: 15),
      Area(id: 1511, name: "Abbas", cityId: 15),
    ],

    /// 16. Salahaddin (5 herêmê nû zêde kirin)
    16: [
      Area(id: 1601, name: "Dor", cityId: 16),
      Area(id: 1602, name: "Şerqat", cityId: 16),
      Area(id: 1603, name: "Tekrît Nû", cityId: 16),
      Area(id: 1604, name: "Doluya", cityId: 16),
      Area(id: 1605, name: "Samir", cityId: 16),
      Area(id: 1606, name: "Yarabiyah", cityId: 16),
      Area(id: 1607, name: "Zehra", cityId: 16),
      Area(id: 1608, name: "Nehda", cityId: 16),
      Area(id: 1609, name: "Şeref", cityId: 16),
      Area(id: 1610, name: "Silav", cityId: 16),
      Area(id: 1611, name: "Fiyaha", cityId: 16),
    ],

    /// 17. Muthanna (5 herêmê nû zêde kirin)
    17: [
      Area(id: 1701, name: "Rumi", cityId: 17),
      Area(id: 1702, name: "Xidir", cityId: 17),
      Area(id: 1703, name: "Nehda", cityId: 17),
      Area(id: 1704, name: "Zanîngeh", cityId: 17),
      Area(id: 1705, name: "Silav", cityId: 17),
      Area(id: 1706, name: "Fiyaha", cityId: 17),
      Area(id: 1707, name: "Zehra", cityId: 17),
      Area(id: 1708, name: "Şeref", cityId: 17),
      Area(id: 1709, name: "Reşid", cityId: 17),
      Area(id: 1710, name: "Abbas", cityId: 17),
      Area(id: 1711, name: "Parastin", cityId: 17),
    ],

    /// 18. Wasit (5 herêmê nû zêde kirin)
    18: [
      Area(id: 1801, name: "Sana'î", cityId: 18),
      Area(id: 1802, name: "Kerh", cityId: 18),
      Area(id: 1803, name: "Mesaj", cityId: 18),
      Area(id: 1804, name: "Zehra", cityId: 18),
      Area(id: 1805, name: "Nehda", cityId: 18),
      Area(id: 1806, name: "Abbas", cityId: 18),
      Area(id: 1807, name: "Şeref", cityId: 18),
      Area(id: 1808, name: "Silav", cityId: 18),
      Area(id: 1809, name: "Fiyaha", cityId: 18),
      Area(id: 1810, name: "Reşid", cityId: 18),
      Area(id: 1811, name: "Parastin", cityId: 18),
    ],
  };
  List<Area> getAreasByCityIdKr(int cityId) {
    return cityAreasKr[cityId] ?? [];
  }

/////////////////////////////////////////////...منـــاااااااااااطق تركيا............................/////////
  final Map<int, List<Area>> cityAreasTrAr = {
    /// 19 - Adana (أضنة)
    19: [
      Area(id: 1901, name: "Seyhan - سيهان", cityId: 19),
      Area(id: 1902, name: "Yüreğir - يورغير", cityId: 19),
      Area(id: 1903, name: "Çukurova - تشوكوروفا", cityId: 19),
      Area(id: 1904, name: "Karaisalı - كارايسالي", cityId: 19),
      Area(id: 1905, name: "Aladağ - ألاداغ", cityId: 19),
      Area(id: 1906, name: "Feke - فكّة", cityId: 19),
      Area(id: 1907, name: "İmamoğlu - إمام أوغلو", cityId: 19),
      Area(id: 1908, name: "Karataş - كاراطاش", cityId: 19),
      Area(id: 1909, name: "Kozan - كوزان", cityId: 19),
      Area(id: 1910, name: "Pozantı - بوزانتي", cityId: 19),
      Area(id: 1911, name: "Saimbeyli - صائم بيلي", cityId: 19),
      Area(id: 1912, name: "Tufanbeyli - طوفان بيلي", cityId: 19),
    ],

    /// 20 - Adıyaman (أديامان)
    20: [
      Area(id: 2001, name: "Merkez - مركز", cityId: 20),
      Area(id: 2002, name: "Besni - بيسني", cityId: 20),
      Area(id: 2003, name: "Çelikhan - تشيليخان", cityId: 20),
      Area(id: 2004, name: "Gerger - غيرغير", cityId: 20),
      Area(id: 2005, name: "Gölbaşı - غولباشي", cityId: 20),
      Area(id: 2006, name: "Kahta - كاختا", cityId: 20),
      Area(id: 2007, name: "Samsat - سامسات", cityId: 20),
      Area(id: 2008, name: "Sincik - سينجيك", cityId: 20),
      Area(id: 2009, name: "Tut - توت", cityId: 20),
    ],

    /// 21 - Afşin (أفشين)
    21: [
      Area(id: 2101, name: "Merkez - مركز", cityId: 21),
      Area(id: 2102, name: "Andırın - أنديرين", cityId: 21),
      Area(id: 2103, name: "Çağlayancerit - تشاغلايانجيريت", cityId: 21),
      Area(id: 2104, name: "Ekinözü - إكينوزو", cityId: 21),
      Area(id: 2105, name: "Elbistan - إلبستان", cityId: 21),
      Area(id: 2106, name: "Göksun - غوكسون", cityId: 21),
      Area(id: 2107, name: "Nurhak - نورهاك", cityId: 21),
      Area(id: 2108, name: "Pazarcık - بازارجيك", cityId: 21),
      Area(id: 2109, name: "Türkoğlu - تورك أوغلو", cityId: 21),
    ],

    /// 22 - Ağrı (أغري)
    22: [
      Area(id: 2201, name: "Merkez - مركز", cityId: 22),
      Area(id: 2202, name: "Diyadin - ديادين", cityId: 22),
      Area(id: 2203, name: "Doğubayazıt - دوغوبايزيت", cityId: 22),
      Area(id: 2204, name: "Eleşkirt - إلشكِرت", cityId: 22),
      Area(id: 2205, name: "Hamur - هامور", cityId: 22),
      Area(id: 2206, name: "Patnos - باتنوس", cityId: 22),
      Area(id: 2207, name: "Taşlıçay - طاشلجاي", cityId: 22),
      Area(id: 2208, name: "Tutak - توتاك", cityId: 22),
    ],

    /// 23 - Amasya (أماسيا)
    23: [
      Area(id: 2301, name: "Merkez - مركز", cityId: 23),
      Area(id: 2302, name: "Göynücek - غوينوجك", cityId: 23),
      Area(id: 2303, name: "Gümüşhacıköy - غوموش حاجي كوي", cityId: 23),
      Area(id: 2304, name: "Hamamözü - هامام أوزو", cityId: 23),
      Area(id: 2305, name: "Merzifon - مرزيفون", cityId: 23),
      Area(id: 2306, name: "Suluova - سولووفا", cityId: 23),
      Area(id: 2307, name: "Taşova - طاشوفا", cityId: 23),
    ],

    /// 24 - Ankara (أنقرة)
    24: [
      Area(id: 2401, name: "Çankaya - جانكايا", cityId: 24),
      Area(id: 2402, name: "Keçiören - كيجيورين", cityId: 24),
      Area(id: 2403, name: "Yenimahalle - يني محلة", cityId: 24),
      Area(id: 2404, name: "Mamak - ماماك", cityId: 24),
      Area(id: 2405, name: "Etimesgut - إيتيميسغوت", cityId: 24),
      Area(id: 2406, name: "Sincan - سينجان", cityId: 24),
      Area(id: 2407, name: "Altındağ - ألتينداغ", cityId: 24),
      Area(id: 2408, name: "Pursaklar - بورسكلار", cityId: 24),
      Area(id: 2409, name: "Gölbaşı - غولباشي", cityId: 24),
      Area(id: 2410, name: "Polatlı - بولاتلي", cityId: 24),
      Area(id: 2411, name: "Çubuk - تشوبوك", cityId: 24),
      Area(id: 2412, name: "Kahramankazan - كهرمان كازان", cityId: 24),
      Area(id: 2413, name: "Beypazarı - بيبازاري", cityId: 24),
      Area(id: 2414, name: "Elmadağ - إلما داغ", cityId: 24),
      Area(id: 2415, name: "Şereflikoçhisar - شرفلي كوجحصار", cityId: 24),
      Area(id: 2416, name: "Akyurt - آكيورت", cityId: 24),
      Area(id: 2417, name: "Haymana - هايمانة", cityId: 24),
      Area(id: 2418, name: "Kalecik - كالاجيك", cityId: 24),
      Area(id: 2419, name: "Kızılcahamam - كيزيلجاهمام", cityId: 24),
      Area(id: 2420, name: "Nallıhan - نالي هان", cityId: 24),
    ],

    /// 25 - Antalya (أنطاليا)
    25: [
      Area(id: 2501, name: "Kepez - كيبيز", cityId: 25),
      Area(id: 2502, name: "Muratpaşa - مراد باشا", cityId: 25),
      Area(id: 2503, name: "Konyaaltı - كونياالتي", cityId: 25),
      Area(id: 2504, name: "Alanya - ألانيا", cityId: 25),
      Area(id: 2505, name: "Manavgat - مانافغات", cityId: 25),
      Area(id: 2506, name: "Serik - سيريك", cityId: 25),
      Area(id: 2507, name: "Kumluca - كوملوجا", cityId: 25),
      Area(id: 2508, name: "Kaş - كاش", cityId: 25),
      Area(id: 2509, name: "Finike - فينيكه", cityId: 25),
      Area(id: 2510, name: "Gazipaşa - غازي باشا", cityId: 25),
      Area(id: 2511, name: "Demre - دمري", cityId: 25),
      Area(id: 2512, name: "İbradı - إبرادي", cityId: 25),
      Area(id: 2513, name: "Korkuteli - كوركوتالي", cityId: 25),
      Area(id: 2514, name: "Akseki - أكسكي", cityId: 25),
      Area(id: 2515, name: "Gündoğmuş - غوندوغموش", cityId: 25),
      Area(id: 2516, name: "Elmalı - إلما لي", cityId: 25),
    ],

    /// 26 - Artvin (أرتفين)
    26: [
      Area(id: 2601, name: "Merkez - مركز", cityId: 26),
      Area(id: 2602, name: "Hopa - هوپا", cityId: 26),
      Area(id: 2603, name: "Ardanuç - اردانوچ", cityId: 26),
      Area(id: 2604, name: "Murgul - مورجول", cityId: 26),
      Area(id: 2605, name: "Şavşat - شافشات", cityId: 26),
      Area(id: 2606, name: "Arhavi - ارهافي", cityId: 26),
      Area(id: 2607, name: "Borçka - بورچكا", cityId: 26),
      Area(id: 2608, name: "Kemalpaşa - كمال باشا", cityId: 26),
    ],

    /// 27 - Aydın (أيضين)
    27: [
      Area(id: 2701, name: "Merkez - مركز", cityId: 27),
      Area(id: 2702, name: "Efeler - افيلر", cityId: 27),
      Area(id: 2703, name: "Kuşadası - كوشاداسي", cityId: 27),
      Area(id: 2704, name: "Didim - ديديم", cityId: 27),
      Area(id: 2705, name: "Söke - سوكي", cityId: 27),
      Area(id: 2706, name: "Buharkent - بوهاركينت", cityId: 27),
      Area(id: 2707, name: "Koçarlı - كوشارلي", cityId: 27),
      Area(id: 2708, name: "Karacasu - كاراجاسو", cityId: 27),
    ],

    /// 28 - Balıkesir (باليكشهر)
    28: [
      Area(id: 2801, name: "Merkez - مركز", cityId: 28),
      Area(id: 2802, name: "Ayvalık - ايڤاليك", cityId: 28),
      Area(id: 2803, name: "Bandırma - بنديرما", cityId: 28),
      Area(id: 2804, name: "Bigadiç - بيغاديتش", cityId: 28),
      Area(id: 2805, name: "Burhaniye - بورهانيا", cityId: 28),
      Area(id: 2806, name: "Gömeç - گومج", cityId: 28),
      Area(id: 2807, name: "Manyas - مانياز", cityId: 28),
      Area(id: 2808, name: "Sındırgı - سندرجي", cityId: 28),
      Area(id: 2809, name: "Erdek - اردك", cityId: 28),
    ],

    /// 29 - Bandırma (بانديرما)
    29: [
      Area(id: 2901, name: "Merkez - مركز", cityId: 29),
      Area(id: 2902, name: "Altıyol - ألتيل", cityId: 29),
      Area(id: 2903, name: "Yeşilova - يشيلوفا", cityId: 29),
    ],

    /// 30 - Bartın (بارطين)
    30: [
      Area(id: 3001, name: "Merkez - مركز", cityId: 30),
      Area(id: 3002, name: "Kurucaşile - كوروجاشيلي", cityId: 30),
      Area(id: 3003, name: "Ulus - أولوس", cityId: 30),
      Area(id: 3004, name: "Amasra - أماسرا", cityId: 30),
    ],

    /// 31 - Batman (باتمان)
    31: [
      Area(id: 3101, name: "Merkez - مركز", cityId: 31),
      Area(id: 3102, name: "Beşiri - بشيري", cityId: 31),
      Area(id: 3103, name: "Gercüş - جرکوش", cityId: 31),
      Area(id: 3104, name: "Hasankeyf - حسنكيف", cityId: 31),
      Area(id: 3105, name: "Kozluk - كوزلوك", cityId: 31),
      Area(id: 3106, name: "Sason - ساسون", cityId: 31),
    ],

    /// 32 - Bilecik (بيليجيك)
    32: [
      Area(id: 3201, name: "Merkez - مركز", cityId: 32),
      Area(id: 3202, name: "Bozüyük - بوزيوك", cityId: 32),
      Area(id: 3203, name: "Gölpazarı - جولپازاري", cityId: 32),
      Area(id: 3204, name: "Osmaneli - عثمانيلي", cityId: 32),
      Area(id: 3205, name: "Pazaryeri - بازاريري", cityId: 32),
      Area(id: 3206, name: "Söğüt - سوغوت", cityId: 32),
      Area(id: 3207, name: "Yenipazar - يني بازار", cityId: 32),
    ],

    /// 33 - Bolu (بولو)
    33: [
      Area(id: 3301, name: "Merkez - مركز", cityId: 33),
      Area(id: 3302, name: "Gerede - جيردي", cityId: 33),
      Area(id: 3303, name: "Göynük - غوينوك", cityId: 33),
      Area(id: 3304, name: "Kıbrıscık - كيبريشيك", cityId: 33),
      Area(id: 3305, name: "Mengen - منجن", cityId: 33),
      Area(id: 3306, name: "Mudurnu - مودورن", cityId: 33),
      Area(id: 3307, name: "Seben - سابن", cityId: 33),
    ],

    /// 34 - Bursa (بورصة)
    34: [
      Area(id: 3401, name: "Merkez - مركز", cityId: 34),
      Area(id: 3402, name: "Osmangazi - عثمان غازي", cityId: 34),
      Area(id: 3403, name: "Yıldırım - يلدرم", cityId: 34),
      Area(id: 3404, name: "Nilüfer - نيلوفر", cityId: 34),
      Area(id: 3405, name: "Gemlik - جيمليك", cityId: 34),
      Area(id: 3406, name: "İnegöl - اينيقول", cityId: 34),
      Area(id: 3407, name: "Büyükorhan - بييوكورهان", cityId: 34),
      Area(id: 3408, name: "Orhangazi - اورهان غازي", cityId: 34),
    ],

    /// 35 - Çorum (چوروم)
    35: [
      Area(id: 3501, name: "Merkez - مركز", cityId: 35),
      Area(id: 3502, name: "Alaca - ألاجا", cityId: 35),
      Area(id: 3503, name: "Bayat - بيات", cityId: 35),
      Area(id: 3504, name: "İskilip - اسكيليب", cityId: 35),
      Area(id: 3505, name: "Kargı - كارغي", cityId: 35),
      Area(id: 3506, name: "Mecitözü - مجيتوزو", cityId: 35),
      Area(id: 3507, name: "Ortaköy - اورتاكوي", cityId: 35),
      Area(id: 3508, name: "Oğuzlar - اوغوزلار", cityId: 35),
    ],

    /// 36 - Denizli (دنيزلي)
    36: [
      Area(id: 3601, name: "Merkez - مركز", cityId: 36),
      Area(id: 3602, name: "Acıpayam - عجيبايام", cityId: 36),
      Area(id: 3603, name: "Babadağ - باباداغ", cityId: 36),
      Area(id: 3604, name: "Baklan - باكلان", cityId: 36),
      Area(id: 3605, name: "Bekilli - بيكيلي", cityId: 36),
      Area(id: 3606, name: "Beyağaç - بياغاج", cityId: 36),
      Area(id: 3607, name: "Bozkurt - بوزكورت", cityId: 36),
      Area(id: 3608, name: "Buldan - بولدان", cityId: 36),
      Area(id: 3609, name: "Çal - تشال", cityId: 36),
      Area(id: 3610, name: "Çameli - تشاميلي", cityId: 36),
      Area(id: 3611, name: "Çardak - تشارداق", cityId: 36),
      Area(id: 3612, name: "Çivril - تشيفريل", cityId: 36),
      Area(id: 3613, name: "Güney - جوناي", cityId: 36),
      Area(id: 3614, name: "Honaz - هوناز", cityId: 36),
      Area(id: 3615, name: "Kale - كاله", cityId: 36),
      Area(id: 3616, name: "Sarayköy - ساراي كوي", cityId: 36),
      Area(id: 3617, name: "Serinhisar - سرين هيصار", cityId: 36),
    ],

    /// 37 - Diyarbakır (ديار بكر)
    37: [
      Area(id: 3701, name: "Adalar - جزر الأميرات", cityId: 37),
  Area(id: 3702, name: "Arnavutköy - أرناؤوط كوي", cityId: 37),
  Area(id: 3703, name: "Ataşehir - أتاشهير", cityId: 37),
  Area(id: 3704, name: "Avcılar - أفجلار", cityId: 37),
  Area(id: 3705, name: "Bağcılar - باغجلار", cityId: 37),
  Area(id: 3706, name: "Bahçelievler - بهجةليفلر", cityId: 37),
  Area(id: 3707, name: "Bakırköy - بكركوي", cityId: 37),
  Area(id: 3708, name: "Başakşehir - باشاك شهير", cityId: 37),
  Area(id: 3709, name: "Bayrampaşa - بيرم باشا", cityId: 37),
  Area(id: 3710, name: "Beşiktaş - بشكتاش", cityId: 37),
  Area(id: 3711, name: "Beykoz - بيكوز", cityId: 37),
  Area(id: 3712, name: "Beylikdüzü - بيليك دوزو", cityId: 37),
  Area(id: 3713, name: "Beyoğlu - بي أوغلو", cityId: 37),
  Area(id: 3714, name: "Büyükçekmece - بيوك شكمجة", cityId: 37),
  Area(id: 3715, name: "Çatalca - تشاتالجا", cityId: 37),
  Area(id: 3716, name: "Çekmeköy - تشكمك كوي", cityId: 37),
  Area(id: 3717, name: "Esenler - إسنلر", cityId: 37),
  Area(id: 3718, name: "Esenyurt - إسينيورت", cityId: 37),
  Area(id: 3719, name: "Eyüpsultan - أيوب سلطان", cityId: 37),
  Area(id: 3720, name: "Fatih - الفاتح", cityId: 37),
  Area(id: 3721, name: "Gaziosmanpaşa - غازي عثمان باشا", cityId: 37),
  Area(id: 3722, name: "Güngören - غونغورن", cityId: 37),
  Area(id: 3723, name: "Kadıköy - كاديكوي", cityId: 37),
  Area(id: 3724, name: "Kağıthane - كاغيت خانه", cityId: 37),
  Area(id: 3725, name: "Kartal - كارتال", cityId: 37),
  Area(id: 3726, name: "Küçükçekmece - كوجوك شكمجة", cityId: 37),
  Area(id: 3727, name: "Maltepe - مالتبه", cityId: 37),
  Area(id: 3728, name: "Pendik - بينديك", cityId: 37),
  Area(id: 3729, name: "Sancaktepe - سانجاق تبه", cityId: 37),
  Area(id: 3730, name: "Sarıyer - صاريير", cityId: 37),
  Area(id: 3731, name: "Silivri - سيليفري", cityId: 37),
  Area(id: 3732, name: "Sultanbeyli - سلطان بيلي", cityId: 37),
  Area(id: 3733, name: "Sultangazi - سلطان غازي", cityId: 37),
  Area(id: 3734, name: "Şile - شيله", cityId: 37),
  Area(id: 3735, name: "Şişli - شيشلي", cityId: 37),
  Area(id: 3736, name: "Tuzla - توزلا", cityId: 37),
  Area(id: 3737, name: "Ümraniye - عمرانية", cityId: 37),
  Area(id: 3738, name: "Üsküdar - أسكودار", cityId: 37),
  Area(id: 3739, name: "Zeytinburnu - زيتين بورنو", cityId: 37),
    ],

    /// 38 - İzmir (إزمير)
    38: [
      Area(id: 3801, name: "Merkez - مركز", cityId: 38),
      Area(id: 3802, name: "Karşıyaka - كارشييكا", cityId: 38),
      Area(id: 3803, name: "Konak - كوناق", cityId: 38),
      Area(id: 3804, name: "Bornova - بورنوفا", cityId: 38),
      Area(id: 3805, name: "Buca - بوجا", cityId: 38),
      Area(id: 3806, name: "Bayraklı - بايراقلي", cityId: 38),
      Area(id: 3807, name: "Gaziemir - غازي إمير", cityId: 38),
      Area(id: 3808, name: "Narlıdere - نارلي ديري", cityId: 38),
      Area(id: 3809, name: "Balçova - بالجوڤا", cityId: 38),
      Area(id: 3810, name: "Menemen - منمن", cityId: 38),
      Area(id: 3811, name: "Ödemiş - أودميش", cityId: 38),
      Area(id: 3812, name: "Seferihisar - سفره حصار", cityId: 38),
      Area(id: 3813, name: "Urla - اورلا", cityId: 38),
      Area(id: 3814, name: "Çeşme - تشيشمي", cityId: 38),
      Area(id: 3815, name: "Foça - فوشا", cityId: 38),
    ],

    /// 39 - Eskişehir (إسكيشهير)
    39: [
      Area(id: 3901, name: "Merkez - مركز", cityId: 39),
      Area(id: 3902, name: "Tepebaşı - تيبي باشي", cityId: 39),
      Area(id: 3903, name: "Odunpazarı - أودون بازاري", cityId: 39),
      Area(id: 3904, name: "Sarıcakaya - ساريجاكايا", cityId: 39),
      Area(id: 3905, name: "Mihalıççık - ميهاليچچيك", cityId: 39),
      Area(id: 3906, name: "Çifteler - تشيفتلر", cityId: 39),
      Area(id: 3907, name: "Mahmudiye - محموديه", cityId: 39),
    ],

    /// 40 - Gaziantep (غازي عنتاب)
    40: [
      Area(id: 4001, name: "Merkez - مركز", cityId: 40),
      Area(id: 4002, name: "Şehitkamil - شهيد كامل", cityId: 40),
      Area(id: 4003, name: "Şahinbey - شاهين بي", cityId: 40),
      Area(id: 4004, name: "Nizip - نزيب", cityId: 40),
      Area(id: 4005, name: "Oğuzeli - اوغوزيلي", cityId: 40),
      Area(id: 4006, name: "Araban - ارابان", cityId: 40),
      Area(id: 4007, name: "İslahiye - اسلاهية", cityId: 40),
      Area(id: 4008, name: "Karkamış - كركمش", cityId: 40),
    ],

    /// 41 - Gümüşhane (جوموشهان)
    41: [
      Area(id: 4101, name: "Merkez - مركز", cityId: 41),
      Area(id: 4102, name: "Kelkit - كلكيت", cityId: 41),
      Area(id: 4103, name: "Köse - كوسي", cityId: 41),
      Area(id: 4104, name: "Kürtün - كورتون", cityId: 41),
      Area(id: 4105, name: "Şiran - شيران", cityId: 41),
      Area(id: 4106, name: "Torul - تورول", cityId: 41),
    ],

    /// 42 - Hatay (هاتاي)
    42: [
      Area(id: 4201, name: "Merkez - مركز", cityId: 42),
      Area(id: 4202, name: "Antakya - انطاكيا", cityId: 42),
      Area(id: 4203, name: "İskenderun - اسكندرون", cityId: 42),
      Area(id: 4204, name: "Kırıkhan - كركهان", cityId: 42),
      Area(id: 4205, name: "Reyhanlı - ريحانلي", cityId: 42),
      Area(id: 4206, name: "Erzin - ارزين", cityId: 42),
      Area(id: 4207, name: "Altınözü - ألتين أوزو", cityId: 42),
      Area(id: 4208, name: "Hassa - هسا", cityId: 42),
      Area(id: 4209, name: "Belen - بيلين", cityId: 42),
      Area(id: 4210, name: "Kumlu - كوملو", cityId: 42),
    ],

    /// 43 - Iğdır (إغدير)
    43: [
      Area(id: 4301, name: "Merkez - مركز", cityId: 43),
      Area(id: 4302, name: "Aralık - آرالك", cityId: 43),
      Area(id: 4303, name: "Karakoyunlu - كارا كويونلو", cityId: 43),
    ],

    /// 44 - Kocaeli (كوكايلي)
    44: [
      Area(id: 4401, name: "Merkez - مركز", cityId: 44),
      Area(id: 4402, name: "İzmit - ايزميت", cityId: 44),
      Area(id: 4403, name: "Gebze - جبزه", cityId: 44),
      Area(id: 4404, name: "Darıca - دارجا", cityId: 44),
      Area(id: 4405, name: "Kartepe - كارتبه", cityId: 44),
      Area(id: 4406, name: "Gölcük - جولجوك", cityId: 44),
      Area(id: 4407, name: "Çayırova - تشايروڤا", cityId: 44),
      Area(id: 4408, name: "Başiskele - باشي سكله", cityId: 44),
    ],

    /// 45 - Konya (قونية)
    45: [
      Area(id: 4501, name: "Merkez - مركز", cityId: 45),
      Area(id: 4502, name: "Karapınar - كارابينار", cityId: 45),
      Area(id: 4503, name: "Akşehir - اك شهير", cityId: 45),
      Area(id: 4504, name: "Beyşehir - بي شهير", cityId: 45),
      Area(id: 4505, name: "Çumra - چومرا", cityId: 45),
      Area(id: 4506, name: "Derinkuyu - درين كيو", cityId: 45),
      Area(id: 4507, name: "Hadim - هاديم", cityId: 45),
      Area(id: 4508, name: "Ilgın - إلجين", cityId: 45),
      Area(id: 4509, name: "Kadınhanı - قادين هاني", cityId: 45),
      Area(id: 4510, name: "Sarayönü - ساراي أونو", cityId: 45),
      Area(id: 4511, name: "Selçuklu - سلجقلو", cityId: 45),
    ],

    /// 46 - Kütahya (كوتاهيا)
    46: [
      Area(id: 4601, name: "Merkez - مركز", cityId: 46),
      Area(id: 4602, name: "Altıntaş - ألتينتاش", cityId: 46),
      Area(id: 4603, name: "Aslanapa - أسلانابا", cityId: 46),
      Area(id: 4604, name: "Çavdarhisar - تشافدار هيسار", cityId: 46),
      Area(id: 4605, name: "Domaniç - دومانيج", cityId: 46),
      Area(id: 4606, name: "Emet - إيمت", cityId: 46),
      Area(id: 4607, name: "Hisarcık - هيسارجيك", cityId: 46),
      Area(id: 4608, name: "Şaphane - شافاني", cityId: 46),
      Area(id: 4609, name: "Simav - سيماف", cityId: 46),
    ],

    /// 47 - Malatya (ملاطيا)
    47: [
      Area(id: 4701, name: "Merkez - مركز", cityId: 47),
      Area(id: 4702, name: "Akçadağ - اكجاداغ", cityId: 47),
      Area(id: 4703, name: "Arapgir - أرابغير", cityId: 47),
      Area(id: 4704, name: "Arguvan - أرجوفان", cityId: 47),
      Area(id: 4705, name: "Battalgazi - بتالغازي", cityId: 47),
      Area(id: 4706, name: "Darende - دارنده", cityId: 47),
      Area(id: 4707, name: "Doğanşehir - دوغان شهر", cityId: 47),
      Area(id: 4708, name: "Hekimhan - حكيمهان", cityId: 47),
      Area(id: 4709, name: "Kuluncak - كولونجك", cityId: 47),
      Area(id: 4710, name: "Pütürge - بوتورجي", cityId: 47),
      Area(id: 4711, name: "Yeşilyurt - يشيل يورت", cityId: 47),
    ],

    /// 48 - Manisa (منيسة)
    48: [
      Area(id: 4801, name: "Merkez - مركز", cityId: 48),
      Area(id: 4802, name: "Akhisar - اخيشار", cityId: 48),
      Area(id: 4803, name: "Alaşehir - علاشهير", cityId: 48),
      Area(id: 4804, name: "Demirci - دميرجي", cityId: 48),
      Area(id: 4805, name: "Gördes - غورديش", cityId: 48),
      Area(id: 4806, name: "Kırkağaç - كركاجاج", cityId: 48),
      Area(id: 4807, name: "Köprübaşı - كوبرو باشي", cityId: 48),
      Area(id: 4808, name: "Kula - كولا", cityId: 48),
      Area(id: 4809, name: "Salihli - صالحيلي", cityId: 48),
      Area(id: 4810, name: "Sarıgöl - ساري جول", cityId: 48),
      Area(id: 4811, name: "Saruhanlı - ساروهانلي", cityId: 48),
      Area(id: 4812, name: "Selendi - سليندي", cityId: 48),
    ],

    /// 49 - Mersin (مرسين)
    49: [
      Area(id: 4901, name: "Merkez - مركز", cityId: 49),
      Area(id: 4902, name: "Akdeniz - اك دينيز", cityId: 49),
      Area(id: 4903, name: "Mezitli - ميزتلي", cityId: 49),
      Area(id: 4904, name: "Toroslar - توروسلار", cityId: 49),
      Area(id: 4905, name: "Yenişehir - يني شهير", cityId: 49),
      Area(id: 4906, name: "Anamur - انامور", cityId: 49),
      Area(id: 4907, name: "Erdemli - اردملي", cityId: 49),
      Area(id: 4908, name: "Silifke - سيلفكي", cityId: 49),
      Area(id: 4909, name: "Tarsus - ترسوس", cityId: 49),
      Area(id: 4910, name: "Mut - موت", cityId: 49),
      Area(id: 4911, name: "Çamlıyayla - چاملي يايلا", cityId: 49),
      Area(id: 4912, name: "Gülnar - غول نار", cityId: 49),
    ],

    /// 50 - Muğla (موغلا)
    50: [
      Area(id: 5001, name: "Merkez - مركز", cityId: 50),
      Area(id: 5002, name: "Bodrum - بودروم", cityId: 50),
      Area(id: 5003, name: "Fethiye - فتحية", cityId: 50),
      Area(id: 5004, name: "Marmaris - مارماريس", cityId: 50),
      Area(id: 5005, name: "Dalaman - دالامان", cityId: 50),
      Area(id: 5006, name: "Milas - ميلاس", cityId: 50),
      Area(id: 5007, name: "Ula - أولا", cityId: 50),
      Area(id: 5008, name: "Yatağan - ياتاغان", cityId: 50),
    ],

    /// 51 - Nevşehir (نِوشهر)
    51: [
      Area(id: 5101, name: "Merkez - مركز", cityId: 51),
      Area(id: 5102, name: "Avanos - افانوس", cityId: 51),
      Area(id: 5103, name: "Derinkuyu - درين كيو", cityId: 51),
      Area(id: 5104, name: "Gülşehir - جولشهير", cityId: 51),
      Area(id: 5105, name: "Hacıbektaş - حاجي بك تاش", cityId: 51),
      Area(id: 5106, name: "Kozaklı - كوزاكلي", cityId: 51),
      Area(id: 5107, name: "Ürgüp - اورجوب", cityId: 51),
    ],

    /// 52 - Niğde (نيغده)
    52: [
      Area(id: 5201, name: "Merkez - مركز", cityId: 52),
      Area(id: 5202, name: "Altunhisar - ألتون هيسار", cityId: 52),
      Area(id: 5203, name: "Bor - بور", cityId: 52),
      Area(id: 5204, name: "Çamardı - چاماردي", cityId: 52),
      Area(id: 5205, name: "Çiftlik - چيفتليك", cityId: 52),
      Area(id: 5206, name: "Ulukışla - أولوكيشلا", cityId: 52),
    ],

    /// 53 - Ordu (أردو)
    53: [
      Area(id: 5301, name: "Merkez - مركز", cityId: 53),
      Area(id: 5302, name: "Altınordu - ألتينوردو", cityId: 53),
      Area(id: 5303, name: "Fatsa - فاتسا", cityId: 53),
      Area(id: 5304, name: "Gölköy - جولكوي", cityId: 53),
      Area(id: 5305, name: "Korgan - كورغان", cityId: 53),
      Area(id: 5306, name: "Kumru - كومرو", cityId: 53),
      Area(id: 5307, name: "Ulubey - أولوباي", cityId: 53),
      Area(id: 5308, name: "Ünye - أونيه", cityId: 53),
    ],

    /// 54 - Rize (ريزي)
    54: [
      Area(id: 5401, name: "Merkez - مركز", cityId: 54),
      Area(id: 5402, name: "Ardeşen - أرديشين", cityId: 54),
      Area(id: 5403, name: "Çamlıhemşin - چاملي همشين", cityId: 54),
      Area(id: 5404, name: "Fındıklı - فينديكي", cityId: 54),
      Area(id: 5405, name: "Güneysu - جونيوس", cityId: 54),
      Area(id: 5406, name: "Hemşin - همشين", cityId: 54),
      Area(id: 5407, name: "İkizdere - ايكيزدير", cityId: 54),
      Area(id: 5408, name: "Pazar - بازار", cityId: 54),
    ],

    /// 55 - Sakarya (ساكاريا)
    55: [
      Area(id: 5501, name: "Merkez - مركز", cityId: 55),
      Area(id: 5502, name: "Adapazarı - اداپازاري", cityId: 55),
      Area(id: 5503, name: "Akyazı - اكيازي", cityId: 55),
      Area(id: 5504, name: "Arifiye - اريفية", cityId: 55),
      Area(id: 5505, name: "Erenler - ارينلر", cityId: 55),
      Area(id: 5506, name: "Ferizli - فريزلي", cityId: 55),
      Area(id: 5507, name: "Karasu - كاراسو", cityId: 55),
      Area(id: 5508, name: "Kocaali - كوكا علي", cityId: 55),
      Area(id: 5509, name: "Pamukova - باموكوفا", cityId: 55),
      Area(id: 5510, name: "Söğütlü - سوغوتلو", cityId: 55),
      Area(id: 5511, name: "Taraklı - تاراكلي", cityId: 55),
    ],

    /// 56 - Samsun (سامسون)
    56: [
      Area(id: 5601, name: "Merkez - مركز", cityId: 56),
      Area(id: 5602, name: "Tekkeköy - تيكي كوي", cityId: 56),
      Area(id: 5603, name: "Çarşamba - چارشامبا", cityId: 56),
      Area(id: 5604, name: "Bafra - بافرا", cityId: 56),
      Area(id: 5605, name: "İlkadım - إلكاديم", cityId: 56),
      Area(id: 5606, name: "Atakum - اتاكوم", cityId: 56),
      Area(id: 5607, name: "Canik - جانك", cityId: 56),
      Area(id: 5608, name: "Terme - ترمة", cityId: 56),
      Area(id: 5609, name: "Asarcık - اساركك", cityId: 56),
      Area(id: 5610, name: "Vezirköprü - وزيركوبرو", cityId: 56),
      Area(id: 5611, name: "Salıpazarı - ساليبازاري", cityId: 56),
      Area(id: 5612, name: "Ayvacık - ايواجيك", cityId: 56),
      Area(id: 5613, name: "Yakakent - ياقا كينت", cityId: 56),
    ],

    /// 57 - Sivas (سيفاس)
    57: [
      Area(id: 5701, name: "Merkez - مركز", cityId: 57),
      Area(id: 5702, name: "Altınyayla - ألتين يايلا", cityId: 57),
      Area(id: 5703, name: "Divriği - ديفريغي", cityId: 57),
      Area(id: 5704, name: "Gemerek - جيمريك", cityId: 57),
      Area(id: 5705, name: "Gölova - جول اوفا", cityId: 57),
      Area(id: 5706, name: "Gürün - جورون", cityId: 57),
      Area(id: 5707, name: "Hafik - هافيك", cityId: 57),
      Area(id: 5708, name: "İmranlı - إم رانلي", cityId: 57),
      Area(id: 5709, name: "Kangal - كانجال", cityId: 57),
      Area(id: 5710, name: "Koyulhisar - كويول هيصار", cityId: 57),
      Area(id: 5711, name: "Suşehri - سوشهري", cityId: 57),
      Area(id: 5712, name: "Şarkışla - شاركشلا", cityId: 57),
    ],

    /// 58 - Şırnak (شيرناك)
    58: [
      Area(id: 5801, name: "Merkez - مركز", cityId: 58),
      Area(id: 5802, name: "Beytüşşebap - بيتوش شيباب", cityId: 58),
      Area(id: 5803, name: "Cizre - جيزري", cityId: 58),
      Area(id: 5804, name: "Güçlü - قوتلو", cityId: 58),
      Area(id: 5805, name: "İdil - إيديل", cityId: 58),
      Area(id: 5806, name: "Silopi - سيلوبي", cityId: 58),
      Area(id: 5807, name: "Uludere - أولوديري", cityId: 58),
    ],

    /// 59 - Tekirdağ (تيكرداغ)
    59: [
      Area(id: 5901, name: "Merkez - مركز", cityId: 59),
      Area(id: 5902, name: "Çorlu - تشرلو", cityId: 59),
      Area(id: 5903, name: "Süleymanpaşa - سليمان باشا", cityId: 59),
      Area(id: 5904, name: "Malkara - مالكارا", cityId: 59),
      Area(id: 5905, name: "Muratlı - مراتلي", cityId: 59),
      Area(id: 5906, name: "Şarköy - شاركوي", cityId: 59),
      Area(id: 5907, name: "Ergene - إرغيني", cityId: 59),
      Area(id: 5908, name: "Hayrabolu - حيرابولو", cityId: 59),
    ],

    /// 60 - Tokat (تقاط)
    60: [
      Area(id: 6001, name: "Merkez - مركز", cityId: 60),
      Area(id: 6002, name: "Erbaa - ايربا", cityId: 60),
      Area(id: 6003, name: "Niksar - نيكسار", cityId: 60),
      Area(id: 6004, name: "Pazar - بازار", cityId: 60),
      Area(id: 6005, name: "Reşadiye - رشادية", cityId: 60),
      Area(id: 6006, name: "Sulusaray - سولوساري", cityId: 60),
      Area(id: 6007, name: "Turhal - تورحال", cityId: 60),
      Area(id: 6008, name: "Zile - زيلي", cityId: 60),
      Area(id: 6009, name: "Artova - ارتوفا", cityId: 60),
      Area(id: 6010, name: "Bağlar - باغلار", cityId: 60),
      Area(id: 6011, name: "Yeşilyurt - يشيل يورت", cityId: 60),
    ],

    /// 61 - Trabzon (طرابزون)
    61: [
      Area(id: 6101, name: "Merkez - مركز", cityId: 61),
      Area(id: 6102, name: "Akçaabat - اكجاجابات", cityId: 61),
      Area(id: 6103, name: "Araklı - أراقل", cityId: 61),
      Area(id: 6104, name: "Arsin - أرسين", cityId: 61),
      Area(id: 6105, name: "Beşikdüzü - بشيك دوزو", cityId: 61),
      Area(id: 6106, name: "Çaykara - تشايكارا", cityId: 61),
      Area(id: 6107, name: "Maçka - ماتشا", cityId: 61),
      Area(id: 6108, name: "Of - اوف", cityId: 61),
      Area(id: 6109, name: "Sürmene - سورمين", cityId: 61),
      Area(id: 6110, name: "Tonya - تونيا", cityId: 61),
      Area(id: 6111, name: "Vakfıkebir - وقف كيبير", cityId: 61),
      Area(id: 6112, name: "Yomra - يومرا", cityId: 61),
    ],

    /// 62 - Van (فان)
    62: [
      Area(id: 6201, name: "Merkez - مركز", cityId: 62),
      Area(id: 6202, name: "Bahçesaray - بحتشه سراي", cityId: 62),
      Area(id: 6203, name: "Çaldıran - چالديران", cityId: 62),
      Area(id: 6204, name: "Edremit - إدريمت", cityId: 62),
      Area(id: 6205, name: "Erciş - ارجيش", cityId: 62),
      Area(id: 6206, name: "Gevaş - جفاش", cityId: 62),
      Area(id: 6207, name: "Gürpınar - جوربينار", cityId: 62),
      Area(id: 6208, name: "İpekyolu - ايبكي يولو", cityId: 62),
      Area(id: 6209, name: "Muradiye - موراديه", cityId: 62),
      Area(id: 6210, name: "Özalp - اوزالپ", cityId: 62),
      Area(id: 6211, name: "Saray - ساراي", cityId: 62),
      Area(id: 6212, name: "Tuşba - توشبا", cityId: 62),
    ],

    /// 63 - Yozgat (يوزغات)
    63: [
      Area(id: 6301, name: "Merkez - مركز", cityId: 63),
      Area(id: 6302, name: "Akdağmadeni - اقداغ ماديني", cityId: 63),
      Area(id: 6303, name: "Boğazlıyan - بغا زليان", cityId: 63),
      Area(id: 6304, name: "Çayıralan - چاييرالن", cityId: 63),
      Area(id: 6305, name: "Çekerek - چكرك", cityId: 63),
      Area(id: 6306, name: "Sarıkaya - ساركايا", cityId: 63),
      Area(id: 6307, name: "Sorgun - سورجون", cityId: 63),
      Area(id: 6308, name: "Şefaatli - شفا اتلي", cityId: 63),
      Area(id: 6309, name: "Yerköy - يركوي", cityId: 63),
    ],

    /// 64 - Zonguldak (زونغولداق)
    64: [
      Area(id: 6401, name: "Merkez - مركز", cityId: 64),
      Area(id: 6402, name: "Çaycuma - تشايجومه", cityId: 64),
      Area(id: 6403, name: "Devrek - ديفريك", cityId: 64),
      Area(id: 6404, name: "Ereğli - اريغلي", cityId: 64),
      Area(id: 6405, name: "Gökçebey - غوكجي بي", cityId: 64),
      Area(id: 6406, name: "Alaplı - ألابلي", cityId: 64),
    ],

    /// 65 - Istanbul (إسطنبول)
    65: [
      Area(id: 6501, name: "Adalar - أضادار", cityId: 65),
      Area(id: 6502, name: "Arnavutköy - أرنافوت كوي", cityId: 65),
      Area(id: 6503, name: "Ataşehir - أتاشهير", cityId: 65),
      Area(id: 6504, name: "Avcılar - أفجيلار", cityId: 65),
      Area(id: 6505, name: "Bağcılar - باغجي لار", cityId: 65),
      Area(id: 6506, name: "Bahçelievler - بحشليرفلر", cityId: 65),
      Area(id: 6507, name: "Bakırköy - باكير كوي", cityId: 65),
      Area(id: 6508, name: "Başakşehir - باشاكشير", cityId: 65),
      Area(id: 6509, name: "Bayrampaşa - بايرام باشا", cityId: 65),
      Area(id: 6510, name: "Beşiktaş - بشيكتاش", cityId: 65),
      Area(id: 6511, name: "Beyoğlu - بييوغلو", cityId: 65),
      Area(id: 6512, name: "Beykoz - بيكوز", cityId: 65),
      Area(id: 6513, name: "Beylikdüzü - بيليك دوزو", cityId: 65),
      Area(id: 6514, name: "Büyükçekmece - بيوك تشكمجي", cityId: 65),
      Area(id: 6515, name: "Çatalca - چاتالجا", cityId: 65),
      Area(id: 6516, name: "Çekmeköy - چكمكوي", cityId: 65),
      Area(id: 6517, name: "Esenler - ايسنلر", cityId: 65),
      Area(id: 6518, name: "Esenyurt - ايسنيورت", cityId: 65),
      Area(id: 6519, name: "Eyüp - ايوب", cityId: 65),
      Area(id: 6520, name: "Fatih - فاتح", cityId: 65),
      Area(id: 6521, name: "Gaziosmanpaşa - غازي عثمان باشا", cityId: 65),
      Area(id: 6522, name: "Güngören - غونجورين", cityId: 65),
      Area(id: 6523, name: "Kadıköy - قديكوي", cityId: 65),
      Area(id: 6524, name: "Kağıthane - كاغيتهانه", cityId: 65),
      Area(id: 6525, name: "Kartal - كارتال", cityId: 65),
      Area(id: 6526, name: "Küçükçekmece - كوجك تشكمجي", cityId: 65),
      Area(id: 6527, name: "Maltepe - مالتيبه", cityId: 65),
      Area(id: 6528, name: "Pendik - بنديق", cityId: 65),
      Area(id: 6529, name: "Sancaktepe - سانجاك تيبه", cityId: 65),
      Area(id: 6530, name: "Sarıyer - سارير", cityId: 65),
      Area(id: 6531, name: "Silivri - سيليفري", cityId: 65),
      Area(id: 6532, name: "Sultanbeyli - سلطان بيلي", cityId: 65),
      Area(id: 6533, name: "Sultangazi - سلطان قازي", cityId: 65),
      Area(id: 6534, name: "Şile - شيله", cityId: 65),
      Area(id: 6535, name: "Şişli - شيشلي", cityId: 65),
      Area(id: 6536, name: "Tuzla - توزلا", cityId: 65),
      Area(id: 6537, name: "Ümraniye - عمرانية", cityId: 65),
      Area(id: 6538, name: "Üsküdar - أسكودار", cityId: 65),
      Area(id: 6539, name: "Zeytinburnu - زيتين بورنو", cityId: 65),
    ],
  };
  List<Area> getAreasByCityTrIdTr(int cityId) {
    return cityAreasTrAr[cityId] ?? [];
  }

  //////////////////////////سوريا.............../
  ///
  final Map<int, List<Area>> cityAreasSy = {
    /// 65 - دمشق (Damascus)
    65: [
      Area(id: 6501, name: "دمشق القديمة - Old Damascus", cityId: 65),
      Area(id: 6502, name: "الميدان - Al-Midan", cityId: 65),
      Area(id: 6503, name: "القصاع - Al-Qassaa", cityId: 65),
      Area(id: 6504, name: "المزة - Al-Mazzeh", cityId: 65),
      Area(id: 6505, name: "كفر سوسة - Kafr Souseh", cityId: 65),
      Area(id: 6506, name: "الزاهرة - Al-Zahra", cityId: 65),
      Area(id: 6507, name: "برزة - Barzeh", cityId: 65),
      Area(id: 6508, name: "دمر - Dummar", cityId: 65),
      Area(id: 6509, name: "التضامن - Al-Tadamon", cityId: 65),
      Area(id: 6510, name: "المالكي - Al-Maliki", cityId: 65),
    ],

    /// 66 - حلب (Aleppo)
    66: [
      Area(id: 6601, name: "المدينة القديمة - Old City", cityId: 66),
      Area(id: 6602, name: "السليمانية - Al-Sulaymaniyah", cityId: 66),
      Area(id: 6603, name: "العزيزية - Al-Aziziyah", cityId: 66),
      Area(id: 6604, name: "الشيخ مقصود - Sheikh Maqsoud", cityId: 66),
      Area(id: 6605, name: "السكري - Al-Sukkari", cityId: 66),
      Area(id: 6606, name: "الفرقان - Al-Furqan", cityId: 66),
      Area(id: 6607, name: "الحمدانية - Al-Hamdaniyah", cityId: 66),
      Area(id: 6608, name: "الجميلية - Al-Jamiliyah", cityId: 66),
      Area(id: 6609, name: "السفيرة - Al-Safira", cityId: 66),
      Area(id: 6610, name: "حلب الجديدة - New Aleppo", cityId: 66),
    ],

    /// 67 - حمص (Homs)
    67: [
      Area(id: 6701, name: "باب السباع - Bab al-Sebaa", cityId: 67),
      Area(id: 6702, name: "الكرامة - Al-Karamah", cityId: 67),
      Area(id: 6703, name: "الوعر - Al-Waer", cityId: 67),
      Area(id: 6704, name: "الغوطة - Al-Ghouta", cityId: 67),
      Area(id: 6705, name: "الزهراء - Al-Zahra", cityId: 67),
      Area(id: 6706, name: "القديمة - Al-Qadima", cityId: 67),
      Area(id: 6707, name: "المنشية - Al-Manshiyah", cityId: 67),
      Area(id: 6708, name: "الخالدية - Al-Khalidiyah", cityId: 67),
    ],

    /// 68 - حماة (Hama)
    68: [
      Area(id: 6801, name: "الميدان - Al-Midan", cityId: 68),
      Area(id: 6802, name: "الحاضر - Al-Hader", cityId: 68),
      Area(id: 6803, name: "الجامع الكبير - Great Mosque", cityId: 68),
      Area(id: 6804, name: "الخابور - Al-Khabour", cityId: 68),
      Area(id: 6805, name: "المشرفة - Al-Mashrafa", cityId: 68),
      Area(id: 6806, name: "المنصورية - Al-Mansuriyah", cityId: 68),
      Area(id: 6807, name: "الراموسة - Al-Ramousa", cityId: 68),
    ],

    /// 69 - اللاذقية (Latakia)
    69: [
      Area(id: 6901, name: "الميناء - Al-Mina", cityId: 69),
      Area(id: 6902, name: "الشاطئ الأزرق - Blue Beach", cityId: 69),
      Area(id: 6903, name: "الجامعة - University", cityId: 69),
      Area(id: 6904, name: "الصليبة - Al-Saliba", cityId: 69),
      Area(id: 6905, name: "القنوات - Al-Qanawat", cityId: 69),
      Area(id: 6906, name: "الشيخ ضاهر - Sheikh Daher", cityId: 69),
    ],

    /// 70 - طرطوس (Tartus)
    70: [
      Area(id: 7001, name: "الميناء - Al-Mina", cityId: 70),
      Area(id: 7002, name: "الرمل الجنوبي - South Sand", cityId: 70),
      Area(id: 7003, name: "الصناعة - Al-Sinaa", cityId: 70),
      Area(id: 7004, name: "القديمة - Al-Qadima", cityId: 70),
      Area(id: 7005, name: "المشتاية - Al-Mashtaya", cityId: 70),
    ],

    /// 71 - دير الزور (Deir ez-Zor)
    71: [
      Area(id: 7101, name: "الجزيرة - Al-Jazira", cityId: 71),
      Area(id: 7102, name: "الرشيدية - Al-Rashidiyah", cityId: 71),
      Area(id: 7103, name: "الحويقة - Al-Huwaija", cityId: 71),
      Area(id: 7104, name: "المطار - Airport", cityId: 71),
      Area(id: 7105, name: "السبعة - Al-Sabaa", cityId: 71),
    ],

    /// 72 - الرقة (Raqqa)
    72: [
      Area(id: 7201, name: "المنصورية - Al-Mansuriyah", cityId: 72),
      Area(id: 7202, name: "الحرية - Al-Hurriya", cityId: 72),
      Area(id: 7203, name: "المشلب - Al-Mashlab", cityId: 72),
      Area(id: 7204, name: "الرقة القديمة - Old Raqqa", cityId: 72),
      Area(id: 7205, name: "الضاحية - Al-Dahiya", cityId: 72),
    ],

    /// 73 - درعا (Daraa)
    73: [
      Area(id: 7301, name: "المخيم - Al-Mukhayyam", cityId: 73),
      Area(id: 7302, name: "الطريق الدولي - International Road", cityId: 73),
      Area(id: 7303, name: "الصناعة - Al-Sinaa", cityId: 73),
      Area(id: 7304, name: "المنارة - Al-Manara", cityId: 73),
      Area(id: 7305, name: "الحي الغربي - Western District", cityId: 73),
    ],

    /// 74 - إدلب (Idlib)
    74: [
      Area(id: 7401, name: "المدينة القديمة - Old City", cityId: 74),
      Area(id: 7402, name: "الجامع الكبير - Great Mosque", cityId: 74),
      Area(id: 7403, name: "الحرية - Al-Hurriya", cityId: 74),
      Area(id: 7404, name: "الصناعة - Al-Sinaa", cityId: 74),
      Area(id: 7405, name: "المطار - Airport", cityId: 74),
    ],
  };
  List<Area> getAreasByCityTrIdSy(int cityId) {
    return cityAreasSy[cityId] ?? [];
  }

  void resetArea() {
    idOfArea.value = 0;
    selectedAreaName.value = null;
  }

  void setSelectedArea(int id, String name) {
    idOfArea.value = id;
    selectedAreaName.value = name;
  }
}

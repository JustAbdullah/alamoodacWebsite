import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/ThemeController.dart';
import '../../core/constant/app_text_styles.dart';
import '../../core/constant/appcolors.dart';

class AboutTermsPrivacyPage extends StatefulWidget {
  const AboutTermsPrivacyPage({super.key});

  @override
  State<AboutTermsPrivacyPage> createState() => _AboutTermsPrivacyPageState();
}

class _AboutTermsPrivacyPageState extends State<AboutTermsPrivacyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor(_themeController.isDarkMode.value),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutUsContent(),
                _buildTermsContent(),
                _buildPrivacyContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'المعلومات والسياسات',
        style: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 20.sp,
          color: AppColors.textColor(_themeController.isDarkMode.value),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: AppColors.textColor(_themeController.isDarkMode.value)),
        onPressed: () => Get.back(),
      ),
      backgroundColor:
          AppColors.backgroundColor(_themeController.isDarkMode.value),
      elevation: 0,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.backgroundColor(_themeController.isDarkMode.value),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.TheMain,
        labelColor: AppColors.TheMain,
        unselectedLabelColor:
            AppColors.textColor(_themeController.isDarkMode.value)
                .withOpacity(0.6),
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.DinarOne,
          fontSize: 14.sp,
        ),
        tabs: const [
          Tab(text: 'من نحن'),
          Tab(text: 'الشروط'),
          Tab(text: 'الخصوصية'),
        ],
      ),
    );
  }

  Widget _buildAboutUsContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          _buildSectionTitle("مرحبًا بكم في تطبيق على مودك"),
          _buildSectionBody(
              "نحن فخورون بأن نقدم لكم أول تطبيق إعلانات مبوبة مدعوم تقنيًا من قبل عدة شركات رائدة في مجال الذكاء الاصطناعي. تم تأسيس هذا التطبيق من خلال ائتلاف ثلاث شركات رائدة في مجال التجارة الالكترونية والتطوير الرقمي."),
          _buildSectionTitle("رؤيتنا"),
          _buildSectionBody(
              "بفضل دعمنا التقني من عدة شركات عالمية مختصة في الذكاء الاصطناعي، نهدف إلى تقديم تجربة فريدة ومبتكرة للمستخدمين. يعتبر تطبيقنا أول تطبيق إعلانات مبوبة يعمل بالذكاء الاصطناعي، مما يتيح للمستخدمين الوصول إلى محتوى مخصص وذكي يلبي احتياجاتهم بشكل أفضل."),
          _buildSectionTitle("فريقنا"),
          _buildSectionBody(
              "يضم فريقنا مجموعة من الخبراء في مجالات متعددة، مما يضمن تقديم أفضل الحلول والخدمات لعملائنا. نحن متحمسون للعمل معكم لنحقق معًا أهدافكم."),
          _buildSectionTitle("اتصل بنا"),
          _buildSectionBody(
              "نحن هنا للاستماع إليكم ومساعدتكم في تحقيق طموحاتكم. تواصلوا معنا عبر [وسائل الاتصال]."),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          _buildSectionTitle("شروط وأحكام استخدام تطبيق على مودك"),
          _buildSectionBody(
              "مقدمة: مرحبًا بك في تطبيق على مودك. باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق."),
          _buildSectionTitle("1. تعريفات:"),
          _buildSectionBody(
              "• التطبيق: يشير إلى تطبيق على مودك المتاح على منصات التشغيل.\n"
              "• المستخدم: يشير إلى أي فرد يقوم بتحميل واستخدام التطبيق.\n"
              "• الإعلانات: تشير إلى الإعلانات المبوبة التي يتم نشرها عبر التطبيق."),
          _buildSectionTitle("2. حقوق وواجبات المستخدم:"),
          _buildSectionTitle("2.1. حقوق المستخدم:"),
          _buildSectionBody(
              "• يحق للمستخدم استخدام التطبيق بشكل قانوني ومناسب.\n"
              "• يحق للمستخدم نشر الإعلانات الخاصة به وفقًا للشروط المحددة.\n"
              "• يحق للمستخدم تلقي الدعم الفني والمساعدة من فريق الدعم."),
          _buildSectionTitle("2.2. واجبات المستخدم:"),
          _buildSectionBody(
              "• يجب على المستخدم تقديم معلومات صحيحة ودقيقة عند التسجيل ونشر الإعلانات.\n"
              "• يحظر على المستخدم نشر أي محتوى غير قانوني أو مسيء أو يروج للعنف أو الكراهية.\n"
              "• يجب على المستخدم احترام حقوق الملكية الفكرية وعدم انتهاك حقوق الآخرين."),
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          _buildSectionTitle("سياسة الخصوصية لتطبيق على مودك"),
          _buildSectionBody(
              "مقدمة: نلتزم بحماية خصوصيتك. توضح هذه السياسة كيفية جمع واستخدام وحماية المعلومات الشخصية الخاصة بك عند استخدام تطبيق على مودك."),
          _buildSectionTitle("1. المعلومات التي نجمعها:"),
          _buildSectionTitle("1.1. المعلومات الشخصية:"),
          _buildSectionBody(
              "عند التسجيل في التطبيق، قد نجمع معلومات مثل الاسم، البريد الإلكتروني، رقم الهاتف، ومعلومات الحساب الأخرى."),
          _buildSectionTitle("1.2. المعلومات غير الشخصية:"),
          _buildSectionBody(
              "قد نقوم بجمع معلومات غير شخصية مثل نوع الجهاز، نظام التشغيل، عنوان IP، وبيانات الاستخدام لتحسين تجربة المستخدم."),
          _buildSectionTitle("2. كيفية استخدام المعلومات:"),
          _buildSectionBody("نستخدم المعلومات التي نجمعها للأغراض التالية:\n"
              "• لتقديم خدمات التطبيق وتحسينها.\n"
              "• للتواصل معك بشأن حسابك أو الخدمات المقدمة.\n"
              "• لتحليل البيانات وفهم كيفية استخدام التطبيق."),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(text,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: AppTextStyles.DinarOne,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor(_themeController.isDarkMode.value),
          )),
    );
  }

  Widget _buildSectionBody(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Text(text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.8,
            fontFamily: AppTextStyles.DinarOne,
            color: AppColors.textColor(_themeController.isDarkMode.value),
          )),
    );
  }
}

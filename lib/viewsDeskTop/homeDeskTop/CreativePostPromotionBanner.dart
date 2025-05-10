import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class EnhancedPromotionBanner extends StatefulWidget {
  const EnhancedPromotionBanner({super.key});

  @override
  State<EnhancedPromotionBanner> createState() => _EnhancedPromotionBannerState();
}

enum ActiveSection { creation, boosting, packages }

class _EnhancedPromotionBannerState extends State<EnhancedPromotionBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _sectionController;
  late final AnimationController _shimmerController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  ActiveSection activeSection = ActiveSection.creation;
  Timer? _autoScrollTimer;

  final List<Color> _gradientColors = [
    const Color(0xFFFFD700),
    const Color(0xFFFFA500),
    const Color(0xFFFF8C00),
  ];

  final Map<ActiveSection, List<Map<String, dynamic>>> _features = {
  
  };

  @override
  void initState() {
    super.initState();
    _sectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _setupAnimations();
    _startAutoScroll();
  }

  void _setupAnimations() {
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _sectionController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOutBack),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sectionController,
        curve: Curves.easeOutQuint,
      ),
    );
    _sectionController.forward();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) _cycleToNextSection();
    });
  }

  void _cycleToNextSection() {
    final sections = ActiveSection.values;
    final nextIndex = (sections.indexOf(activeSection) + 1) % sections.length;
    setState(() {
      activeSection = sections[nextIndex];
    });
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _shimmerController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sectionController,
        builder: (context, _) {
          return SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.amber.shade100,
                  highlightColor: Colors.amber.shade50,
                  period: _shimmerController.duration!,
                  child: Container(
                    padding: EdgeInsets.all(25.w),
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: _gradientColors,
                        stops: const [0.2, 0.5, 0.8],
                        center: Alignment.topLeft,
                        transform: GradientRotation(_sectionController.value * 0.5),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3 * _sectionController.value),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(),
              SizedBox(height: 15.h),
              _buildFeatureChips(),
            ],
          ),
        ),
        SizedBox(width: 20.w),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildAnimatedHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          // استخدام ValueKey ثابت اعتماداً على القسم لمنع تكرار المفاتيح
          key: ValueKey('header_${activeSection.name}'),
          child: _HeaderContent(
            icon: _getSectionIcon(),
            title: _getSectionTitle(),
            color: Colors.amber.shade800,
          ),
        ),
        SizedBox(height: 15.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          key: ValueKey('text_${activeSection.name}'),
          child: _SectionTextContent(
            subtitle: _getSectionSubtitle(),
            description: _getSectionDescription(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChips() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1.0,
          child: child,
        ),
      ),
      key: ValueKey('features_${activeSection.name}'),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: _getFeaturesForSection().map((feature) {
          return _FeatureChip(
            key: ValueKey('${activeSection.name}_${feature['text']}'),
            text: feature['text'] as String,
            icon: feature['icon'] as IconData,
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getFeaturesForSection() {
    return _features[activeSection] ?? [];
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ActiveSection.values.map((section) {
        return Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: _ActionButton(
            key: ValueKey('action_${section.name}'),
            section: section,
            activeSection: activeSection,
            onHover: (s) => setState(() => activeSection = s),
            onTap: (s) {
              setState(() { activeSection = s; });
              Get.snackbar(
                _getSectionTitle(),
                "تم اختيار ${_getSectionTitle()}",
                backgroundColor: Colors.amber.withOpacity(0.9),
                duration: const Duration(seconds: 2),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  IconData _getSectionIcon() {
    switch (activeSection) {
      case ActiveSection.creation:
        return Icons.create;
      case ActiveSection.boosting:
        return Icons.rocket_launch;
      case ActiveSection.packages:
        return Icons.diamond;
    }
  }

  String _getSectionTitle() {
    switch (activeSection) {
      case ActiveSection.creation:
        return "إنشاء محتوى متميز".tr;
      case ActiveSection.boosting:
        return "تعزيز المنشورات".tr;
      case ActiveSection.packages:
        return "الباقات المميزة".tr;
    }
  }

  String _getSectionSubtitle() {
    switch (activeSection) {
      case ActiveSection.creation:
        return "اصنع إعلانًا لا يُنسى".tr;
      case ActiveSection.boosting:
        return "وصل إلى جمهور أوسع".tr;
      case ActiveSection.packages:
        return "اختر ما يناسبك".tr;
    }
  }

  String _getSectionDescription() {
    switch (activeSection) {
      case ActiveSection.creation:
        return "تصميم احترافي مع أدوات متكاملة".tr;
      case ActiveSection.boosting:
        return "تعزيز ذكي مع تحليلات فورية".tr;
      case ActiveSection.packages:
        return "باقات تناسب جميع الاحتياجات".tr;
    }
  }
}

class _HeaderContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _HeaderContent({
    required this.icon,
    required this.title,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 32.sp),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DinarOne',
            fontSize: 24.sp,
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SectionTextContent extends StatelessWidget {
  final String subtitle;
  final String description;

  const _SectionTextContent({
    required this.subtitle,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: subtitle,
        style: TextStyle(
          fontFamily: 'DinarOne',
          fontSize: 18.sp,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: "\n$description",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _FeatureChip({
    required this.text,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.amber.shade800, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              text.tr,
              style: TextStyle(
                fontFamily: 'DinarOne',
                fontSize: 12.sp,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final ActiveSection section;
  final ActiveSection activeSection;
  final Function(ActiveSection) onHover;
  final Function(ActiveSection) onTap;

  const _ActionButton({
    required this.section,
    required this.activeSection,
    required this.onHover,
    required this.onTap,
    super.key,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  late Color _buttonColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buttonColor = _getButtonColor();
  }

  Color _getButtonColor() {
    switch (widget.section) {
      case ActiveSection.creation:
        return Colors.amber.shade800;
      case ActiveSection.boosting:
        return Colors.orange.shade700;
      case ActiveSection.packages:
        return Colors.deepOrange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.activeSection == widget.section;
    return MouseRegion(
      onEnter: (_) => widget.onHover(widget.section),
      onExit: (_) => widget.onHover(ActiveSection.creation),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [
              _buttonColor,
              _buttonColor.withOpacity(isActive ? 0.9 : 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _buttonColor.withOpacity(isActive ? 0.3 : 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () => widget.onTap(widget.section),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(_getIcon(), color: Colors.white, size: 22.sp),
                  SizedBox(width: 12.w),
                  Text(
                    _getLabel(),
                    style: TextStyle(
                      fontFamily: 'DinarOne',
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.section) {
      case ActiveSection.creation:
        return Icons.add_circle_outline;
      case ActiveSection.boosting:
        return Icons.trending_up;
      case ActiveSection.packages:
        return Icons.diamond;
    }
  }

  String _getLabel() {
    switch (widget.section) {
      case ActiveSection.creation:
        return "إنشاء جديد".tr;
      case ActiveSection.boosting:
        return "تعزيز المنشور".tr;
      case ActiveSection.packages:
        return "الباقات المميزة".tr;
    }
  }
}

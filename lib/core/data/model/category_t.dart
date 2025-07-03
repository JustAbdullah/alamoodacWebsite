class CategoryT {
  final int id; // استخدام int للـ id
  final String name; // استخدام String للـ name
  final String slug; // استخدام String للـ slug

  CategoryT({
    required this.id,
    required this.name,
    required this.slug,
  });

  // التعديل في طريقة إنشاء الكائن من JSON
  factory CategoryT.fromJson(Map<String, dynamic> json) {
    // التحقق من وجود بيانات في الترجمة
    var translation =
        json['translations'] != null && json['translations'].isNotEmpty
            ? json['translations'][0] // الحصول على أول ترجمة
            : {}; // في حالة عدم وجود ترجمة، العودة إلى قيمة فارغة

    return CategoryT(
      id: json['id'] ?? 1, // إذا لم يكن موجودًا، تعيين القيمة الافتراضية 1
      slug: json['slug'] ??
          'Default Title', // تعيين القيمة الافتراضية إذا كانت slug غير موجودة
      name: translation['name'] ??
          'Default name', // أخذ name من الترجمة الأولى أو تعيين القيمة الافتراضية
    );
  }
}

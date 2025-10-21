import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'see_all': 'See All',
      'popular_product': 'Popular Product',
      'categories': 'Categories',
      'search_hint': 'Search..',
      'search': 'Search',
      'wishlist_empty_title': 'No favorites yet',
      'wishlist_empty_subtitle': 'Add items to wishlist from product pages',
      'add_to_cart': 'Add To Cart',
      'added_to_cart': 'Added to cart',
      'added_opening_cart': 'Added and opening cart',
      'buy_now': 'Buy Now',
      'cart_title': 'My Cart',
      'discount_code_hint': 'Enter Discount Code',
      'apply': 'Apply',
      'checkout': 'Checkout',
      'checkout_mock': 'Checkout not implemented (mock)',
      'account': 'Account',
      'settings': 'Settings',
      'support': 'Support',
      'filters': 'Filters',
      'reset': 'Reset',
      'gender': 'Gender',
      'category': 'Category',
      'price_range': 'Price Range',
      'no_results': 'No results found',
      'wishlist': 'My Wishlist',
      'cart_empty': 'Your cart is empty',
      'subtotal': 'Subtotal',
      'discount': 'Discount',
      'total': 'Total',
      'product_not_found': 'Product not found',
      'details': 'Details',
      'select_size': 'Select Size',
      'quantity': 'Quantity',
      'description': 'Description',
      'please_select_size': 'Please select a size',
    },
    'ar': {
      'see_all': 'شاهد الكل',
      'popular_product': 'المنتجات الرائجة',
      'categories': 'الفئات',
      'search_hint': 'ابحث..',
      'search': 'بحث',
      'wishlist_empty_title': 'لا مفضلات بعد',
      'wishlist_empty_subtitle': 'أضف عناصر للمفضلة من صفحة المنتجات',
      'add_to_cart': 'أضف إلى السلة',
      'added_to_cart': 'تمت الإضافة إلى السلة',
      'added_opening_cart': 'تمت الإضافة وسيتم فتح السلة',
      'buy_now': 'اشتري الآن',
      'cart_title': 'سلتي',
      'discount_code_hint': 'أدخل رمز الخصم',
      'apply': 'تطبيق',
      'checkout': 'إتمام الشراء',
      'checkout_mock': 'الدفع غير متوفر (محاكاة)',
      'account': 'الحساب',
      'settings': 'الإعدادات',
      'support': 'الدعم',
      'filters': 'التصفية',
      'reset': 'إعادة ضبط',
      'gender': 'الجنس',
      'category': 'الفئة',
      'price_range': 'نطاق السعر',
      'no_results': 'لا توجد نتائج',
      'wishlist': 'قائمة المفضلة',
      'cart_empty': 'سلتك فارغة',
      'subtotal': 'الإجمالي الفرعي',
      'discount': 'الخصم',
      'total': 'الإجمالي',
      'product_not_found': 'المنتج غير موجود',
      'details': 'التفاصيل',
      'select_size': 'اختر المقاس',
      'quantity': 'الكمية',
      'description': 'الوصف',
      'please_select_size': 'يرجى اختيار المقاس',
    },
  };

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

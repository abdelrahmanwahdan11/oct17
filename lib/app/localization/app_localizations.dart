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
      'wishlist_empty_title': 'No favorites yet',
      'wishlist_empty_subtitle': 'Add items to wishlist from product pages',
      'add_to_cart': 'Add To Cart',
      'buy_now': 'Buy Now',
      'cart_title': 'My Cart',
      'discount_code_hint': 'Enter Discount Code',
      'apply': 'Apply',
      'checkout': 'Checkout',
      'checkout_mock': 'Checkout not implemented (mock)',
      'account': 'Account',
      'settings': 'Settings',
      'support': 'Support',
    },
    'ar': {
      'see_all': 'شاهد الكل',
      'popular_product': 'المنتجات الرائجة',
      'categories': 'الفئات',
      'search_hint': 'ابحث..',
      'wishlist_empty_title': 'لا مفضلات بعد',
      'wishlist_empty_subtitle': 'أضف عناصر للمفضلة من صفحة المنتجات',
      'add_to_cart': 'أضف إلى السلة',
      'buy_now': 'اشتري الآن',
      'cart_title': 'سلتي',
      'discount_code_hint': 'أدخل رمز الخصم',
      'apply': 'تطبيق',
      'checkout': 'إتمام الشراء',
      'checkout_mock': 'الدفع غير متوفر (محاكاة)',
      'account': 'الحساب',
      'settings': 'الإعدادات',
      'support': 'الدعم',
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

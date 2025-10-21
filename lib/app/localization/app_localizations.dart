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
      'checkout_title': 'Checkout',
      'shipping_address': 'Shipping Address',
      'payment_method': 'Payment Method',
      'order_summary': 'Order Summary',
      'order_empty_cart_message': 'Your cart is empty. Add items before checking out.',
      'place_order': 'Place Order',
      'edit': 'Edit',
      'edit_address': 'Edit Address',
      'edit_payment': 'Edit Payment',
      'name_label': 'Full Name',
      'phone_label': 'Phone Number',
      'street_label': 'Street Address',
      'city_label': 'City',
      'country_label': 'Country',
      'payment_brand_label': 'Card Brand',
      'payment_last4_label': 'Last 4 Digits',
      'save_changes': 'Save Changes',
      'form_incomplete_message': 'Please complete all fields.',
      'account': 'Account',
      'settings': 'Settings',
      'support': 'Support',
      'orders_title': 'My Orders',
      'order_id_label': 'Order #{id}',
      'placed_on': 'Placed on',
      'order_more_items': '+{count} more items',
      'order_status_processing': 'Processing',
      'order_status_completed': 'Completed',
      'orders_empty_title': 'No orders yet',
      'orders_empty_subtitle': 'Place your first order to see it here.',
      'order_success_title': 'Order Confirmed!',
      'order_success_subtitle': 'Order {id} has been placed successfully.',
      'view_orders': 'View Orders',
      'continue_shopping': 'Continue Shopping',
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
      'checkout_title': 'إتمام الشراء',
      'shipping_address': 'عنوان التوصيل',
      'payment_method': 'طريقة الدفع',
      'order_summary': 'ملخص الطلب',
      'order_empty_cart_message': 'سلتك فارغة، أضف منتجات للمتابعة.',
      'place_order': 'تأكيد الطلب',
      'edit': 'تعديل',
      'edit_address': 'تعديل العنوان',
      'edit_payment': 'تعديل الدفع',
      'name_label': 'الاسم الكامل',
      'phone_label': 'رقم الهاتف',
      'street_label': 'عنوان الشارع',
      'city_label': 'المدينة',
      'country_label': 'الدولة',
      'payment_brand_label': 'شركة البطاقة',
      'payment_last4_label': 'آخر 4 أرقام',
      'save_changes': 'حفظ التعديلات',
      'form_incomplete_message': 'يرجى إكمال جميع الحقول.',
      'account': 'الحساب',
      'settings': 'الإعدادات',
      'support': 'الدعم',
      'orders_title': 'طلباتي',
      'order_id_label': 'طلب #{id}',
      'placed_on': 'تاريخ الطلب',
      'order_more_items': '+{count} عناصر إضافية',
      'order_status_processing': 'قيد المعالجة',
      'order_status_completed': 'مكتمل',
      'orders_empty_title': 'لا توجد طلبات بعد',
      'orders_empty_subtitle': 'عند إتمام عملية شراء ستظهر هنا.',
      'order_success_title': 'تم تأكيد الطلب!',
      'order_success_subtitle': 'تم إرسال طلب {id} بنجاح.',
      'view_orders': 'عرض الطلبات',
      'continue_shopping': 'متابعة التسوق',
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

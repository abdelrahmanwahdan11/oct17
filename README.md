# {{APP_NAME}}

منصة Flutter جاهزة للإطلاق تدعم العربية والإنجليزية، وتضم بناءً نظيفاً مع ثيمين فاتح/داكن، وقابلية للعمل على Android وiOS والويب (PWA). يحتوي المشروع على بيانات وهمية وخدمات مخزونة مسبقاً لتجربة الميزات بدون خادم خلفي.

## المتغيرات القابلة للتخصيص
قم بتحديث القيم التالية في المشروع لتكييفه مع منتجك:

| المتغير | الموقع | الوصف |
| --- | --- | --- |
| `{{APP_NAME}}` | `pubspec.yaml`, `lib/core/i18n/strings.dart`, الشاشات | اسم التطبيق المعروض للمستخدم |
| `{{APP_SLUG}}` | `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist` (أضف عند إنشاء تطبيق حقيقي) | المعرّف الفريد للتطبيق |
| `{{APP_DOMAIN_OR_INDUSTRY}}` | `lib/data/seed/seed_data.dart`, `README.md` | مجال العمل أو الفئة |
| `{{PRIMARY_ACTION_LABEL}}` | المكوّن `CTAButton` داخل `lib/widgets/buttons/primary_button.dart` | تسمية زر الدعوة الرئيسية |
| `{{HERO_IMAGE_URL}}` | `lib/modules/home/widgets/hero_section.dart` | صورة واجهة البطل الرئيسية |
| `{{LOGO_SVG}}` | `assets/icons/` (ضع الملف واستدعِه في `lib/widgets/branding/app_logo.dart`) | شعار العلامة التجارية |

## البنية
- **core/**: إعدادات التطبيق العامة (الترجمة، التيمة، التوجيه).
- **domain/**: النماذج والمستودعات المجردة.
- **data/**: بيانات البذور والمصادر الوهمية.
- **modules/**: الشاشات حسب الميزة مع الـ ViewModels.
- **widgets/**: مكوّنات التصميم المعاد استخدامها.
- **theme/**: رموز التصميم (ألوان، خطوط، ثيمات).

## المتطلبات
- Flutter 3.13 أو أحدث.
- لا توجد تبعيات خارجية إضافية باستثناء `google_fonts` و `shared_preferences`.

## كيفية التشغيل
```bash
flutter pub get
flutter run
```

## الاختبارات
```bash
flutter test
```

## التخصيص
- عدل الألوان في `lib/theme/colors.dart` لتحديث لوحة الهوية.
- حدّث الخطوط في `lib/theme/typography.dart`.
- أضف بيانات جديدة إلى `assets/seed/listings.json` وحدث `lib/data/seed/seed_data.dart`.
- فعّل شاشات إضافية بإضافة صفحات جديدة إلى `lib/core/router/app_router.dart` وربطها بالـ ViewModels المناسبة.


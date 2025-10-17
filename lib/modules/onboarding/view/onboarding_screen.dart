import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    final slides = [
      (
        loc.isArabic ? 'ابدأ خلال دقائق' : 'Start in minutes',
        loc.isArabic ? 'واجهة بسيطة وذكية' : 'Simple & smart UI',
      ),
      (
        loc.isArabic ? 'تصميم متجاوب' : 'Responsive design',
        loc.isArabic ? 'تجربة تعمل على كل الأجهزة' : 'Works on every device',
      ),
      (
        loc.isArabic ? 'دعم عربي/إنجليزي' : 'Arabic/English support',
        loc.isArabic ? 'اختر اللغة المناسبة لك' : 'Pick the language you prefer',
      ),
    ];
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(slide.item1, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 16),
                        Text(slide.item2, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => Container(
                  width: _index == index ? 16 : 8,
                  height: 8,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _index == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: widget.onGetStarted,
                child: Text(loc.isArabic ? 'ابدأ الآن' : 'Get started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

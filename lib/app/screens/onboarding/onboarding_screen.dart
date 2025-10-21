import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingContent> _pages = const [
    _OnboardingContent(
      image: 'assets/images/promo_girl.png',
      titleKey: 'onboarding_title_1',
      subtitleKey: 'onboarding_subtitle_1',
    ),
    _OnboardingContent(
      image: 'assets/images/men_1.png',
      titleKey: 'onboarding_title_2',
      subtitleKey: 'onboarding_subtitle_2',
    ),
    _OnboardingContent(
      image: 'assets/images/women_1.png',
      titleKey: 'onboarding_title_3',
      subtitleKey: 'onboarding_subtitle_3',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_index >= _pages.length - 1) {
      AppScope.of(context).auth.completeOnboarding();
      return;
    }
    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = responsivePadding(context);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => AppScope.of(context).auth.completeOnboarding(),
                      child: Text(localization.translate('onboarding_skip')),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (value) => setState(() => _index = value),
                      itemBuilder: (context, index) {
                        final content = _pages[index];
                        return _OnboardingSlide(
                          content: content,
                          isDark: isDark,
                          localization: localization,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 10,
                          width: _index == i ? 28 : 10,
                          decoration: BoxDecoration(
                            color: _index == i
                                ? AppColors.orange
                                : (isDark ? AppColors.darkBorder : AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        localization.translate(
                          _index == _pages.length - 1
                              ? 'onboarding_get_started'
                              : 'onboarding_next',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.content,
    required this.isDark,
    required this.localization,
  });

  final _OnboardingContent content;
  final bool isDark;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.orange.withOpacity(0.2),
                        AppColors.orangeDark.withOpacity(0.15),
                      ]
                    : [
                        AppColors.orangeSoft,
                        AppColors.orangeSoft.withOpacity(0.7),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Hero(
                tag: content.image,
                child: Image.asset(
                  content.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            localization.translate(content.titleKey),
            key: ValueKey(content.titleKey),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            localization.translate(content.subtitleKey),
            key: ValueKey(content.subtitleKey),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.image,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String image;
  final String titleKey;
  final String subtitleKey;
}

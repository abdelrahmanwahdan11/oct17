import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/app_scope.dart';
import '../../widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deps = AppScope.of(context);
      _timer = Timer(const Duration(milliseconds: 1200), () {
        final storage = deps.storage;
        final auth = deps.authController;
        if (!storage.onboardingDone) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
          return;
        }
        if (auth.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homeDiscovery);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.authLogin);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'app_logo',
                child: Text(
                  strings.t('app.name'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontFamily: 'AlexBrush',
                        fontSize: 48,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

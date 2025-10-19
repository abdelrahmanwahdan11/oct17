import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/app_scope.dart';
import '../../widgets/app_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    setState(() => _loading = false);
    Navigator.of(context).pushReplacementNamed(AppRoutes.homeDiscovery);
  }

  Future<void> _guest() async {
    final deps = AppScope.of(context);
    await deps.authController.loginAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.homeDiscovery);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        strings.t('app.name'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => AppScope.of(context).themeController.toggle(),
                        icon: const Icon(Icons.brightness_6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    strings.t('auth.login'),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return strings.t('auth.email');
                      }
                      if (!value.contains('@')) {
                        return 'invalid';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: strings.t('auth.email')),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'min 6';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: strings.t('auth.password')),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.authForgot),
                      child: Text(strings.t('auth.forgot')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(strings.t('auth.login')),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _guest,
                    child: Text(strings.t('auth.guest')),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(strings.t('auth.createAccount')),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.authRegister),
                        child: Text(strings.t('auth.register')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

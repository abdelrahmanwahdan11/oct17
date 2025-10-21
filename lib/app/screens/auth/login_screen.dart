import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../utils/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final localization = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorMessage = localization.translate('validation_required'));
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    final auth = AppScope.of(context).auth;
    try {
      await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('auth_welcome_back'))),
      );
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = localization.translate(error.code);
      });
    } catch (_) {
      setState(() {
        _errorMessage = localization.translate('auth_generic_error');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('login_title')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: responsivePagePadding(context, vertical: 32),
          child: ConstrainedBox(
            constraints: responsiveFormConstraints(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'auth.card',
                  child: Material(
                    color: theme.cardColor,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                localization.translate('welcome_back'),
                                style: theme.textTheme.displayMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                localization.translate('login_subtitle'),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _emailController,
                                autofillHints: const [AutofillHints.email],
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: localization.translate('email_label'),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localization.translate('validation_required');
                                  }
                                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return localization.translate('validation_email');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                autofillHints: const [AutofillHints.password],
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: localization.translate('password_label'),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localization.translate('validation_required');
                                  }
                                  if (value.length < 6) {
                                    return localization.translate('validation_password_length');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _errorMessage == null
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Text(
                                          _errorMessage!,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _isSubmitting ? null : _submit,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(localization.translate('login_button')),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => Navigator.of(context).pushReplacementNamed('auth.register'),
                                child: Text(localization.translate('login_create_account')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

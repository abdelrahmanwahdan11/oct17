import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'تسجيل الدخول' : 'Sign in')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: loc.isArabic ? 'البريد الإلكتروني' : 'Email'),
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : (loc.isArabic ? 'بريد غير صالح' : 'Invalid email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: loc.isArabic ? 'كلمة المرور' : 'Password'),
                  validator: (value) => value != null && value.length >= 8
                      ? null
                      : (loc.isArabic ? 'الحد الأدنى 8 أحرف' : 'Min 8 characters'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onAuthenticated();
                    }
                  },
                  child: Text(loc.isArabic ? 'متابعة' : 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

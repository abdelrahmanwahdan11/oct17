import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/local_storage_service.dart';

class AuthException implements Exception {
  AuthException(this.code);

  final String code;
}

class AuthController extends ChangeNotifier {
  AuthController({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;

  static const _usersKey = 'auth_users_v1';
  static const _currentUserKey = 'auth_current_user_v1';
  static const _onboardingKey = 'onboarding_complete_v1';

  final List<_StoredUser> _registeredUsers = [];
  UserProfile? _currentUser;
  bool _isOnboardingComplete = false;

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isOnboardingComplete => _isOnboardingComplete;

  String get initialRoute {
    if (!isOnboardingComplete) return 'onboarding';
    if (!isAuthenticated) return 'auth.login';
    return 'home';
  }

  Future<void> initialize() async {
    final onboarding = await storage.getBool(_onboardingKey);
    _isOnboardingComplete = onboarding ?? false;

    final rawUsers = await storage.getStringList(_usersKey);
    _registeredUsers
      ..clear()
      ..addAll(rawUsers.map((e) => _StoredUser.fromJson(jsonDecode(e) as Map<String, dynamic>)));

    final currentJson = await storage.getString(_currentUserKey);
    if (currentJson != null) {
      final data = jsonDecode(currentJson) as Map<String, dynamic>;
      _currentUser = UserProfile(
        id: data['id'] as String,
        name: data['name'] as String,
        email: data['email'] as String,
        avatar: data['avatar'] as String,
      );
    }
  }

  Future<void> completeOnboarding() async {
    if (_isOnboardingComplete) return;
    _isOnboardingComplete = true;
    await storage.setBool(_onboardingKey, true);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final exists = _registeredUsers.any((user) => user.email == email.toLowerCase());
    if (exists) {
      throw AuthException('auth.email_in_use');
    }
    final user = _StoredUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email.toLowerCase(),
      password: password,
      avatar: 'assets/images/avatar_alex.png',
    );
    _registeredUsers.add(user);
    await _persistUsers();
    await _setCurrentUser(user);
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final user = _registeredUsers.firstWhere(
      (element) => element.email == email.toLowerCase(),
      orElse: () => throw AuthException('auth.invalid_credentials'),
    );
    if (user.password != password) {
      throw AuthException('auth.invalid_credentials');
    }
    await _setCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await storage.remove(_currentUserKey);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final user = _currentUser;
    if (user == null) {
      throw AuthException('auth.generic_error');
    }
    final normalizedEmail = email.toLowerCase();
    final hasConflict = _registeredUsers.any(
      (registered) =>
          registered.email == normalizedEmail && registered.id != user.id,
    );
    if (hasConflict) {
      throw AuthException('auth.email_in_use');
    }

    final index = _registeredUsers.indexWhere((element) => element.id == user.id);
    if (index == -1) {
      throw AuthException('auth.generic_error');
    }

    final updatedUser = _registeredUsers[index].copyWith(
      name: name.trim(),
      email: normalizedEmail,
    );

    _registeredUsers[index] = updatedUser;
    await _persistUsers();
    await _setCurrentUser(updatedUser);
    notifyListeners();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _currentUser;
    if (user == null) {
      throw AuthException('auth.generic_error');
    }

    final index = _registeredUsers.indexWhere((element) => element.id == user.id);
    if (index == -1) {
      throw AuthException('auth.generic_error');
    }

    final stored = _registeredUsers[index];
    if (stored.password != currentPassword) {
      throw AuthException('auth.invalid_password');
    }

    _registeredUsers[index] = stored.copyWith(password: newPassword);
    await _persistUsers();
  }

  Future<void> _persistUsers() async {
    await storage.setStringList(
      _usersKey,
      _registeredUsers.map((user) => jsonEncode(user.toJson())).toList(),
    );
  }

  Future<void> _setCurrentUser(_StoredUser user) async {
    _currentUser = UserProfile(
      id: user.id,
      name: user.name,
      email: user.email,
      avatar: user.avatar,
    );
    await storage.setString(
      _currentUserKey,
      jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'avatar': user.avatar,
      }),
    );
  }
}

class _StoredUser {
  _StoredUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String avatar;

  _StoredUser copyWith({
    String? name,
    String? email,
    String? password,
    String? avatar,
  }) {
    return _StoredUser(
      id: id,
      name: name ?? this.name,
      email: (email ?? this.email).toLowerCase(),
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
    );
  }

  factory _StoredUser.fromJson(Map<String, dynamic> json) {
    return _StoredUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: (json['email'] as String).toLowerCase(),
      password: json['password'] as String,
      avatar: json['avatar'] as String? ?? 'assets/images/avatar_alex.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }
}

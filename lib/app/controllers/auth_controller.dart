import 'package:flutter/foundation.dart';

import '../../data/local/local_storage.dart';
import '../../domain/models/user.dart';
import '../../data/local/seed_data.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._storage) {
    final authJson = _storage.authUser;
    if (authJson != null) {
      _user = User.fromJson(Map<String, dynamic>.from(authJson));
    }
  }

  final LocalStorage _storage;
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> loginAsGuest() async {
    final users = decodeSeed(seedUsersJson)
        .map((json) => User.fromJson(json))
        .toList();
    _user = users.first;
    await _storage.saveAuthUser(_user!.toJson());
    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _user = User(
      id: 'reg_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      avatar: 'assets/images/avatar_laila.png',
      rating: 4.5,
      locale: 'ar',
    );
    await _storage.saveAuthUser(_user!.toJson());
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _storage.clearAuthUser();
    notifyListeners();
  }
}

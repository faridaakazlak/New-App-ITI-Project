import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalAuthService {
  final SharedPreferences _prefs;

  static const String _usersKey = 'users_list';
  static const String _currentUserKey = 'current_user_id';
  static const String _rememberMeKey = 'remember_me';

  static Future<LocalAuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalAuthService(prefs);
  }

  LocalAuthService(this._prefs);

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  String generateRandomId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(999999);
    return '$timestamp$randomPart';
  }

  Future<List<UserModel>> getAllUsers() async {
    final data = _prefs.getString(_usersKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> _saveAllUsers(List<UserModel> users) async {
    final data = users.map((u) => u.toJson()).toList();
    await _prefs.setString(_usersKey, jsonEncode(data));
  }

  Future<bool> register(UserModel user) async {
    final users = await getAllUsers();
    if (users.any((u) => u.email == user.email)) return false;

    final newUser = UserModel(
      id: generateRandomId(),
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      passwordHash: _hashPassword(user.passwordHash),
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      profileImage: user.profileImage,
      createdAt: DateTime.now(),
      lastLoginAt: null,
      securityQuestion: user.securityQuestion,
      securityAnswer: user.securityAnswer,
    );

    users.add(newUser);
    await _saveAllUsers(users);
    return true;
  }

  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final users = await getAllUsers();
    final hashed = _hashPassword(password);

    UserModel? user;
    for (var u in users) {
      if (u.email == email && u.passwordHash == hashed) {
        user = u;
        break;
      }
    }

    if (user == null) return false;

    final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
    final updatedUsers = users.map((u) {
      if (u.id == user!.id) return updatedUser;
      return u;
    }).toList();

    await _saveAllUsers(updatedUsers);
    await _prefs.setString(_currentUserKey, user.id);

    if (rememberMe) {
      await _prefs.setBool(_rememberMeKey, true);
    }

    return true;
  }

  Future<void> logout() async {
    await _prefs.remove(_currentUserKey);
    await _prefs.remove(_rememberMeKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final id = _prefs.getString(_currentUserKey);
    if (id == null) return null;

    final users = await getAllUsers();
    return users.firstWhere((u) => u.id == id, orElse: () => UserModel.empty());
  }

  Future<bool> isUserExists(String email) async {
    final users = await getAllUsers();
    return users.any((u) => u.email == email);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    return users.firstWhere(
      (u) => u.email == email,
      orElse: () => UserModel.empty(),
    );
  }

  Future<bool> verifySecurityAnswer(String email, String answer) async {
    final user = await getUserByEmail(email);
    if (user == null || user.email.isEmpty) return false;
    return user.securityAnswer?.toLowerCase().trim() ==
        answer.toLowerCase().trim();
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final users = await getAllUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) return false;

    final updatedUser = users[index].copyWith(
      passwordHash: _hashPassword(newPassword),
    );

    users[index] = updatedUser;
    await _saveAllUsers(users);
    return true;
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    return await resetPassword(email, newPassword);
  }

  Future<bool> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    final users = await getAllUsers();
    final index = users.indexWhere(
      (u) => u.email == email && u.passwordHash == _hashPassword(oldPassword),
    );

    if (index == -1) return false;

    final updatedUser = users[index].copyWith(
      passwordHash: _hashPassword(newPassword),
    );

    users[index] = updatedUser;
    await _saveAllUsers(users);
    return true;
  }

  Future<bool> updateProfile(UserModel updatedData) async {
    final users = await getAllUsers();
    final index = users.indexWhere((u) => u.id == updatedData.id);
    if (index == -1) return false;

    users[index] = updatedData;
    await _saveAllUsers(users);
    return true;
  }

  Future<bool> isRemembered() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }
}

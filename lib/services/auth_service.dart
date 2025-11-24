import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  // Login
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check credentials
    if (email == Constants.defaultEmail &&
        password == Constants.defaultPassword) {
      final user = User(
        email: email,
        name: 'Admin NesiaWay',
        avatarUrl:
            'https://ui-avatars.com/api/?name=Admin+NesiaWay&background=1E88E5&color=fff&size=200',
      );

      // Save login state
      await _saveLoginState(user);
      return user;
    }

    return null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.keyIsLoggedIn) ?? false;
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(Constants.keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final email = prefs.getString(Constants.keyUserEmail);
    final name = prefs.getString(Constants.keyUserName);

    if (email == null || name == null) return null;

    return User(
      email: email,
      name: name,
      avatarUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E88E5&color=fff&size=200',
    );
  }

  // Save login state
  Future<void> _saveLoginState(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.keyIsLoggedIn, true);
    await prefs.setString(Constants.keyUserEmail, user.email);
    await prefs.setString(Constants.keyUserName, user.name);
  }
}

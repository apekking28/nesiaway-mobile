import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';

class AuthService {
  final UserService _userService = UserService();

  // Login - Check credentials and fetch user data from API
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // First check default admin credentials
      if (email == Constants.defaultEmail &&
          password == Constants.defaultPassword) {
        // Try to get admin from API first
        final apiUser = await _userService.getUserByEmail(email);
        if (apiUser != null) {
          await _saveLoginState(apiUser);
          return apiUser;
        }

        // Fallback: Create default admin user
        final defaultAdmin = User(
          id: '0',
          email: email,
          name: 'Admin NesiaWay',
          role: 'admin',
          password: password,
          avatarUrl:
              'https://ui-avatars.com/api/?name=Admin+NesiaWay&background=1E88E5&color=fff&size=200',
        );

        await _saveLoginState(defaultAdmin);
        return defaultAdmin;
      }

      // Check user from API
      final user = await _userService.getUserByEmail(email);

      if (user != null) {
        // Validate password
        if (user.password != null && user.password!.isNotEmpty) {
          // Password exists in API, validate it
          if (user.password == password) {
            await _saveLoginState(user);
            return user;
          } else {
            // Wrong password
            return null;
          }
        } else {
          // No password in API (backward compatibility)
          // Accept any password for demo
          await _saveLoginState(user);
          return user;
        }
      }

      return null;
    } catch (e) {
      print('❌ Login error: $e');

      // Fallback to default admin if API fails
      if (email == Constants.defaultEmail &&
          password == Constants.defaultPassword) {
        final defaultAdmin = User(
          id: '0',
          email: email,
          name: 'Admin NesiaWay',
          role: 'admin',
          password: password,
          avatarUrl:
              'https://ui-avatars.com/api/?name=Admin+NesiaWay&background=1E88E5&color=fff&size=200',
        );

        await _saveLoginState(defaultAdmin);
        return defaultAdmin;
      }

      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Register - Create new user account
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check if email already exists
      final existingUser = await _userService.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email sudah terdaftar');
      }

      // Create new user via API
      final newUser = await _userService.createUserWithParams(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (newUser != null) {
        print('✅ User registered: ${newUser.name} (${newUser.role})');
        return newUser;
      }

      return null;
    } catch (e) {
      print('❌ Register error: $e');
      rethrow;
    }
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

    final id = prefs.getString(Constants.keyUserId);
    final email = prefs.getString(Constants.keyUserEmail);
    final name = prefs.getString(Constants.keyUserName);
    final role = prefs.getString(Constants.keyUserRole);

    if (email == null || name == null || role == null) return null;

    return User(
      id: id ?? '0',
      email: email,
      name: name,
      role: role,
      avatarUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E88E5&color=fff&size=200',
    );
  }

  // Save login state
  Future<void> _saveLoginState(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.keyIsLoggedIn, true);
    await prefs.setString(Constants.keyUserId, user.id);
    await prefs.setString(Constants.keyUserEmail, user.email);
    await prefs.setString(Constants.keyUserName, user.name);
    await prefs.setString(Constants.keyUserRole, user.role);

    print('✅ User logged in: ${user.name} (${user.role})');
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/constants.dart';

class UserService {
  static const String _baseUrl = Constants.baseUrl;
  static const String _endpoint = 'user';

  // Get all users
  Future<List<User>> getUsers() async {
    try {
      final url = '$_baseUrl/$_endpoint';
      print('🌐 Fetching users from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print('⏰ Request timeout');
              throw Exception('Request timeout');
            },
          );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('⚠️ Warning: Empty response body');
          return [];
        }

        try {
          final List<dynamic> data = json.decode(response.body);
          print('✅ Users loaded: ${data.length} items');
          return data.map((json) => User.fromJson(json)).toList();
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          rethrow;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching users: $e');
      throw Exception('Error fetching users: $e');
    }
  }

  // Get single user by ID
  Future<User> getUser(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$_endpoint/$id'));

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Get user by email (for login)
  Future<User?> getUserByEmail(String email) async {
    try {
      final users = await getUsers();
      try {
        return users.firstWhere(
          (user) => user.email.toLowerCase() == email.toLowerCase(),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('❌ Error getting user by email: $e');
      return null;
    }
  }

  // Create user
  Future<User> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ User created successfully');
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Create user with named parameters (for registration)
  Future<User?> createUserWithParams({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Generate avatar URL
      final avatarUrl =
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E88E5&color=fff&size=200';

      // Create user object
      final user = User(
        id: '', // Will be set by API
        name: name,
        email: email,
        password: password,
        role: role,
        avatarUrl: avatarUrl,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/$_endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ User created successfully: $name ($role)');
        return User.fromJson(json.decode(response.body));
      } else {
        print('❌ Failed to create user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error creating user: $e');
      throw Exception('Error creating user: $e');
    }
  }

  // Update user
  Future<User> updateUser(String id, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$_endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        print('✅ User updated successfully');
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$_endpoint/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }

      print('✅ User deleted successfully');
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}

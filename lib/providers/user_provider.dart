import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all users
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userService.getUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get single user
  Future<void> fetchUser(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedUser = await _userService.getUser(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create user
  Future<bool> createUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = await _userService.createUser(user);
      _users.insert(0, newUser);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(String id, User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(id, user);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search users
  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;

    return _users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.role.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter by role
  List<User> filterByRole(String role) {
    if (role.isEmpty || role == 'Semua') return _users;
    return _users
        .where((user) => user.role.toLowerCase() == role.toLowerCase())
        .toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set selected user
  void setSelectedUser(User? user) {
    _selectedUser = user;
    notifyListeners();
  }
}

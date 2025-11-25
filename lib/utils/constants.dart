import 'package:flutter/material.dart';

class Constants {
  // API
  static const String baseUrl =
      'https://691e876fbb52a1db22be25e9.mockapi.io/api/v1';
  static const String blogEndpoint = 'blog';

  // Auth
  static const String defaultEmail = 'admin@gmail.com';
  static const String defaultPassword = 'admin12345';

  // Storage Keys
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUserId = 'userId';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserName = 'userName';
  static const String keyUserRole = 'userRole';

  // Categories
  static const List<String> blogCategories = [
    'Wisata Alam',
    'Kuliner',
    'Budaya',
    'Pantai',
    'Gunung',
    'Kuliner Tradisional',
    'Festival',
    'Arsitektur',
  ];
}

class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFFFF6B35);
  static const Color accent = Color(0xFFFFC107);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  // Indonesian themed colors
  static const Color redIndonesia = Color(0xFFFF0000);
  static const Color whiteIndonesia = Colors.white;
}

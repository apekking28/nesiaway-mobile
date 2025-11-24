import 'package:flutter/material.dart';
import '../models/blog_model.dart';
import '../services/api_service.dart';

class BlogProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Blog> _blogs = [];
  Blog? _selectedBlog;
  bool _isLoading = false;
  String? _errorMessage;

  List<Blog> get blogs => _blogs;
  Blog? get selectedBlog => _selectedBlog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all blogs
  Future<void> fetchBlogs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _blogs = await _apiService.getBlogs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get single blog
  Future<void> fetchBlog(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedBlog = await _apiService.getBlog(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create blog
  Future<bool> createBlog(Blog blog) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBlog = await _apiService.createBlog(blog);
      _blogs.insert(0, newBlog);
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

  // Update blog
  Future<bool> updateBlog(String id, Blog blog) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedBlog = await _apiService.updateBlog(id, blog);
      final index = _blogs.indexWhere((b) => b.id == id);
      if (index != -1) {
        _blogs[index] = updatedBlog;
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

  // Delete blog
  Future<bool> deleteBlog(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteBlog(id);
      _blogs.removeWhere((blog) => blog.id == id);
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

  // Search blogs
  List<Blog> searchBlogs(String query) {
    if (query.isEmpty) return _blogs;

    return _blogs.where((blog) {
      return blog.title.toLowerCase().contains(query.toLowerCase()) ||
          blog.category.toLowerCase().contains(query.toLowerCase()) ||
          blog.body.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter by category
  List<Blog> filterByCategory(String category) {
    if (category.isEmpty || category == 'Semua') return _blogs;
    return _blogs.where((blog) => blog.category == category).toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set selected blog
  void setSelectedBlog(Blog? blog) {
    _selectedBlog = blog;
    notifyListeners();
  }
}

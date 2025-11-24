import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blog_model.dart';
import '../utils/constants.dart';

class ApiService {
  static const String _baseUrl = Constants.baseUrl;
  static const String _endpoint = Constants.blogEndpoint;

  // Get all blogs
  Future<List<Blog>> getBlogs() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$_endpoint'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Blog.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching blogs: $e');
    }
  }

  // Get single blog
  Future<Blog> getBlog(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$_endpoint/$id'));

      if (response.statusCode == 200) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load blog: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching blog: $e');
    }
  }

  // Create blog
  Future<Blog> createBlog(Blog blog) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(blog.toJson()),
      );

      if (response.statusCode == 201) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create blog: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating blog: $e');
    }
  }

  // Update blog
  Future<Blog> updateBlog(String id, Blog blog) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$_endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(blog.toJson()),
      );

      if (response.statusCode == 200) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update blog: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating blog: $e');
    }
  }

  // Delete blog
  Future<void> deleteBlog(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$_endpoint/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete blog: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting blog: $e');
    }
  }
}

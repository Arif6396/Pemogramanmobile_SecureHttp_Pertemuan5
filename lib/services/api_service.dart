import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // LATIHAN 5: Timeout yang dapat dikonfigurasi (Default 10 detik)
  Future<List<User>> getUsers({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout); // Menggunakan parameter timeout

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException('Gagal memuat data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout (${timeout.inSeconds} detik).');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // LATIHAN 3: Endpoint /posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw HttpException('Gagal memuat data posts.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // GET User By Id (Bawaan Praktikum)
  Future<User> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/users/$id')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw HttpException('Gagal memuat data.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Simulasi Login (Latihan 1)
  Future<String> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (email.isNotEmpty && password.isNotEmpty) {
        return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
      } else {
        throw Exception('Email dan password tidak boleh kosong');
      }
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
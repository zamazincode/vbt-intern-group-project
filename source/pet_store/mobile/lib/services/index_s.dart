import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<String?> getAllPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print('Token bulunamadı');
      return null;
    }
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/GetAllPosts');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer fef$token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('GetAllPosts Hata: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

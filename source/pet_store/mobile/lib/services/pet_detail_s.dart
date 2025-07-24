import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetDetailService {
  static Future<Map<String, dynamic>?> getPostById(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/GetPostById/$postId');
    final response = await http.get(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['isSuccess'] == true && data['result'] != null) {
        return data['result'];
      }
    }
    return null;
  }
}


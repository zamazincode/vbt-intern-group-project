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

  static Future<String?> generateDescription({
    required String type,
    required String breed,
  }) async {
    final url = Uri.parse('https://unuvarx.pythonanywhere.com/generate-description');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "type": type,
        "breed": breed,
      }),
    );
    print("GENERATEE DESCRIPTION RESPONSE: $response");
    print("GENERATEE DESCRIPTION RESPONSE BODY: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['description'] as String?;
    }
    return null;
  }

  static Future<String?> recommendPet({
    required String preferences,
  }) async {
    final url = Uri.parse('https://unuvarx.pythonanywhere.com/recommend-pet');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "preferences": preferences,
      }),
    );
    print("RECOMMEND PET RESPONSE: $response");
    print("RECOMMEND PET RESPONSE BODY: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['recommendation'] as String?;
    }
    return null;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/Services/Manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetDetailService {
  final ServiceManager _manager = ServiceManager();

  Future<Map<String, dynamic>?> getPostById(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = _manager.buildUri('post/GetPostById/$postId');
    final headers = _manager.getHeaders(token);

    try {
      final response = await _manager.client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccess'] == true && data['result'] != null) {
          return data['result'];
        }
      } else {
        print('❌ GetPostById Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ GetPostById Exception: $e');
    }
    return null;
  }

  Future<String?> generateDescription({
    required String type,
    required String breed,
  }) async {
    final url = Uri.parse('https://unuvarx.pythonanywhere.com/generate-description');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "type": type,
          "breed": breed,
        }),
      );
      print("🟡 Generate Description → Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['description'] as String?;
      }
    } catch (e) {
      print('❌ generateDescription Error: $e');
    }
    return null;
  }

  Future<String?> recommendPet({
    required String preferences,
  }) async {
    final url = Uri.parse('https://unuvarx.pythonanywhere.com/recommend-pet');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "preferences": preferences,
        }),
      );
      print("🟡 Recommend Pet → Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['recommendation'] as String?;
      }
    } catch (e) {
      print('❌ recommendPet Error: $e');
    }
    return null;
  }
}

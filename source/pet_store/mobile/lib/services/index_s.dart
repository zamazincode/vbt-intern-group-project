import 'package:mobile/core/Services/Manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  final ServiceManager _manager = ServiceManager();

  Future<String?> getAllPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print(' Token bulunamadı');
      return null;
    }

    final url = _manager.buildUri('post/GetAllPosts');
    final headers = _manager.getHeaders(token);

    try {
      final response = await _manager.client.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('❌ GetAllPosts Hata: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ GetAllPosts exception: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

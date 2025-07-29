import 'dart:convert';

import 'package:mobile/core/Services/Manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterService {
  final ServiceManager _manager = ServiceManager();

  Future<String> register(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final url = _manager.buildUri('user/Register');
    final token = prefs.getString('token');
    final headers = _manager.getHeaders(token);

    try {
      final response = await _manager.client.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return " Kayıt başarılı!";
      } else {
        return " Kayıt başarısız: ${response.body}";
      }
    } catch (e) {
      return " Kayıt sırasında hata oluştu: $e";
    }
  }
}

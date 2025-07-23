import 'dart:convert';
import 'package:http/http.dart' as http;
class RegisterService {
  static const String _baseUrl = 'https://petstoreapi.justkey.online/api/user/Register';

  static Future<String> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "Kayıt başarılı!";
    } else {
      return "Kayıt başarısız: ${response.body}";
    }
  }
}


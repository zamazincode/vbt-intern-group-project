import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl = 'https://petstoreapi.justkey.online/api/user/Login';

  static Future<Map<String, dynamic>> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userName": userName,
        "password": password,
      }),
    );
    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }
}


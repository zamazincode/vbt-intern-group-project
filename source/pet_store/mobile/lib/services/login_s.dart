import 'dart:convert';

import 'package:mobile/core/Services/Manager.dart';

class LoginService {
  final ServiceManager _manager = ServiceManager();

  Future<Map<String, dynamic>> login(String userName, String password) async {
    final url = _manager.buildUri('user/Login');
    final headers = _manager.getHeaders('application/json');

    try {
      final response = await _manager.client.post(
        url,
        headers: headers,
        body: jsonEncode({
          "userName": userName,
          "password": password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "body": responseBody,
      };
    } catch (e) {
      print('❌ Login error: $e');
      return {
        "statusCode": 500,
        "body": {"message": "Bir hata oluştu"}
      };
    }
  }
}

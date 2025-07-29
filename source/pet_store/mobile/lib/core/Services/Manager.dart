import 'package:http/http.dart' as http;

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  final String baseUrl = 'https://petstoreapi.justkey.online/api/';

  // Buraya header veya token gibi global ayarları koyabilirsin
  Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    return Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
  }

  // Tek bir client üzerinden işlem yapmak istiyorsan:
  final http.Client client = http.Client();
}

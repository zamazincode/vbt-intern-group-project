import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile/core/Services/Manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final ServiceManager _manager = ServiceManager();

  Future<List<dynamic>> getAllPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userStr = prefs.getString('user');
    String? userId;

    if (userStr != null) {
      final user = jsonDecode(userStr);
      userId = user['id']?.toString();
    }

    if (userId == null || userId.isEmpty) {
      print("❌ userId bulunamadı");
      return [];
    }

    final url = _manager.buildUri('post/GetPostsByUserId/$userId');
    final headers = _manager.getHeaders(token);

    final response = await _manager.client.get(url, headers: headers);
    print('📥 GetAllPosts response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'] ?? [];
    }

    return [];
  }

  Future<bool> deletePost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = _manager.buildUri('post/DeletePost/$postId');
    final headers = _manager.getHeaders(token);

    final response = await _manager.client.delete(url, headers: headers);
    print('🗑️ DeletePost response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isSuccess'] == true;
    }

    return false;
  }

  Future<Map<String, dynamic>?> getPostById(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = _manager.buildUri('post/GetPostById/$postId');
    final headers = _manager.getHeaders(token);

    final response = await _manager.client.get(url, headers: headers);
    print('📥 GetPostById response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    }

    return null;
  }

  Future<bool> updatePost(Map<String, dynamic> data, {File? imageFile, String? imageBase64}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = _manager.buildUri('post/UpdatePost');

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    final fields = {
      'PostId': data['postId']?.toString() ?? '',
      'UserId': data['userId']?.toString() ?? '',
      'User.Id': data['user']?['id']?.toString() ?? '',
      'User.Name': data['user']?['name']?.toString() ?? '',
      'User.Surname': data['user']?['surname']?.toString() ?? '-',
      'User.Email': data['user']?['email']?.toString() ?? '',
      'User.UserName': data['user']?['userName']?.toString() ?? '',
      'Title': data['title']?.toString() ?? '',
      'PetName': data['petName']?.toString() ?? '',
      'PetType': data['petType']?.toString() ?? '',
      'Description': data['description']?.toString() ?? '',
      'IsAdopted': data['isAdopted']?.toString() ?? 'false',
      'PostTime': data['postTime']?.toString() ?? '',
      'PostLatitude': data['postLatitude']?.toString() ?? '',
      'PostLongitude': data['postLongitude']?.toString() ?? '',
      'ImageUrl': data['imageUrl']?.toString() ?? '',
      'ImageLocalPath': data['imageLocalPath']?.toString() ?? '',
    };

    request.fields.addAll(fields);

    // Görsel ekle
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));
    } else if (imageBase64 != null && imageBase64.isNotEmpty) {
      final bytes = base64Decode(imageBase64);
      request.files.add(http.MultipartFile.fromBytes('Image', bytes, filename: 'image.jpg'));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('🔄 UpdatePost status: ${response.statusCode}');
    print('🔄 UpdatePost body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isSuccess'] == true;
    }

    return false;
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProfileService {
  static Future<List<dynamic>> getAllPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userStr = prefs.getString('user');
    String? userId;
    if (userStr != null) {
      final user = jsonDecode(userStr);
      userId = user['id'];
    }
    if (userId == null || userId.isEmpty) {
      print("userId bulunamadı");
      return [];
    }
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/GetPostsByUserId/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('RESPONSE : ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'] ?? [];
    }
    return [];
  }

  static Future<bool> deletePost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/DeletePost/$postId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('DELETE RESPONSE : ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isSuccess'] == true;
    }
    return false;
  }

  static Future<Map<String, dynamic>?> getPostById(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/GetPostById/$postId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('GET POST BY ID RESPONSE : ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    }
    return null;
  }

  static Future<bool> updatePost(Map<String, dynamic> data, {File? imageFile, String? imageBase64}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/UpdatePost');

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['PostId'] = data['postId']?.toString() ?? '';
    request.fields['UserId'] = data['userId']?.toString() ?? '';
    request.fields['User.Id'] = data['user']?['id']?.toString() ?? '';
    request.fields['User.Name'] = data['user']?['name']?.toString() ?? '';
    request.fields['User.Surname'] = data['user']?['surname']?.toString() ?? '-';
    request.fields['User.Email'] = data['user']?['email']?.toString() ?? '';
    request.fields['User.UserName'] = data['user']?['userName']?.toString() ?? '';
    request.fields['Title'] = data['title']?.toString() ?? '';
    request.fields['PetName'] = data['petName']?.toString() ?? '';
    request.fields['PetType'] = data['petType']?.toString() ?? '';
    request.fields['Description'] = data['description']?.toString() ?? '';
    request.fields['IsAdopted'] = data['isAdopted']?.toString() ?? 'false';
    request.fields['PostTime'] = data['postTime']?.toString() ?? '';
    request.fields['PostLatitude'] = data['postLatitude']?.toString() ?? '';
    request.fields['PostLongitude'] = data['postLongitude']?.toString() ?? '';
    request.fields['ImageUrl'] = data['imageUrl']?.toString() ?? '';
    request.fields['ImageLocalPath'] = data['imageLocalPath']?.toString() ?? '';

    // Resim dosyası ekle (öncelik imageFile, yoksa base64)
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));
    } else if (imageBase64 != null && imageBase64.isNotEmpty) {
      final bytes = base64Decode(imageBase64);
      request.files.add(http.MultipartFile.fromBytes('Image', bytes, filename: 'image.jpg'));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('UPDATE POST STATUS: ${response.statusCode}');
    print('UPDATE POST RESPONSE : ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isSuccess'] == true;
    }
    return false;
  }
}

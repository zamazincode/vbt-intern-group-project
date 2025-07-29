import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile/core/Services/Manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPetService {
  final ServiceManager _manager = ServiceManager();

  Future<http.Response> createPost(Map<String, dynamic> data, {File? imageFile}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = _manager.buildUri('post/CreatePost');
    final headers = _manager.getHeaders(token);

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    // Alanları ekle
    request.fields['UserId'] = data['userId'] ?? '';
    request.fields['User.Id'] = data['user']?['id'] ?? '';
    request.fields['User.Name'] = data['user']?['name'] ?? '';
    request.fields['User.Surname'] = data['user']?['surname'] ?? '';
    request.fields['User.Email'] = data['user']?['email'] ?? '';
    request.fields['User.UserName'] = data['user']?['userName'] ?? '';
    request.fields['Title'] = data['title'] ?? '';
    request.fields['PetName'] = data['petName'] ?? '';
    request.fields['PetType'] = data['petType'] ?? '';
    request.fields['Description'] = data['description'] ?? '';
    request.fields['IsAdopted'] = data['isAdopted']?.toString() ?? 'false';
    request.fields['PostTime'] = data['postTime'] ?? '';
    request.fields['PostLatitude'] = data['postLatitude']?.toString() ?? '';
    request.fields['PostLongitude'] = data['postLongitude']?.toString() ?? '';
    request.fields['ImageUrl'] = data['imageUrl'] ?? '';
    request.fields['ImageLocalPath'] = data['imageLocalPath'] ?? '';

    // Görseli dosya ya da base64 olarak ekle
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));
    } else if (data['image'] != null && data['image'].toString().isNotEmpty) {
      final bytes = base64Decode(data['image']);
      request.files.add(http.MultipartFile.fromBytes('Image', bytes, filename: 'image.jpg'));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return response;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AddPetService {
  static Future<http.Response> createPost(Map<String, dynamic> data, {File? imageFile}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://petstoreapi.justkey.online/api/post/CreatePost');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // Query parametreleri
    request.fields['UserId'] = data['userId'] ?? '';
    request.fields['User.Id'] = data['user']?['id'] ?? '';
    request.fields['User.Name'] = data['user']?['name'] ?? '';
    request.fields['User.Surname'] = data['user']?['surname'] ?? '';
    request.fields['User.Email'] = data['user']?['email'] ?? '';
    request.fields['User.UserName'] = data['user']?['userName'] ?? '';
    // User.Posts boş geçilebilir
    request.fields['Title'] = data['title'] ?? '';
    request.fields['PetName'] = data['petName'] ?? '';
    request.fields['PetType'] = data['petType'] ?? '';
    request.fields['Description'] = data['description'] ?? '';
    request.fields['IsAdopted'] = data['isAdopted'].toString();
    request.fields['PostTime'] = data['postTime'] ?? '';
    request.fields['PostLatitude'] = data['postLatitude']?.toString() ?? '';
    request.fields['PostLongitude'] = data['postLongitude']?.toString() ?? '';
    request.fields['ImageUrl'] = data['imageUrl'] ?? '';
    request.fields['ImageLocalPath'] = data['imageLocalPath'] ?? '';

    // Resim dosyası ekle
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));
    } else if (data['image'] != null && data['image'].toString().isNotEmpty) {
      // Eğer base64 varsa, dosya olarak ekle
      final bytes = base64Decode(data['image']);
      request.files.add(http.MultipartFile.fromBytes('Image', bytes, filename: 'image.jpg'));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('CreatePost response: ${response.body}'); // <-- response'u console'a yazdır
    return response;
  }
}

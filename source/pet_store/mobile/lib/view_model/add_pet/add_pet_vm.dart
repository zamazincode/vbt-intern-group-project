import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddPetViewModel extends ChangeNotifier {
  String userId = '';
  String userName = '';
  String userSurname = '-'; // <-- default tire
  String userEmail = '';
  String userUserName = '';
  String title = '';
  String petName = '';
  String petType = '';
  String description = '';
  bool isAdopted = false;
  DateTime? postTime;

  String imageUrl = '';
  String imageLocalPath = '';
  String? imageBase64;

  bool isLoading = false;

  Future<void> setUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      final user = jsonDecode(userStr);
      userId = user['id'] ?? '';
      userName = user['name'] ?? '';
      // Surname zorunluysa asla boş veya null olmasın, yoksa tire gönder
      userSurname = (user['surname'] == null || user['surname'].toString().trim().isEmpty) ? '-' : user['surname'];
      userEmail = user['email'] ?? '';
      userUserName = user['userName'] ?? '';
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Map<String, dynamic> toRequestBody() {
    return {
      "userId": userId,
      "user": {
        "id": userId,
        "name": userName,
        "surname": (userSurname.isEmpty || userSurname.trim().isEmpty) ? '-' : userSurname,
        "email": userEmail,
        "userName": userUserName,
        "posts": null
      },
      "title": title,
      "petName": petName,
      "petType": petType,
      "description": description,
      "isAdopted": isAdopted,
      "postTime": postTime?.toIso8601String() ?? "",
      "imageUrl": imageUrl,
      "imageLocalPath": imageLocalPath,
      "image": imageBase64,
    };
  }
}

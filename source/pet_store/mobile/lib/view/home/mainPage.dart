import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/section.dart';
import 'package:mobile/services/index_s.dart';
import 'package:mobile/view/user_auth/login.dart';
import 'package:mobile/view/user_auth/register.dart';
import 'package:mobile/view/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoggedIn = false;
  bool isLoading = true;
  List<dynamic> allPosts = [];
  List<Map<String, String>> catPosts = [];
  List<Map<String, String>> dogPosts = [];
  List<Map<String, String>> otherPosts = [];

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchAndSetPosts();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  Future<void> fetchAndSetPosts() async {
    final response = await PostService.getAllPosts();
    if (response != null) {
      final decoded = jsonDecode(response);
      final posts = decoded['result'] as List<dynamic>? ?? [];
      // Her postun petName'ini konsola yazdır
      for (final p in posts) {
        print('petName: ${p['petName']}');
      }
      setState(() {
        allPosts = posts;
        catPosts = posts
            .where((p) => (p['petType']?.toLowerCase() ?? '').contains('kedi'))
            .map<Map<String, String>>((p) => {
                  "imageUrl": p['imageUrl'] ?? "",
                  "petName": p['petName'] ?? "",
                  "postId": p['postId']?.toString() ?? "",
                })
            .toList();
        dogPosts = posts
            .where((p) => (p['petType']?.toLowerCase() ?? '').contains('köpek'))
            .map<Map<String, String>>((p) => {
                  "imageUrl": p['imageUrl'] ?? "",
                  "petName": p['petName'] ?? "",
                  "postId": p['postId']?.toString() ?? "",
                })
            .toList();
        otherPosts = posts
            .where((p) =>
                !(p['petType']?.toLowerCase() ?? '').contains('kedi') &&
                !(p['petType']?.toLowerCase() ?? '').contains('köpek'))
            .map<Map<String, String>>((p) => {
                  "imageUrl": p['imageUrl'] ?? "",
                  "petName": p['petName'] ?? "",
                  "postId": p['postId']?.toString() ?? "",
                })
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isLoggedIn
            ? IconButton(
                icon: const Icon(Icons.person, color: AppColors.white,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Profile()),
                  );
                },
              )
            : null,
        title: const Text("Pets"),
        backgroundColor: AppColors.yellow,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.white,),
              tooltip: 'Çıkış Yap',
              onPressed: () async {
                await PostService.logout();
                if (mounted) {
                  setState(() {
                    isLoggedIn = false;
                  });
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                "Giriş Yap",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 20),
                if (catPosts.isNotEmpty)
                  Section(title: "Kediler", items: catPosts),
                if (dogPosts.isNotEmpty)
                  Section(title: "Köpekler", items: dogPosts),
                if (otherPosts.isNotEmpty)
                  Section(title: "Diğerleri", items: otherPosts),
                if (catPosts.isEmpty && dogPosts.isEmpty && otherPosts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text("Hiç ilan bulunamadı."),
                    ),
                  ),
              ],
            ),
    );
  }
}

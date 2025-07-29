import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/section.dart';
import 'package:mobile/services/index_s.dart';
import 'package:mobile/services/pet_detail_s.dart';
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
    final postService = PostService();
    final response = await postService.getAllPosts();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("İlanlar yüklenemedi. Lütfen tekrar deneyin.")),
        );
      }
    }
  }

  void _showRecommendPetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final TextEditingController tercihController = TextEditingController();
        return _RecommendPetSheet(controller: tercihController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isLoggedIn
            ? IconButton(
                icon: const Icon(Icons.person, color: AppColors.white),
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
              icon: const Icon(Icons.logout, color: AppColors.white),
              tooltip: 'Çıkış Yap',
              onPressed: () async {
                final postService = PostService();
                await postService.logout();
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
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRecommendPetSheet(context),
                    icon: const Icon(Icons.smart_toy, color: AppColors.white),
                    label: const Text(
                      "Evcil Hayvan  Öner",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (catPosts.isNotEmpty) Section(title: "Kediler", items: catPosts),
                if (dogPosts.isNotEmpty) Section(title: "Köpekler", items: dogPosts),
                if (otherPosts.isNotEmpty) Section(title: "Diğerleri", items: otherPosts),
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

class _RecommendPetSheet extends StatefulWidget {
  final TextEditingController controller;
  const _RecommendPetSheet({required this.controller});

  @override
  State<_RecommendPetSheet> createState() => _RecommendPetSheetState();
}

class _RecommendPetSheetState extends State<_RecommendPetSheet> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _aiController;

  @override
  void initState() {
    super.initState();
    _aiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  Future<void> _handleRecommend() async {
    final tercih = widget.controller.text.trim();
    final petDetailService = PetDetailService();
    if (tercih.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    _aiController.repeat();
    final recommendation = await petDetailService.recommendPet(preferences: tercih);
    _aiController.stop();
    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Önerilen Evcil Hayvan"),
        content: Text(recommendation ?? "Bir öneri alınamadı."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Evcil Hayvan Tercihiniz",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              labelText: "Tercihinizi yazınız",
              border: OutlineInputBorder(),
            ),
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleRecommend,
              icon: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: RotationTransition(
                        turns: _aiController,
                        child: const Icon(Icons.smart_toy, color: AppColors.white, size: 24),
                      ),
                    )
                  : const Icon(Icons.smart_toy),
              label: _isLoading
                  ? const Text("Öneriliyor...", style: TextStyle(color: AppColors.white))
                  : const Text("Öner"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

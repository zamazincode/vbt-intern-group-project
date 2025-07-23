import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/section.dart';
import 'package:mobile/services/index_s.dart';
import 'package:mobile/view/user_auth/login.dart';
import 'package:mobile/view/user_auth/register.dart';
import 'package:mobile/view/profile/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final result = await PostService.getAllPosts();
    print('GetAllPost response: $result');
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> popularFoods = [
      {
        "imageUrl": "http://static.ticimax.cloud/53195/uploads/urunresimleri/buyuk/royal-canin-kitten-yavru-kedi-mamasi-4-7-bb43.jpg",
        "title": "Kedi Maması - Tavuklu"
      },
      {
        "imageUrl": "http://static.ticimax.cloud/53195/uploads/urunresimleri/buyuk/royal-canin-kitten-yavru-kedi-mamasi-4-7-bb43.jpg",
        "title": "Köpek Maması - Somonlu"
      },
      {
        "imageUrl": "http://static.ticimax.cloud/53195/uploads/urunresimleri/buyuk/royal-canin-kitten-yavru-kedi-mamasi-4-7-bb43.jpg",
        "title": "Kedi Maması - Karışık"
      },
    ];

    final List<Map<String, String>> recommendedToys = [
      {
        "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAUa-HtLhBDbPVk6Z3WujIia8blQIfeGc4_Q&s",
        "title": "Kedi Oyuncağı - Fare"
      },
      {
        "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAUa-HtLhBDbPVk6Z3WujIia8blQIfeGc4_Q&s",
        "title": "Köpek Oyuncağı - Halat"
      },
    ];

    final List<Map<String, String>> bestAccessories = [
      {
        "imageUrl": "https://static.ticimax.cloud/cdn-cgi/image/width=-,quality=85/55900/uploads/urunresimleri/buyuk/petcraft-deri-kedi-tasma-420a5f..png",
        "title": "Kedi Tasması - Zilli"
      },
      {
        "imageUrl": "https://static.ticimax.cloud/cdn-cgi/image/width=-,quality=85/55900/uploads/urunresimleri/buyuk/petcraft-deri-kedi-tasma-420a5f..png",
        "title": "Köpek Tasması - Ayarlanabilir"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Profile()),
            );
          },
        ),
        title: const Text("Pets"),
        backgroundColor: AppColors.yellow,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Section(title: "Popüler Mamalar", items: popularFoods),
          Section(title: "Senin İçin Seçilen Oyuncaklar", items: recommendedToys),
          Section(title: "En Çok Satan Aksesuarlar", items: bestAccessories),
        ],
      ),
    );
  }
}

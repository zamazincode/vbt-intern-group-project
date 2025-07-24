import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

class PetDetail extends StatelessWidget {
  final Map<String, dynamic> postData;

  const PetDetail({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final user = postData['user'];
    return Scaffold(
      appBar: AppBar(
        title: Text(postData['petName'] ?? 'Pet Detay'),
        backgroundColor: AppColors.yellow,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (postData['imageUrl'] != null && postData['imageUrl'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  postData['imageUrl'],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.pets, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              postData['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text("Ad: ${postData['petName'] ?? ''}", style: const TextStyle(fontSize: 18)),
            Text("Tür: ${postData['petType'] ?? ''}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Açıklama: ${postData['description'] ?? ''}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Sahiplendirildi mi: ${postData['isAdopted'] == true ? 'Evet' : 'Hayır'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Eklenme Tarihi: ${postData['postTime'] ?? ''}", style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            if (user != null) ...[
              const Divider(),
              const Text(
                "Sahip Bilgileri",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text("Ad Soyad: ${user['name'] ?? ''} ${user['surname'] ?? ''}", style: const TextStyle(fontSize: 16)),
              Text("Kullanıcı Adı: ${user['userName'] ?? ''}", style: const TextStyle(fontSize: 16)),
              Text("E-posta: ${user['email'] ?? ''}", style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}

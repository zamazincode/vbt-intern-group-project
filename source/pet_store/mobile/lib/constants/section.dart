import 'package:flutter/material.dart';
import 'package:mobile/view/home/cards/productCard.dart';
import 'package:mobile/services/pet_detail_s.dart';
import 'package:mobile/view/pet_detail/pet_detail.dart';

class Section extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const Section({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 295,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ProductCard(
                imageUrl: item['imageUrl'] ?? '',
                petName: item['petName'] ?? '',
                onAdopt: () {},
                onTap: () async {
                  final postIdStr = item['postId'];
                  if (postIdStr == null) return;
                  final postId = int.tryParse(postIdStr);
                  if (postId == null) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  final petDetailService = PetDetailService();
                  final postDetail = await petDetailService.getPostById(postId);

                  Navigator.of(context).pop();

                  if (postDetail != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetDetail(postData: postDetail),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pet detayları alınamadı!")),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

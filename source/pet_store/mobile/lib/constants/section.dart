import 'package:flutter/material.dart';
import 'package:pet_store/view/home/cards/productCard.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ProductCard(
                  imageUrl: product["imageUrl"]!,
                  title: product["title"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

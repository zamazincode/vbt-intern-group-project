import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellow,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.png',
              image: imageUrl,
              width: 280,
              height: 200,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) => Container(
                width: 280,
                height: 200,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

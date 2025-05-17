import 'package:flutter/material.dart';
import '../models/product_item_model.dart';

class ProductItemCard extends StatelessWidget {
  final ProductItemModel productItem;

  const ProductItemCard({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: productItem.imagePath != null && productItem.imagePath!.isNotEmpty
            ? Image.asset(productItem.imagePath!, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported),
        title: Text(productItem.title),
        subtitle: Text(productItem.description),
      ),
    );
  }
}
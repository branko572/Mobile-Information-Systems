import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class MealGridItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealGridItem({required this.meal, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: meal.thumbnail,
                fit: BoxFit.cover,
                placeholder: (c, s) => Center(child: CircularProgressIndicator()),
                errorWidget: (c, s, e) => Icon(Icons.broken_image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

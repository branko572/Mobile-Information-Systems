import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealCard extends StatefulWidget {
  final Meal meal;

  const MealCard({Key? key, required this.meal}) : super(key: key);

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _toggleFavorite() async {
    setState(() {
      widget.meal.isFavorite = !widget.meal.isFavorite;
    });
    await _firestore
        .collection('favorites_recipes')
        .doc(widget.meal.id)
        .set({'isFavorite': widget.meal.isFavorite});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.meal.imageUrl,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          ListTile(
            title: Text(widget.meal.name),
            trailing: IconButton(
              icon: Icon(
                widget.meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId, Key? key}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  late Future<MealDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = api.fetchMealDetail(widget.mealId);
  }

  void _openYoutube(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);


    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не може да се отвори YouTube')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепт'),
      ),
      body: FutureBuilder<MealDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final meal = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: meal.thumbnail,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: (c, s) => Center(child: CircularProgressIndicator()),
                ),
                SizedBox(height: 12),
                Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 8),
                Text('Категорија: ${meal.category} • Порекло: ${meal.area}'),
                SizedBox(height: 12),
                Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 6),
                Text(meal.instructions),
                SizedBox(height: 12),
                Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 6),
                ...meal.ingredients.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text('- ${e.key} : ${e.value}'),
                )),
                SizedBox(height: 12),
                if (meal.youtube.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _openYoutube(meal.youtube),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Отвори YouTube'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

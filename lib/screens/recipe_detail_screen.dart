import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'add_edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditRecipeScreen(recipe: recipe),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<RecipeProvider>(context, listen: false)
                  .deleteRecipe(recipe.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imagePath != null) Image.file(File(recipe.imagePath!)),
            SizedBox(height: 8.0),
            Text(
              recipe.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Category: ${recipe.category}',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            for (var ingredient in recipe.ingredients) Text('- $ingredient'),
            SizedBox(height: 8.0),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(recipe.instructions),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'Rating: ${recipe.rating ?? 'Not rated yet'}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    recipe.isFavorite = !recipe.isFavorite;
                    Provider.of<RecipeProvider>(context, listen: false)
                        .updateRecipe(recipe);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

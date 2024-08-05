import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  AddEditRecipeScreen({this.recipe});

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late List<String> _ingredients;
  late String _instructions;
  String? _imagePath;
  late String _category;
  double? _rating;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _title = widget.recipe!.title;
      _ingredients = widget.recipe!.ingredients;
      _instructions = widget.recipe!.instructions;
      _imagePath = widget.recipe!.imagePath;
      _category = widget.recipe!.category;
      _rating = widget.recipe!.rating;
    } else {
      _title = '';
      _ingredients = [];
      _instructions = '';
      _category = 'Breakfast';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe != null ? 'Edit Recipe' : 'Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _ingredients.join(', '),
                decoration:
                    InputDecoration(labelText: 'Ingredients (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ingredients = value!.split(', ');
                },
              ),
              TextFormField(
                initialValue: _instructions,
                decoration: InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
                onSaved: (value) {
                  _instructions = value!;
                },
                maxLines: 4,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                items: ['Breakfast', 'Lunch', 'Dinner', 'Desserts']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              SizedBox(height: 8.0),
              _imagePath != null ? Image.file(File(_imagePath!)) : Container(),
              TextButton(
                child: Text('Pick an image'),
                onPressed: _pickImage,
              ),
              if (widget.recipe != null)
                Column(
                  children: [
                    TextFormField(
                      initialValue: _rating?.toString(),
                      decoration: InputDecoration(labelText: 'Rating'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a rating';
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 5) {
                          return 'Please enter a valid rating (0-5)';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _rating = double.parse(value!);
                      },
                    ),
                    Row(
                      children: [
                        Text('Favorite:'),
                        Checkbox(
                          value: widget.recipe!.isFavorite,
                          onChanged: (value) {
                            setState(() {
                              widget.recipe!.isFavorite = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(
                    widget.recipe != null ? 'Update Recipe' : 'Add Recipe'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newRecipe = Recipe(
                      id: widget.recipe?.id,
                      title: _title,
                      ingredients: _ingredients,
                      instructions: _instructions,
                      imagePath: _imagePath,
                      category: _category,
                      rating: _rating,
                      isFavorite: widget.recipe?.isFavorite ?? false,
                    );
                    if (widget.recipe != null) {
                      Provider.of<RecipeProvider>(context, listen: false)
                          .updateRecipe(newRecipe);
                    } else {
                      Provider.of<RecipeProvider>(context, listen: false)
                          .addRecipe(newRecipe);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

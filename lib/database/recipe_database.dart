import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/recipe.dart';

class RecipeDatabase {
  static final RecipeDatabase instance = RecipeDatabase._init();

  static Database? _database;

  RecipeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const doubleType = 'REAL';

    await db.execute('''
    CREATE TABLE recipes (
      id $idType,
      title $textType,
      ingredients $textType,
      instructions $textType,
      imagePath TEXT,
      category $textType,
      rating $doubleType,
      isFavorite $boolType
    )
    ''');
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert('recipes', recipe.toMap());
  }

  Future<List<Recipe>> fetchAllRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes');

    if (maps.isNotEmpty) {
      return maps.map((map) => Recipe.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final db = await instance.database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

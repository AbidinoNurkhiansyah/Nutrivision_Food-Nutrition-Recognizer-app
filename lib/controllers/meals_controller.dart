import 'package:flutter/material.dart';
import '../models/meals_response.dart';
import '../models/nutrition.dart';
import '../services/gemini_service.dart';
import '../services/meals_api_service.dart';

class MealsController extends ChangeNotifier {
  final MealApiService _mealApiService;
  final GeminiService _geminiService;
  MealsController(this._mealApiService, this._geminiService);

  List<Meal>? _meals;
  List<Meal>? get meals => _meals;

  bool isLoading = false;

  Future<void> getMealByName(String name) async {
    try {
      isLoading = true;
      notifyListeners();
      print('get meal by name $name');
      final response = await _mealApiService.searchMeal(name);

      // if (response != null || response!.meals!.isNotEmpty) {
      _meals = response?.meals;
      // }

      // fallback: kalau hasil kosong, coba huruf besar pertama
      if (_meals!.isEmpty) {
        final altResponse = await _mealApiService.searchMeal(
          name[0].toUpperCase() + name.substring(1),
        );
        _meals = altResponse?.meals ?? [];
      }
    } catch (e) {
      debugPrint('Err get meal $e');
    } finally {
      print('meals $_meals');
      isLoading = false;
      notifyListeners();
    }
  }

  Nutrition? _mealNutrition;
  Nutrition? get mealNutrition => _mealNutrition;

  Future<void> getMealNutritionByName(String name) async {
    try {
      final response = await _geminiService.getNutrition(name);

      if (response != null) {
        _mealNutrition = response;
      }
    } catch (e) {
      debugPrint('Err get meal nutrition $e');
    } finally {
      notifyListeners();
    }
  }
}

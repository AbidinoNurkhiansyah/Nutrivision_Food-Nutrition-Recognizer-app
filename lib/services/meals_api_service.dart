import 'dart:convert';
import 'package:flutter/widgets.dart';
import '../models/meals_response.dart';
import 'package:http/http.dart' as http;

class MealApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<MealsResponse?> searchMeal(String query) async {
    final url = Uri.parse("$baseUrl/search.php?s=$query");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MealsResponse.fromJson(data);
      } else {
        debugPrint("❌ Request gagal. Code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetch data: $e");
    }
    return null;
  }
}

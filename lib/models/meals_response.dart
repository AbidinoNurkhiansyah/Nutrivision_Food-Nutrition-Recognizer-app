class MealsResponse {
  final List<Meal>? meals;

  MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'];
    if (mealsJson == null) {
      return MealsResponse(meals: []);
    }
    return MealsResponse(
      meals: (mealsJson as List)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Meal {
  final String idMeal;
  final String strMeal;
  final String? strMealAlternate;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<String?> ingredients;
  final List<String?> measures;
  final String? strSource;
  final String? strImageSource;
  final String? strCreativeCommonsConfirmed;
  final String? dateModified;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strMealAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // ambil ingredient & measure (max 20)
    List<String?> ingredients = [];
    List<String?> measures = [];
    for (int i = 1; i <= 20; i++) {
      ingredients.add(json['strIngredient$i']);
      measures.add(json['strMeasure$i']);
    }

    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealAlternate: json['strMealAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
      strSource: json['strSource'],
      strImageSource: json['strImageSource'],
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'],
      dateModified: json['dateModified'],
    );
  }

  List<Map<String, String>> get ingredientWithMeasure {
    List<Map<String, String>> list = [];
    for (int i = 0; i < ingredients.length; i++) {
      final ing = ingredients[i];
      final mea = measures[i];
      if (ing != null && ing.isNotEmpty) {
        list.add({"ingredient": ing, "measure": mea ?? ""});
      }
    }
    return list;
  }
}

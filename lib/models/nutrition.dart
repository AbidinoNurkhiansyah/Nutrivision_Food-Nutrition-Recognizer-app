class Nutrition {
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final int fiber;

  Nutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'] ?? 0,
      carbs: json['carbs'] ?? 0,
      protein: json['protein'] ?? 0,
      fat: json['fat'] ?? 0,
      fiber: json['fiber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "calories": calories,
      "carbs": carbs,
      "protein": protein,
      "fat": fat,
      "fiber": fiber,
    };
  }
}

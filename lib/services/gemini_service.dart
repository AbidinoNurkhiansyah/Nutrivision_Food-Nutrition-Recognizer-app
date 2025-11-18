import 'dart:convert';

import 'package:food_recognizer_app/env/env.dart';

import '../models/nutrition.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = Env.geminiApiKey;
    final modelGenerationConfig = GenerationConfig(
      temperature: 0,
      responseMimeType: 'application/json',
      responseSchema: Schema(
        SchemaType.object,
        requiredProperties: ["nutrition"],
        properties: {
          "nutrition": Schema(
            SchemaType.object,
            requiredProperties: [
              "calories",
              "carbs",
              "protein",
              "fat",
              "fiber",
            ],
            properties: {
              "calories": Schema(SchemaType.integer),
              "carbs": Schema(SchemaType.integer),
              "protein": Schema(SchemaType.integer),
              "fat": Schema(SchemaType.integer),
              "fiber": Schema(SchemaType.integer),
            },
          ),
        },
      ),
    );

    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: modelGenerationConfig,
      systemInstruction: Content.system(
        "Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau kandungan gizi pada makanan layaknya uji laboratorium makanan. "
        "Hal yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, dan protein pada makanan. "
        "Satuan dari indikator tersebut berupa gram.",
      ),
    );
  }

  Future<Nutrition?> getNutrition(String foodName) async {
    final prompt = "Nama makanannya adalah $foodName.";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(response.text!);

      return Nutrition.fromJson(json['nutrition']);
    } catch (_) {
      return null;
    }
  }
}

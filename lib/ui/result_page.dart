import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../controllers/lite_rt_controller.dart';
import '../controllers/meals_controller.dart';
import '../models/meals_response.dart';
import '../widgets/classification_item.dart';
import '../widgets/expandable_list.dart';
import '../widgets/expanded_text.dart';
import '../widgets/loading_custom_widget.dart';
import '../widgets/powered_by_gemini.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: _ResultBody());
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody();

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody>
    with TickerProviderStateMixin {
  String? foodName;
  double? confidence;
  File? imageReference;
  bool expanded = false;

  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    Future.microtask(() {
      foodName = context.read<LiteRtController>().food;
      confidence = context.read<LiteRtController>().confidence;
      imageReference = context.read<HomeController>().imageFile;
      if (foodName != null) {
        context.read<MealsController>().getMealByName(foodName!).then((_) {
          context.read<MealsController>().getMealNutritionByName(foodName!);
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<MealsController>(
        builder: (context, value, _) {
          Meal? firstMeal = value.meals?.first;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromRGBO(155, 37, 98, 1),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: () {
                    if (value.isLoading) return LoadingCustomWidget();

                    if (firstMeal?.strMealThumb != null &&
                        firstMeal!.strMealThumb!.isNotEmpty) {
                      return Image.network(
                        firstMeal.strMealThumb!,
                        fit: BoxFit.cover,
                      );
                    }

                    final imageFile = context.read<HomeController>().imageFile;
                    if (imageFile != null) {
                      return Image.file(imageFile, fit: BoxFit.cover);
                    }

                    return Container(
                      color: Colors.white,
                      child: const Center(child: Text('Image Not Found')),
                    );
                  }(),
                ),
              ),
            ],

            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClassificatioinItem(
                    item: foodName ?? '-',
                    value: "${((confidence ?? 0) * 100).toStringAsFixed(2)} %",
                  ),
                ),

                TabBar(
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  automaticIndicatorColorAdjustment: true,
                  indicatorColor: Colors.green,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: "Detail"),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Tab(text: "Nutrition"),
                        ScaleTransition(
                          scale: Tween(begin: 0.9, end: 1.1).animate(
                            CurvedAnimation(
                              parent: controller,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Google-gemini-icon.svg/1024px-Google-gemini-icon.svg.png?20240826133250",
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                dense: true,
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image:
                                        context
                                                .read<HomeController>()
                                                .imageFile !=
                                            null
                                        ? DecorationImage(
                                            image: FileImage(
                                              context
                                                  .read<HomeController>()
                                                  .imageFile!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                                title: Text(
                                  firstMeal?.strMeal ?? foodName ?? '-',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.deepOrangeAccent,
                                      ),
                                ),
                                subtitle: Text(
                                  'Image Reference',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              if (firstMeal != null)
                                Text(
                                  'Ingredients',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.green),
                                ),

                              if (value.isLoading)
                                LoadingCustomWidget()
                              else if (firstMeal?.ingredientWithMeasure !=
                                      null &&
                                  firstMeal!.ingredientWithMeasure.isNotEmpty)
                                ExpandableList(
                                  initialItemCount: 5,
                                  children: firstMeal.ingredientWithMeasure.map(
                                    (item) {
                                      return _titleValueRowSPBW(
                                        item['ingredient']!,
                                        item['measure']!,
                                        isGrams: false,
                                      );
                                    },
                                  ).toList(),
                                ),
                              const SizedBox(height: 12),
                              if (firstMeal != null)
                                Text(
                                  'Instruction',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.green),
                                ),
                              if (value.isLoading)
                                LoadingCustomWidget()
                              else
                                ExpandableText(
                                  text: firstMeal?.strInstructions ?? '',
                                  maxLines: 5,
                                ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange[100],
                                ),
                                child: Text(
                                  "Nutrition facts about ${foodName ?? '-'}",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(color: Colors.orange[500]),
                                ),
                              ),

                              SizedBox(height: 8),
                              _titleValueRowSPBW(
                                'Calories',
                                '${value.mealNutrition?.calories}',
                              ),
                              _titleValueRowSPBW(
                                'Carbs',
                                '${value.mealNutrition?.carbs}',
                              ),
                              _titleValueRowSPBW(
                                'Fat',
                                '${value.mealNutrition?.fat}',
                              ),
                              _titleValueRowSPBW(
                                'Fiber',
                                '${value.mealNutrition?.fiber}',
                              ),
                              _titleValueRowSPBW(
                                'Protein',
                                '${value.mealNutrition?.protein}',
                              ),

                              PoweredByGemini(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _titleValueRowSPBW(String title, String value, {bool isGrams = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '$value ${isGrams ? 'g' : ''}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

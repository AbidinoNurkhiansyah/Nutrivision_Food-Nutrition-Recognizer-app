import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/home_controller.dart';
import 'controllers/lite_rt_controller.dart';
import 'controllers/meals_controller.dart';
import 'firebase_options.dart';
import 'services/firebase_ml_service.dart';
import 'services/gemini_service.dart';
import 'services/image_classification_service.dart';
import 'services/meals_api_service.dart';
import 'ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseMlService()),
        Provider(create: (context) => MealApiService()),
        Provider(create: (context) => GeminiService()),
        Provider(
          create: (context) =>
              ImageClassificationService(context.read())
                ..initImageClassificationService(),
        ),

        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(
          create: (context) => LiteRtController(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => MealsController(context.read(), context.read()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff00a572)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import '../services/image_classification_service.dart';
import '../ui/not_predicted_page.dart';
import '../ui/result_page.dart';

class LiteRtController extends ChangeNotifier {
  final ImageClassificationService service;
  LiteRtController(this.service);

  String? _food; //nama makanan hasil prediksi
  String? get food => _food;

  double? _confidence; //tingkat kepercayaan model (confidence score)
  double? get confidence => _confidence;

  void runInference(File image, BuildContext context) async {
    final best = await service.inferenceImage(image);

    _food = best.key;
    _confidence = best.value;
    notifyListeners();
    print('food $_food confidence $confidence');
    goToPage(context);
  }

  void goToPage(BuildContext context) {
    if (_food == null || _food!.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotPredictedPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage()),
      );
    }
  }

  void close() => service.close();
}

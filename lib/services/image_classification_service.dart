import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'firebase_ml_service.dart';
import 'isolate_inference.dart';

class ImageClassificationService {
  final FirebaseMlService _mlService;
  ImageClassificationService(this._mlService);

  final labelPath = 'assets/probability-labels-en.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  late final File modelFile;

  Future<void> initImageClassificationService() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<void> _loadModel() async {
    modelFile = await _mlService.loadModel();

    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    interpreter = Interpreter.fromFile(modelFile, options: options);

    inputTensor = interpreter.getInputTensors().first;

    outputTensor = interpreter.getOutputTensors().first;
    log('Interpreter successfully');
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelPath);
    labels = labelTxt.split('\n');
  }

  Future<MapEntry<String, double>> inferenceImage(File image) async {
    var isolateModel = InferenceModel(
      image,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      isolateModel..responsePort = responsePort.sendPort,
    );
    final result = await responsePort.first as Map<String, double>;

    final bestPredict = result.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    double maxScore = bestPredict.value;
    double avgScore = result.values.reduce((a, b) => a + b) / result.length;

    log('outputFormat: $bestPredict (after)');
    log('outputFormat: $result');
    if (maxScore < 0.3 || (result.length > 1 && (maxScore - avgScore) < 0.05)) {
      return MapEntry('', 0.0);
    }

    return bestPredict;
  }

  void close() {
    interpreter.close();
  }
}

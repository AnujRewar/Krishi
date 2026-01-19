import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';

class MLResult {
  final String crop;
  final double confidence;

  MLResult({required this.crop, required this.confidence});
}

class CropMLModel {
  late Interpreter _interpreter;
  late Map<int, String> _labels;
  bool _loaded = false;

  Future<void> loadModel() async {
    try {
      debugPrint("STEP 1: Loading TFLite model...");
      _interpreter = await Interpreter.fromAsset('assets/crop_model.tflite');

      debugPrint("STEP 2: Model loaded");

      debugPrint("STEP 3: Loading labels.json...");
      final labelData = await rootBundle.loadString('assets/labels.json');
      debugPrint("STEP 4: labels.json loaded");

      final decoded = json.decode(labelData) as Map<String, dynamic>;
      _labels = decoded.map((k, v) => MapEntry(int.parse(k), v));

      _loaded = true;
      debugPrint("STEP 5: Model fully ready");
    } catch (e) {
      debugPrint("❌ MODEL LOAD ERROR: $e");
      rethrow;
    }
  }

  MLResult predict(List<double> input) {
    if (!_loaded) {
      throw Exception('Model not loaded');
    }

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter.run([input], output);

    final probs = output[0];
    final maxIndex = probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

    return MLResult(
      crop: _labels[maxIndex]!,
      confidence: probs[maxIndex] * 100,
    );
  }

  void dispose() {
    if (_loaded) {
      _interpreter.close();
    }
  }
}

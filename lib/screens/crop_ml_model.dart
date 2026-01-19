import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLResult {
  final String crop;
  final double confidence;

  MLResult({required this.crop, required this.confidence});
}

class CropMLModel {
  late Interpreter _interpreter;
  late Map<int, String> _labels;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;

    _interpreter = await Interpreter.fromAsset('crop_model.tflite');

    final labelData = await rootBundle.loadString('assets/labels.json');
    final decoded = json.decode(labelData) as Map<String, dynamic>;

    _labels = decoded.map((k, v) => MapEntry(int.parse(k), v));

    _loaded = true;
  }

  MLResult predict(List<double> input) {
    final output =
        List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter.run([input], output);

    final probs = output[0];
    final maxIndex =
        probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

    return MLResult(
      crop: _labels[maxIndex]!,
      confidence: probs[maxIndex] * 100,
    );
  }

  void dispose() {
    _interpreter.close();
  }
}

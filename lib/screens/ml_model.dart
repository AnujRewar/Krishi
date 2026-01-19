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

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('crop_model.tflite');

    final labelData = await rootBundle.loadString('assets/labels.json');
    final decoded = json.decode(labelData) as Map<String, dynamic>;

    _labels = decoded.map((k, v) => MapEntry(int.parse(k), v));
  }

  MLResult predict({
    required double soilPH,
    required double temperature,
    required double rainfall,
  }) {
    // IMPORTANT: Must match Python training order
    final input = [
      90.0, // Nitrogen
      42.0, // Phosphorus
      43.0, // Potassium
      temperature,
      65.0, // Humidity (mock for now)
      soilPH,
      rainfall,
    ];

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
}

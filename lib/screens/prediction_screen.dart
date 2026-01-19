import 'package:flutter/material.dart';
import 'crop_ml_model.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // 7 INPUT CONTROLLERS (matches ML model exactly)
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _soilPHController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  final CropMLModel _model = CropMLModel();
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _model.load();
    setState(() => _modelLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Prediction'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: !_modelLoaded
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Soil & Climate Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _field(
                            'Nitrogen (N)',
                            'e.g. 90',
                            _nitrogenController,
                          ),
                          const SizedBox(height: 12),

                          _field(
                            'Phosphorus (P)',
                            'e.g. 42',
                            _phosphorusController,
                          ),
                          const SizedBox(height: 12),

                          _field(
                            'Potassium (K)',
                            'e.g. 43',
                            _potassiumController,
                          ),
                          const SizedBox(height: 12),

                          _field(
                            'Temperature (°C)',
                            'e.g. 25',
                            _temperatureController,
                          ),
                          const SizedBox(height: 12),

                          _field(
                            'Humidity (%)',
                            'e.g. 65',
                            _humidityController,
                          ),
                          const SizedBox(height: 12),

                          _field('Soil pH', 'e.g. 6.5', _soilPHController),
                          const SizedBox(height: 12),

                          _field(
                            'Rainfall (mm)',
                            'e.g. 500',
                            _rainfallController,
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: _onPredictPressed,
                            icon: const Icon(Icons.analytics),
                            label: const Text('Predict Crop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _field(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _onPredictPressed() async {
    final input = [
      double.tryParse(_nitrogenController.text) ?? 0,
      double.tryParse(_phosphorusController.text) ?? 0,
      double.tryParse(_potassiumController.text) ?? 0,
      double.tryParse(_temperatureController.text) ?? 0,
      double.tryParse(_humidityController.text) ?? 0,
      double.tryParse(_soilPHController.text) ?? 0,
      double.tryParse(_rainfallController.text) ?? 0,
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = _model.predict(input);

    if (context.mounted) Navigator.pop(context);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Prediction Result'),
          content: Text(
            'Recommended Crop: ${result.crop}\n'
            'Confidence: ${result.confidence.toStringAsFixed(1)}%',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

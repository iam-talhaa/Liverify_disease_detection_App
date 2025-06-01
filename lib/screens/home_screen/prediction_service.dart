import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionService {
  Future<double> predict(Map<String, dynamic> inputData) async {
    Future<void> saveInputs(Map<String, dynamic> data) async {
      final prefs = await SharedPreferences.getInstance();
      for (var entry in data.entries) {
        prefs.setDouble(entry.key, entry.value);
      }
    }

    await saveInputs(inputData);
    final interpreter = await Interpreter.fromAsset('assets/ann_model.tflite');

    // Prepare input in the required format: 1x10 matrix
    final input = [
      [
        (inputData['Age'] - 50.39) / 17.64,
        (inputData['Gender'] - 0.50) / 0.50,
        (inputData['BMI'] - 27.70) / 7.21,
        (inputData['AlcoholConsumption'] - 9.83) / 5.76,
        (inputData['Smoking'] - 0.29) / 0.45,
        (inputData['GeneticRisk'] - 0.52) / 0.67,
        (inputData['PhysicalActivity'] - 5.00) / 2.85,
        (inputData['Diabetes'] - 0.14) / 0.35,
        (inputData['Hypertension'] - 0.15) / 0.36,
        (inputData['LiverFunctionTest'] - 59.86) / 22.99,
      ],
    ];

    // Output: 1 value for binary classification
    var output = List.filled(1 * 1, 0.0).reshape([1, 1]);

    // Run inference
    interpreter.run(input, output);

    return output[0][0];
  }

  Future<Map<String, double>> loadInputs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = [
      'Age',
      'Gender',
      'BMI',
      'AlcoholConsumption',
      'Smoking',
      'GeneticRisk',
      'PhysicalActivity',
      'Diabetes',
      'Hypertension',
      'LiverFunctionTest',
    ];

    return {for (var key in keys) key: prefs.getDouble(key) ?? 0.0};
  }
}

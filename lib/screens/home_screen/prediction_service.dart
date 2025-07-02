import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionService {
  Future<double> predict(Map<String, dynamic> inputData) async {
    // Normalize field names (e.g. 'Age Testing' -> 'Age')
    final normalizedInput = {
      'Age': inputData['Age Testing'] ?? inputData['Age'] ?? 0.0,
      'Gender': inputData['Gender'] ?? 0.0,
      'BMI': inputData['BMI'] ?? 0.0,
      'AlcoholConsumption': inputData['AlcoholConsumption'] ?? 0.0,
      'Smoking': inputData['Smoking'] ?? 0.0,
      'GeneticRisk': inputData['GeneticRisk'] ?? 0.0,
      'PhysicalActivity': inputData['PhysicalActivity'] ?? 0.0,
      'Diabetes': inputData['Diabetes'] ?? 0.0,
      'Hypertension': inputData['Hypertension'] ?? 0.0,
      'LiverFunctionTest': inputData['LiverFunctionTest'] ?? 0.0,
    };

    // Save inputs to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    for (var entry in normalizedInput.entries) {
      prefs.setDouble(entry.key, entry.value);
    }

    // Load TFLite model
    final interpreter = await Interpreter.fromAsset('assets/ann_model.tflite');

    // Normalize input values
    final input = [
      [
        (normalizedInput['Age']! - 50.39) / 17.64,
        (normalizedInput['Gender']! - 0.50) / 0.50,
        (normalizedInput['BMI']! - 27.70) / 7.21,
        (normalizedInput['AlcoholConsumption']! - 9.83) / 5.76,
        (normalizedInput['Smoking']! - 0.29) / 0.45,
        (normalizedInput['GeneticRisk']! - 0.52) / 0.67,
        (normalizedInput['PhysicalActivity']! - 5.00) / 2.85,
        (normalizedInput['Diabetes']! - 0.14) / 0.35,
        (normalizedInput['Hypertension']! - 0.15) / 0.36,
        (normalizedInput['LiverFunctionTest']! - 59.86) / 22.99,
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

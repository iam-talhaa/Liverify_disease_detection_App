import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/custom_widgets/custom_button.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';
import 'package:liverify_disease_detection/screens/home_screen/prediction_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {};
  final Map<String, dynamic> inputData = {};
  String result = '';
  double? _probability;

  // Dropdown values
  String? genderValue;
  String? smokingValue;
  String? geneticRiskValue;
  String? diabetesValue;
  String? hypertensionValue;

  // Define ranges for validation
  final Map<String, Map<String, dynamic>> textFields = {
    'Age Testing': {
      'type': TextInputType.number,
      'icon': Icons.calendar_today,
      'min': 10,
      'max': 100,
    },
    'BMI': {
      'type': TextInputType.number,
      'icon': Icons.fitness_center,
      'min': 10,
      'max': 50,
    },
    'AlcoholConsumption': {
      'type': TextInputType.number,
      'icon': Icons.wine_bar,
      'min': 0,
      'max': 20,
    },
    'PhysicalActivity': {
      'type': TextInputType.number,
      'icon': Icons.directions_run,
      'min': 0,
      'max': 10,
    },
    'LiverFunctionTest': {
      'type': TextInputType.number,
      'icon': Icons.science,
      'min': null,
      'max': null,
    },
  };

  final Map<String, Map<String, dynamic>> dropdownFields = {
    'Gender': {'icon': Icons.person},
    'Smoking': {'icon': Icons.smoking_rooms},
    'GeneticRisk': {'icon': Icons.family_restroom},
    'Diabetes': {'icon': Icons.bloodtype},
    'Hypertension': {'icon': Icons.favorite},
  };

  @override
  void initState() {
    super.initState();
    for (var key in textFields.keys) {
      controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image(
                height: 66,
                image:
                    result == "No Disease"
                        ? const AssetImage('assets/check.png')
                        : const AssetImage('assets/warning.png'),
              ),
              const SizedBox(width: 5),
              Text(
                result == "No Disease" ? "Alright" : "Warning",
                style: TextStyle(
                  fontSize: 30,
                  color: result == "No Disease" ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result == "No Disease"
                      ? "No Liver Disease Detected"
                      : "Non-Alchoholic Fatty Liver Disease Detected",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_probability != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Probability: ${(_probability! * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearAllFields() {
    controllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {
      genderValue = null;
      smokingValue = null;
      geneticRiskValue = null;
      diabetesValue = null;
      hypertensionValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB8CFCE),
      appBar: AppBar(
        title: Row(
          children: [
            const Image(height: 37, image: AssetImage('assets/liver_logo.png')),
            Text(
              'Liverify',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: "PlayfairDisplay-VariableFont_wght",
                fontSize: 27,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(top: 5),
          children: [
            // Text input fields with range validation
            ...textFields.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 20,
                ),
                child: TextFormField(
                  controller: controllers[e.key],
                  validator: (myValue) {
                    if (myValue == null || myValue.isEmpty) {
                      return "This is Required";
                    }
                    final value = double.tryParse(myValue);
                    if (value == null) return "Enter a valid number";

                    final min = e.value['min'];
                    final max = e.value['max'];
                    if (min != null && value < min) {
                      return "Value must be ≥ $min";
                    }
                    if (max != null && value > max) {
                      return "Value must be ≤ $max";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      e.value['icon'] as IconData,
                      color: Colors.deepPurple,
                    ),
                    filled: true,
                    fillColor: const Color(0xffEAEFEF),
                    labelStyle: const TextStyle(
                      color: Color(0xff235D2C),
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.teal,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xff2E6F40),
                        width: 4,
                      ),
                    ),
                    labelText: e.key,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: e.value['type'],
                ),
              ),
            ),

            // Dropdowns
            _buildGenderDropdownField('Gender', genderValue, (value) {
              setState(() => genderValue = value);
            }, Icons.person),
            _buildDropdownField('Smoking', smokingValue, (value) {
              setState(() => smokingValue = value);
            }, Icons.smoking_rooms),
            _buildDropdownField('GeneticRisk', geneticRiskValue, (value) {
              setState(() => geneticRiskValue = value);
            }, Icons.family_restroom),
            _buildDropdownField('Diabetes', diabetesValue, (value) {
              setState(() => diabetesValue = value);
            }, Icons.bloodtype),
            _buildDropdownField('Hypertension', hypertensionValue, (value) {
              setState(() => hypertensionValue = value);
            }, Icons.favorite),

            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: C_button(
                name: "Detect",
                B_color: Colors.teal,
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    inputData.clear();

                    // Collect text field values
                    controllers.forEach((key, controller) {
                      inputData[key] =
                          double.tryParse(controller.text.trim()) ?? 0.0;
                    });

                    // Collect dropdowns
                    inputData['Gender'] = genderValue == 'Male [0]' ? 0.0 : 1.0;
                    inputData['Smoking'] = smokingValue == 'Yes' ? 1.0 : 0.0;
                    inputData['GeneticRisk'] =
                        geneticRiskValue == 'Yes' ? 1.0 : 0.0;
                    inputData['Diabetes'] = diabetesValue == 'Yes' ? 1.0 : 0.0;
                    inputData['Hypertension'] =
                        hypertensionValue == 'Yes' ? 1.0 : 0.0;

                    final prediction = await PredictionService().predict(
                      inputData,
                    );
                    print("Final Input data :$inputData ");

                    setState(() {
                      result =
                          prediction > 0.5 ? 'Disease Detected' : 'No Disease';
                      _probability = prediction;
                      _showAlertDialog(context);
                    });

                    _clearAllFields();
                  }
                },
                b_Width: 100.0.w,
                b_height: 45.0.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your _buildDropdownField and _buildGenderDropdownField stay same...
  // (No changes needed except keeping them as before)
  Widget _buildDropdownField(
    String fieldName,
    String? currentValue,
    Function(String?) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This is Required";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple, size: 24),
          suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.teal, size: 28),
          filled: true,
          fillColor: Color(0xffEAEFEF),
          labelStyle: TextStyle(
            color: Color(0xff235D2C),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xff2E6F40), width: 4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 3),
          ),
          labelText: fieldName,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: [
          DropdownMenuItem<String>(
            value: 'Yes',
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'No',
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.cancel, color: Colors.red.shade600, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'No',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        onChanged: onChanged,
        dropdownColor: Color(0xffF5F8F8),
        borderRadius: BorderRadius.circular(15),
        elevation: 8,
        iconSize: 0, // Hide default icon since we're using custom suffixIcon
        style: TextStyle(
          color: Color(0xff235D2C),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        selectedItemBuilder: (BuildContext context) {
          return ['Yes', 'No'].map<Widget>((String value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    value == 'Yes' ? Icons.check_circle : Icons.cancel,
                    color:
                        value == 'Yes'
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color(0xff235D2C),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildGenderDropdownField(
    String fieldName,
    String? currentValue,
    Function(String?) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This is Required";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple, size: 24),
          suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.teal, size: 28),
          filled: true,
          fillColor: Color(0xffEAEFEF),
          labelStyle: TextStyle(
            color: Color(0xff235D2C),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xff2E6F40), width: 4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 3),
          ),
          labelText: fieldName,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: [
          DropdownMenuItem<String>(
            value: 'Male [0]',
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.male, color: Colors.blue.shade600, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Male [0]',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Female [1]',
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.pink.shade50, Colors.pink.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.female, color: Colors.pink.shade600, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Female [1]',
                    style: TextStyle(
                      color: Colors.pink.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        onChanged: onChanged,
        dropdownColor: Color(0xffF5F8F8),
        borderRadius: BorderRadius.circular(15),
        elevation: 8,
        iconSize: 0, // Hide default icon since we're using custom suffixIcon
        style: TextStyle(
          color: Color(0xff235D2C),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        selectedItemBuilder: (BuildContext context) {
          return ['Male [0]', 'Female [1]'].map<Widget>((String value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    value.contains('Male') ? Icons.male : Icons.female,
                    color:
                        value.contains('Male')
                            ? Colors.blue.shade600
                            : Colors.pink.shade600,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color(0xff235D2C),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

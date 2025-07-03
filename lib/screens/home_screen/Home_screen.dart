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
  double? _probability; // NEW

  final Map<String, Map<String, dynamic>> fields = {
    'Age Testing': {'type': TextInputType.number, 'icon': Icons.calendar_today},
    'Gender': {'type': TextInputType.number, 'icon': Icons.person},
    'BMI': {'type': TextInputType.number, 'icon': Icons.fitness_center},
    'AlcoholConsumption': {
      'type': TextInputType.number,
      'icon': Icons.wine_bar,
    },
    'Smoking': {'type': TextInputType.number, 'icon': Icons.smoking_rooms},
    'GeneticRisk': {
      'type': TextInputType.number,
      'icon': Icons.family_restroom,
    },
    'PhysicalActivity': {
      'type': TextInputType.number,
      'icon': Icons.directions_run,
    },
    'Diabetes': {'type': TextInputType.number, 'icon': Icons.bloodtype},
    'Hypertension': {'type': TextInputType.number, 'icon': Icons.favorite},
    'LiverFunctionTest': {'type': TextInputType.number, 'icon': Icons.science},
  };

  @override
  void initState() {
    super.initState();
    for (var key in fields.keys) {
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
                        ? AssetImage('assets/check.png')
                        : AssetImage('assets/warning.png'),
              ),
              SizedBox(width: 5),
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                if (_probability != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Probability: ${(_probability! * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
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
              child: Text('Cancel'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB8CFCE),
      appBar: AppBar(
        title: Row(
          children: [
            Image(height: 37, image: AssetImage('assets/liver_logo.png')),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListView(
            children: [
              ...fields.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    controller: controllers[e.key],
                    validator: (myvale) {
                      if (myvale == null || myvale.isEmpty) {
                        return "This is Required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        e.value['icon'] as IconData,
                        color: Colors.deepPurple,
                      ),
                      filled: true,
                      fillColor: Color(0xffEAEFEF),
                      labelStyle: TextStyle(
                        color: Color(0xff235D2C),
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color(0xff2E6F40),
                          width: 4,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.purple.shade200),
                      labelText: e.key,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: e.value['type'],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: C_button(
                  name: "Detect",
                  B_color: Colors.teal,
                  ontap: () async {
                    if (_formKey.currentState!.validate()) {
                      inputData.clear();
                      controllers.forEach((key, controller) {
                        inputData[key] =
                            double.tryParse(controller.text.trim()) ?? 0.0;
                      });

                      final prediction = await PredictionService().predict(
                        inputData,
                      );

                      setState(() {
                        result =
                            prediction > 0.5
                                ? 'Disease Detected'
                                : 'No Disease';
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
              SizedBox(height: 10),
              Center(
                child:
                    result == ''
                        ? null
                        : Container(
                          height: 140.h,
                          width: double.infinity,
                          decoration: BoxDecoration(color: LightBlue),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Image(
                                height: 80,
                                image: AssetImage(
                                  result == 'Disease Detected'
                                      ? 'assets/warning.png'
                                      : 'assets/check.png',
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result == 'Disease Detected'
                                          ? "Non-Alcholic-Fatty\nLiver Disease Detected"
                                          : "No Liver Disease",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    if (_probability != null) ...[
                                      SizedBox(height: 8),
                                      Text(
                                        'Probability: ${(_probability! * 100).toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          minHeight: 10,
                                          value: _probability!,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                _probability! > 0.7
                                                    ? Colors.red
                                                    : _probability! > 0.3
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

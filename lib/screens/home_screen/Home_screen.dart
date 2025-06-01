import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liverify_disease_detection/custom_widgets/custom_button.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';
import 'package:liverify_disease_detection/screens/home_screen/prediction_service.dart';
import 'package:liverify_disease_detection/screens/profile_screen/profile_screen.dart';
import 'package:liverify_disease_detection/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          content:
              result == "No Disease"
                  ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "No Liver Disease Detected",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : Text(
                    "Non-Alchoholic Fatty Liver Disease Detected",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  // Save data to SharedPreferences

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> inputData = {};

  final fields = {
    'Age': TextInputType.number,
    'Gender': TextInputType.number,
    'BMI': TextInputType.number,
    'AlcoholConsumption': TextInputType.number,
    'Smoking': TextInputType.number,
    'GeneticRisk': TextInputType.number,
    'PhysicalActivity': TextInputType.number,
    'Diabetes': TextInputType.number,
    'Hypertension': TextInputType.number,
    'LiverFunctionTest': TextInputType.number,
  };

  String result = '';
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
                    validator: (myvale) {
                      if (myvale == null || myvale.isEmpty) {
                        return "This is Required";
                      }
                      null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.biotech, color: Colors.deepPurple),
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
                    keyboardType: e.value,
                    onSaved:
                        (val) =>
                            inputData[e.key] = double.tryParse(val ?? '0') ?? 0,
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
                    _formKey.currentState?.save();
                    final prediction = await PredictionService().predict(
                      inputData,
                    );

                    setState(() {
                      _showAlertDialog(context);
                      result =
                          prediction > 0.5 ? 'Disease Detected' : 'No Disease';
                    });

                    // _formKey.currentState?.save();
                  },
                  b_Width: 100.0.w,
                  b_height: 45.0.h,
                ),
              ),
              SizedBox(height: 10),

              Container(
                height: 100.h,
                width: double.infinity.w,

                decoration: BoxDecoration(color: LightBlue),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    // Text(
                    //   'Prediction: $result',
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    Image(
                      height: 80,
                      image: AssetImage(
                        result == 'Disease Detected'
                            ? 'assets/warning.png'
                            : 'assets/check.png',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      result == 'Disease Detected'
                          ? " Non-Alcholic-Fatty\n Liver Disease Detected"
                          : "No Liver Disease",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

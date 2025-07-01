import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';

import '../home_screen/prediction_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final service = PredictionService();

  String name = 'Muhammad Talha';
  String email = 'tahakhan4141@gmail.com';

  void editProfile() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = nameController.text.trim();
                    email = emailController.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void closeAppUsingSystemPop() {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, double>>(
          future: service.loadInputs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150.h,
                  width: double.infinity.w,
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 40.h,
                          backgroundImage: const AssetImage('assets/user.png'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                            ),
                            Text(
                              email,
                              style: const TextStyle(fontSize: 14, color: whiteColor),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: editProfile,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    "Record",
                    style: TextStyle(
                      fontFamily: "PlayfairDisplay-VariableFont_wght",
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  height: 400,
                  width: double.infinity,
                  child: ListView(
                    children: data.entries.map((entry) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(entry.key),
                            trailing: Text(entry.value.toStringAsFixed(2)),
                          ),
                          const Divider(height: 0, thickness: 2),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';

import '../home_screen/prediction_service.dart';

class Profile_screen extends StatelessWidget {
  final service = PredictionService();

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
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(40),
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
                          // child: Icon(Icons.person_off_rounded, size: 40),
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Muhammad Talha',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: whiteColor,
                            ),
                          ),
                          Text(
                            'tahakhan4141@gmail.com',
                            style: TextStyle(fontSize: 14, color: whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Record",

                    style: TextStyle(
                      fontFamily: "PlayfairDisplay-VariableFont_wght",
                      fontSize: 30,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Divider(),
                Container(
                  height: 400,
                  width: double.infinity,
                  child: ListView(
                    children:
                        data.entries.map((entry) {
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                  minTileHeight: 2,
                                  title: Text(entry.key),
                                  trailing: Text(
                                    entry.value.toStringAsFixed(2),
                                  ),
                                ),
                                Divider(height: 0, thickness: 2),
                              ],
                            ),
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

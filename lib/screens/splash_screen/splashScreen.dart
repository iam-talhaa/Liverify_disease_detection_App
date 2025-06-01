import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';
import 'package:liverify_disease_detection/services/splash_services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SplashServices _service = SplashServices();

    _service.Login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300.h,
            width: double.infinity.w,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(180.h),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Image(
                  height: 170.h,
                  image: AssetImage('assets/liver_logo.png'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Text(
                "Liverify",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                  letterSpacing: 5.4,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  height: 10.h,
                  width: 200.w,
                  child: Divider(thickness: 2),
                ),
              ),
              Text(
                'Healthy Liver, Healthy Life',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

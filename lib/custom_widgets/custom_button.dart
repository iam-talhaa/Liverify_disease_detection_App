import 'package:flutter/material.dart';

class C_button extends StatefulWidget {
  final name;
  Color B_color;
  VoidCallback ontap;
  final b_height;
  final b_Width;

  C_button({
    super.key,
    required this.name,
    required this.B_color,
    required this.ontap,
    required this.b_Width,
    required this.b_height,
  });

  @override
  State<C_button> createState() => _C_buttonState();
}

class _C_buttonState extends State<C_button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: widget.b_height,
          width: widget.b_Width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.B_color,
          ),
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

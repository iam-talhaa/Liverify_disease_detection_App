import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  final t_string;
  final t_font;
  final t_color;

  const NormalText({
    super.key,
    required this.t_string,
    required this.t_color,
    required this.t_font,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$t_string',
      style: TextStyle(fontSize: t_font, color: t_color),
    );
  }
}

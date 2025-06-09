import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  final t_string;
  final t_font_size;
  final t_color;
  final t_fontFamily;

  NormalText({
    super.key,
    required this.t_string,
    required this.t_color,
    required this.t_font_size,
    this.t_fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    print('');
    print('');
    return Text(
      '$t_string',
      style: TextStyle(
        fontSize: t_font_size,
        color: t_color,
        fontFamily: t_fontFamily,
      ),
    );
  }
}

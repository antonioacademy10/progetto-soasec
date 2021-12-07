import 'package:flutter/material.dart';

final redColor = Color(0xFFDF7551);
final lineColor = Color(0xFF747474);

final buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(redColor),
    elevation: MaterialStateProperty.all(8.0),
    shadowColor: MaterialStateProperty.all(redColor));

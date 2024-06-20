import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';

class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Mystyles.headingstyle.copyWith(
        color:const Color(0xFF68BBE3),
      )      
   );
  }
}
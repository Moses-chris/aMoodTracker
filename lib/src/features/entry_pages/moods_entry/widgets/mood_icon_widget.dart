// mood_icon.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';

class MoodIcon extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color color;
  final bool isSelected;
  final int score;
  final VoidCallback onTap;

  const MoodIcon({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color :const Color.fromARGB(221, 0, 0, 0),
            ),
           child:  ColorFiltered(
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.transparent :const Color.fromARGB(221, 0, 0, 0),
              BlendMode.srcATop,
            ),
            child: Image.asset(
              iconPath,
              width: 60,
              height: 60,
//              color: isSelected ? color : Colors.grey,
            ),
          ),),
          const SizedBox(height: 5),
          Text(
            label,
            style: Mystyles.textinbutton.copyWith(
              color: isSelected ? color :const Color(0xFF050A30),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

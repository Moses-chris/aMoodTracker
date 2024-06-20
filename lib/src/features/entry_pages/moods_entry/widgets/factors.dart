import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';

class FactorChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const FactorChip({super.key, required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Chip(
        label: Text(
          label,
          style: Mystyles.textinbutton.copyWith(color: selected ? Colors.black : Color(0xFFB4654A),
              ),
        ),
        backgroundColor: selected ? const Color(0xFF0000FF) :const Color(0xFF0C2D48),
        side: BorderSide(
          width: 1.5,
          color: selected ? Colors.red : Colors.grey[800]!,
        ),
      ),
    );
  }
}
//8E9AAF
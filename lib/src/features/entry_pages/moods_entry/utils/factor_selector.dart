import 'package:flutter/material.dart';
import '../widgets/factors.dart';

class FactorSelector extends StatelessWidget {
  final List<String> selectedFactors;
  final Function(String) onFactorToggle;
  final List<String> factors = [
    "Work", "Exercise", "Family", "Hobbies", "Finances", "Sleep", "Drink", "Food", "Relationships", "Education", "Weather", "Music", "Travel", "Health"
  ];

  FactorSelector({super.key, required this.selectedFactors, required this.onFactorToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      alignment: WrapAlignment.start,
      children: factors.map((factor) {
        return FactorChip(
          label: factor,
          selected: selectedFactors.contains(factor),
          onSelected: () => onFactorToggle(factor),
        );
      }).toList(),
    );
  }
}
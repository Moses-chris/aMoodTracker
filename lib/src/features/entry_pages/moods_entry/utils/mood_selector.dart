import 'package:flutter/material.dart';
import '../configarations/mood_config.dart';
import '../widgets/mood_icon_widget.dart';

class MoodSelector extends StatelessWidget {
  final Function(String) onMoodSelected;
  final String selectedMood;

  const MoodSelector({super.key, required this.onMoodSelected, required this.selectedMood});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: moods.map((mood) {
        return MoodIcon(
          iconPath: mood.emojiPath,
          label: mood.text,
          color: mood.color,
          score: mood.score,
          onTap: () => onMoodSelected(mood.emojiPath),
          isSelected: mood.emojiPath == selectedMood,
        );
      }).toList(),
    );
  }
}

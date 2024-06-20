import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import '../entry_pages/moods_entry/data/moodlog/mood_entry.dart';

class MoodCountBarChart extends StatelessWidget {
  const MoodCountBarChart({super.key, required this.moodRecords});

  final List<MoodEntry> moodRecords;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: moodRecords.isEmpty
          ? const Center(child: Text(
            "Not enough data...",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          ))
          : BarChart(
              BarChartData(
                barGroups: _getBarChartGroups(moodRecords),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: _titleWidgets, reservedSize: 40),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateYInterval(moodRecords),
                      reservedSize: 30, // Increase reserved size to accommodate larger numbers
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(drawVerticalLine: false),
              ),
            ),
    );
  }

  List<BarChartGroupData> _getBarChartGroups(List<MoodEntry> records) {
    var groups = groupBy(records, (e) => e.mood.score);

    return List.generate(5, (index) {
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: groups[index + 1]?.length.toDouble() ?? 0.0,
            color: _getColorByMoodScore(index + 1),
            width: 20,
          ),
        ],
      );
    });
  }

  Color? _getColorByMoodScore(int score) {
    switch (score) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.cyan;
      case 5:
        return Colors.green;
      default:
        return null;
    }
  }

  Widget _titleWidgets(double score, TitleMeta meta) {
    String emojiPath;
    switch (score.toInt()) {
      case 1:
        emojiPath = "assets/emojis/rage.png";
        break;
      case 2:
        emojiPath = "assets/emojis/white_frowning_face.png";
        break;
      case 3:
        emojiPath = "assets/emojis/slightly_smiling_face.png";
        break;
      case 4:
        emojiPath = "assets/emojis/blush.png";
        break;
      case 5:
        emojiPath = "assets/emojis/laughing.png";
        break;
      default:
        throw StateError('Invalid');
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Image.asset(emojiPath, height: 32, width: 32),
    );
  }

  double _calculateYInterval(List<MoodEntry> records) {
    var groups = groupBy(records, (e) => e.mood.score);
    int maxCount = groups.values.map((list) => list.length).max;

    if (maxCount <= 5) {
      return 1;
    } else if (maxCount <= 10) {
      return 2;
    } else if (maxCount <= 20) {
      return 5;
    } else {
      return (maxCount / 4).ceilToDouble();
    }
  }
}

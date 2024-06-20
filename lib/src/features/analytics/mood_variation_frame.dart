import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../entry_pages/moods_entry/data/moodlog/mood_entry.dart';

class MoodVariationLineChart extends StatelessWidget {
  const MoodVariationLineChart({super.key, required this.moodRecords});

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
          )
            ))
          : LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpots(moodRecords),
                    isCurved: true,
                    color: Colors.red, // Use color instead of colors
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final formattedDate = DateFormat('MM/dd').format(date);
                        return Text(formattedDate, style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
              ),
            ),
    );
  }

  List<FlSpot> _getSpots(List<MoodEntry> records) {
    return records.map((record) => FlSpot(record.date.millisecondsSinceEpoch.toDouble(), record.mood.score.toDouble())).toList();
  }
}

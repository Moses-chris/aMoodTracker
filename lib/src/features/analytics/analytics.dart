// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:collection/collection.dart';
// import 'package:intl/intl.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../entry_pages/moods_entry/data/moodlog/mood_entry.dart';

// class AnalyticsScreen extends StatelessWidget {
//   const AnalyticsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Insights"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.fromLTRB(12, 12, 12, kFloatingActionButtonMargin * 2 + 48),
//               children: const [
//                 ChartFrame(chartType: ChartType.moodCount, title: "Mood Count"),
//                 ChartFrame(chartType: ChartType.moodVariation, title: "Mood Fluctuation"),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// enum ChartType { moodCount, moodVariation }

// enum ChartFilter {
//   sevenDays,
//   month,
//   all,
//   year,
// }

// class ChartFrame extends StatefulWidget {
//   const ChartFrame({
//     Key? key,
//     required this.chartType,
//     required this.title,
//   }) : super(key: key);

//   final ChartType chartType;
//   final String title;

//   @override
//   _ChartFrameState createState() => _ChartFrameState();
// }

// class _ChartFrameState extends State<ChartFrame> {
//   ChartFilter _dropdownValue = ChartFilter.sevenDays;
//   List<MoodEntry> _moodEntries = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     final box = Hive.box<MoodEntry>('moodEntries');
//     setState(() {
//       _moodEntries = _getFilteredRecords(box.values.toList(), _dropdownValue);
//     });
//   }

//   List<MoodEntry> _getFilteredRecords(List<MoodEntry> records, ChartFilter filter) {
//     final now = DateTime.now();
//     List<MoodEntry> filteredRecords;
//     switch (filter) {
//       case ChartFilter.sevenDays:
//         filteredRecords = records.where((record) => record.date.isAfter(now.subtract(Duration(days: 7)))).toList();
//         break;
//       case ChartFilter.month:
//         filteredRecords = records.where((record) => record.date.month == now.month && record.date.year == now.year).toList();
//         break;
//       case ChartFilter.year:
//         filteredRecords = records.where((record) => record.date.year == now.year).toList();
//         break;
//       case ChartFilter.all:
//       default:
//         filteredRecords = records;
//     }
//     filteredRecords.sort((a, b) => a.date.compareTo(b.date));
//     return filteredRecords;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.title,
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const Spacer(),
//                 DropdownButton(
//                   value: _dropdownValue,
//                   items: const [
//                     DropdownMenuItem(
//                       value: ChartFilter.sevenDays,
//                       child: Text("Week"),
//                     ),
//                     DropdownMenuItem(
//                       value: ChartFilter.month,
//                       child: Text("Month"),
//                     ),
//                     DropdownMenuItem(
//                       value: ChartFilter.year,
//                       child: Text("Year"),
//                     ),
//                     DropdownMenuItem(
//                       value: ChartFilter.all,
//                       child: Text("All"),
//                     ),
//                   ],
//                   onChanged: (ChartFilter? filter) {
//                     setState(() {
//                       _dropdownValue = filter!;
//                       _loadData();
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 8),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildChart(widget.chartType, _moodEntries),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChart(ChartType type, List<MoodEntry> moodEntries) {
//     switch (type) {
//       case ChartType.moodCount:
//         return MoodCountBarChart(moodRecords: moodEntries);
//       case ChartType.moodVariation:
//         return MoodVariationLineChart(moodRecords: moodEntries);
//       default:
//         return const Text("Unknown chart type");
//     }
//   }
// }

// class MoodCountBarChart extends StatelessWidget {
//   const MoodCountBarChart({super.key, required this.moodRecords});

//   final List<MoodEntry> moodRecords;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: moodRecords.isEmpty
//           ? const Center(child: Text("Not enough data..."))
//           : BarChart(
//               BarChartData(
//                 barGroups: _getBarChartGroups(moodRecords),
//                 titlesData: FlTitlesData(
//                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => Container())),
//                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false, getTitlesWidget: (value, meta) => Container())),
//                   bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: _titleWidgets, reservedSize: 40)),
//                   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 gridData: FlGridData(drawVerticalLine: false, horizontalInterval: 1),
//               ),
//             ),
//     );
//   }

//   List<BarChartGroupData> _getBarChartGroups(List<MoodEntry> records) {
//     var groups = groupBy(records, (e) => e.mood.score);

//     return List.generate(5, (index) {
//       return BarChartGroupData(
//         x: index + 1,
//         barRods: [
//           BarChartRodData(
//             toY: groups[index + 1]?.length.toDouble() ?? 0.0,
//             color: _getColorByMoodScore(index + 1),
//             width: 20,
//           ),
//         ],
//       );
//     });
//   }

//   Color? _getColorByMoodScore(int score) {
//     switch (score) {
//       case 1:
//         return Colors.red;
//       case 2:
//         return Colors.orange;
//       case 3:
//         return Colors.blue;
//       case 4:
//         return Colors.cyan;
//       case 5:
//         return Colors.green;
//       default:
//         return null;
//     }
//   }

//   Widget _titleWidgets(double score, TitleMeta meta) {
//     String emojiPath;
//     Color color;
//     switch (score.toInt()) {
//       case 1:
//         emojiPath = "assets/emojis/rage.png";
//         color = Colors.red;
//         break;
//       case 2:
//         emojiPath = "assets/emojis/white_frowning_face.png";
//         color = Colors.orange;
//         break;
//       case 3:
//         emojiPath = "assets/emojis/slightly_smiling_face.png";
//         color = Colors.blue;
//         break;
//       case 4:
//         emojiPath = "assets/emojis/blush.png";
//         color = Colors.cyan;
//         break;
//       case 5:
//         emojiPath = "assets/emojis/laughing.png";
//         color = Colors.green;
//         break;
//       default:
//         throw StateError('Invalid');
//     }
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       child: Image.asset(emojiPath, color: color, height: 32, width: 32),
//     );
//   }
// }

// class MoodVariationLineChart extends StatelessWidget {
//   const MoodVariationLineChart({super.key, required this.moodRecords});

//   final List<MoodEntry> moodRecords;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: moodRecords.isEmpty
//           ? const Center(child: Text("Not enough data..."))
//           : LineChart(
//               LineChartData(
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: _getSpots(moodRecords),
//                     isCurved: true,
//                     gradient: LinearGradient(colors: [Colors.blue]), // Use gradient instead of colors
//                     barWidth: 4,
//                     belowBarData: BarAreaData(show: false),
//                     dotData: FlDotData(show: false),
//                   ),
//                 ],
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: true, interval: 1),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//                         final formattedDate = DateFormat('MM/dd').format(date);
//                         return Text(formattedDate, style: const TextStyle(fontSize: 10));
//                       },
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 gridData: FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
//               ),
//             ),
//     );
//   }

//   List<FlSpot> _getSpots(List<MoodEntry> records) {
//     return records.map((record) => FlSpot(record.date.millisecondsSinceEpoch.toDouble(), record.mood.score.toDouble())).toList();
//   }
// }

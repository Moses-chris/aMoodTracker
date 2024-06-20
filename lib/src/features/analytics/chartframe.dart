import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import '../entry_pages/moods_entry/data/moodlog/mood_entry.dart';
import 'mood_count_bar.dart';
import 'mood_variation_frame.dart';

enum ChartType { moodCount, moodVariation }

enum ChartFilter {
  sevenDays,
  month,
  all,
  year,
}

class ChartFrame extends StatefulWidget {
  const ChartFrame({
    super.key,
    required this.chartType,
    required this.title,
  });

  final ChartType chartType;
  final String title;

  @override
  _ChartFrameState createState() => _ChartFrameState();
}

class _ChartFrameState extends State<ChartFrame> {
  ChartFilter _dropdownValue = ChartFilter.sevenDays;
  List<MoodEntry> _moodEntries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final box = Hive.box<MoodEntry>('moodEntries');
    setState(() {
      _moodEntries = _getFilteredRecords(box.values.toList(), _dropdownValue);
    });
  }

  List<MoodEntry> _getFilteredRecords(List<MoodEntry> records, ChartFilter filter) {
    final now = DateTime.now();
    List<MoodEntry> filteredRecords;
    switch (filter) {
      case ChartFilter.sevenDays:
        filteredRecords = records.where((record) => record.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
        break;
      case ChartFilter.month:
        filteredRecords = records.where((record) => record.date.month == now.month && record.date.year == now.year).toList();
        break;
      case ChartFilter.year:
        filteredRecords = records.where((record) => record.date.year == now.year).toList();
        break;
      case ChartFilter.all:
      default:
        filteredRecords = records;
    }
    filteredRecords.sort((a, b) => a.date.compareTo(b.date));
    return filteredRecords;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
       color: Mystyles.myaccentColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Mystyles.headingcardstyle,
                ),
                const Spacer(),
                DropdownButton(
                  dropdownColor:const Color(0xFF0E86D4),
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(8),
                  icon:const Icon( Icons.arrow_drop_down),
                  value: _dropdownValue,
                  items:  [
                    DropdownMenuItem(
                      value: ChartFilter.sevenDays,
                      child: Text("Week", style: Mystyles.textinbutton,),
                    ),
                    DropdownMenuItem(
                      value: ChartFilter.month,
                      child: Text("Month",style: Mystyles.textinbutton),
                    ),
                    DropdownMenuItem(
                      value: ChartFilter.year,
                      child: Text("Year",style: Mystyles.textinbutton),
                    ),
                    DropdownMenuItem(
                      value: ChartFilter.all,
                      child: Text("All",style: Mystyles.textinbutton),
                    ),
                  ],
                  onChanged: (ChartFilter? filter) {
                    setState(() {
                      _dropdownValue = filter!;
                      _loadData();
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 20),
            _buildChart(widget.chartType, _moodEntries),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(ChartType type, List<MoodEntry> moodEntries) {
    switch (type) {
      case ChartType.moodCount:
        return MoodCountBarChart(moodRecords: moodEntries);
      case ChartType.moodVariation:
        return MoodVariationLineChart(moodRecords: moodEntries);
      default:
        return const Text("Unknown chart type");
    }
  }
}

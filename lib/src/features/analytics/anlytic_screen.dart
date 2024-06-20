import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import 'chartframe.dart';


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Mystyles.mybackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, kFloatingActionButtonMargin * 2 + 48),
                children: const [
                  ChartFrame(chartType: ChartType.moodCount, title: "Mood Count"),
                  ChartFrame(chartType: ChartType.moodVariation, title: "Mood Fluctuation"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

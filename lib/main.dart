import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/src/util_shared/bottom_navigation_bar.dart';
import 'package:provider/provider.dart' as provider;

import 'src/features/calendar/timetable.dart';
import 'src/features/entry_pages/moods_entry/data/moodlog/mood_entry.dart';
import 'src/features/entry_pages/moods_entry/data/moodlog/mood_log.dart';
import 'src/features/entry_pages/refrection_entries/data/category_selection_provider.dart';
import 'src/features/entry_pages/refrection_entries/data/dataentry/refrection_data_entry.dart';
import 'src/features/entry_pages/refrection_entries/presentation/refrections_view.dart';
//import 'src/features/entry_pages/moods_entry/data/color_adapter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
  Hive.registerAdapter(MoodAdapter()); // Register Mood adapter
  Hive.registerAdapter(MoodEntryAdapter()); 
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ColorAdapter());// Register MoodEntry adapter
  await Hive.openBox<MoodEntry>('moodEntries');
  await Hive.openBox<JournalEntry>('journal_entries'); // Open a box to store entries

  // runApp(const MyApp());
 
   runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => CategorySelectionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'journal app',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black45
        ),
        home: const BottomNavBarV2(),
         routes: {
          '/timetable': (context) => const TimeTable(),
          '/view_entries': (context) => ViewEntriesPage(),
        },
      ),
    );
  }
}



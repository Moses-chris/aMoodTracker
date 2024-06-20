import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../shared/datepicker.dart';
import '../shared/headertext.dart';
import '../shared/journalinputfield.dart';
import 'configarations/mood_config.dart' as moodconfig;
import 'data/moodlog/mood_entry.dart';
import 'data/moodlog/mood_log.dart';
import 'utils/factor_selector.dart';
import 'utils/mood_selector.dart';

class MoodsPage extends StatefulWidget {
  const MoodsPage({super.key});

  @override
  State<MoodsPage> createState() => _MoodsPageState();
}

class _MoodsPageState extends State<MoodsPage> {
  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;

  String selectedMoodEmojiPath = "";
  List<String> selectedFactors = [];
  DateTime _selectedDate = DateTime.now();
  String journalText = "";
  String? imagePath;
  String? audioPath;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  void toggleFactor(String factor) {
    setState(() {
      if (selectedFactors.contains(factor)) {
        selectedFactors.remove(factor);
      } else {
        selectedFactors.add(factor);
      }
    });
  }

  void _toggleRecording() async {
    if (_isRecording) {
      audioPath = await _recorder.stopRecorder();
    } else {
      await _recorder.startRecorder(toFile: 'audio_record.m4a');
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  Future<bool> _showLeaveConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Mystyles.mybackgroundColor,
            title:  Text(
              'Are you sure?',
              style: Mystyles.textstyle.copyWith(fontSize: 20),
              ),
            content:  Text('Leaving without saving will discard all changes.',
                  style: Mystyles.textstyle,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _saveEntry() async {
    try {
      moodconfig.Mood mood = moodconfig.getMoodDetails(selectedMoodEmojiPath);
      MoodEntry moodEntry = MoodEntry(
        mood: Mood(
          emojiPath: mood.emojiPath,
          color: mood.color,
          text: mood.text,
          score: mood.score,
        ),
        factors: selectedFactors,
        date: _selectedDate,
        journal: journalText,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      var box = await Hive.openBox<MoodEntry>('moodEntries');
      await box.add(moodEntry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entries saved successfully')),
      );
    } catch (e) {
      print('Error saving entries: $e');
      ScaffoldMessenger.of(context).showSnackBar(
      
        const SnackBar(
          content: Text('Error saving entries')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await _showLeaveConfirmationDialog(context);
        return shouldLeave;
      },
      child: Scaffold(
        backgroundColor: Mystyles.mybackgroundColor,
        body: Column(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        bool shouldLeave = await _showLeaveConfirmationDialog(context);
                        if (shouldLeave) {
                          if (!mounted) return; // Check if the widget is still mounted
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const Spacer(),
                    CustomDatePicker(
                      initialDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed:  () {
                        _saveEntry();
                      }, 
                      icon:const Icon(Icons.add_task_outlined)
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const HeaderText(text: "How are you feeling?"),
                      const SizedBox(height: 10),
                      MoodSelector(
                        selectedMood: selectedMoodEmojiPath,
                        onMoodSelected: (mood) => setState(() => selectedMoodEmojiPath = mood),
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(text: "What's affecting your mood?"),
                      const SizedBox(height: 10),
                      FactorSelector(
                        selectedFactors: selectedFactors,
                        onFactorToggle: toggleFactor,
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(text: "Let's write about it"),
                      const SizedBox(height: 10),
                      JournalInputField(
                        hint_text: "How has your day been?",
                        onChanged: (value) {
                          setState(() {
                            journalText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(text: "Capture a day's moment"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera),
                            label:  Text(
                              "Take Photo",
                              style: Mystyles.textinelevatedbutton,
                              ),
                             style: ElevatedButton.styleFrom(
                                 backgroundColor: Mystyles.myelevatedbuttoncolor,),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo),
                            label:  Text(
                              "From Gallery",
                              style: Mystyles.textinelevatedbutton,
                              ),
                            style: ElevatedButton.styleFrom(
                                 backgroundColor: Mystyles.myelevatedbuttoncolor,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const HeaderText(text: "Talk about it"),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _toggleRecording,
                          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                          label: Text(_isRecording ? "Stop Recording" : "Tap to Record"),
                          style: ElevatedButton.styleFrom(
                                 backgroundColor: Mystyles.myelevatedbuttoncolor,),
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveEntry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Mystyles.myelevatedbuttoncolor,),
                          child:  Text(
                            "Save",
                            style: Mystyles.textinelevatedbutton
                            ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(builder: (context) => const EntryListPage()),
                      //     );
                      //   },
                      //   child: const Text('View Entries'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

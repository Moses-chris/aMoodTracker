import 'package:flutter/material.dart';

class JournalInputField extends StatelessWidget {
  final String hint_text;
  final Function(String) onChanged;

  const JournalInputField({
    super.key,
    required this.hint_text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      maxLines: 3,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint_text,
        hintStyle: const TextStyle(color: Color.fromARGB(153, 242, 251, 224)),
        filled: true,
        fillColor:const Color(0xAC41729F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

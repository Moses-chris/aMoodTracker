import 'package:flutter/material.dart';

class refrectionInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const refrectionInputField({super.key, 
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          
        ),
        filled: true,
        fillColor:const Color(0xAC41729F),
        hintStyle: const TextStyle(fontSize: 16),
      
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 16),
      cursorColor: Colors.white,
      cursorWidth: 2,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(2),
      
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/styling/styles.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ).then((pickedDate) {
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        });
      },
      
      style: ElevatedButton.styleFrom(
        backgroundColor: Mystyles.myelevatedbuttoncolor,),
      child: Text(
        DateFormat('yyyy-MM-dd').format(initialDate),
            style:const TextStyle(color: Color(0xFFF2FBE0) ),
      ),
    );
  }
}

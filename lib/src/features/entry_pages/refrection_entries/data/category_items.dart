import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import 'model/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryItemModel item;
  final bool isSelected;
  final Function(String) onToggleSelection;

  const CategoryItem({super.key, 
    required this.item,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggleSelection(item.label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isSelected ? const Color(0xFF05F140) : Colors.grey,
            child: Icon(item.icon, size: 24),
          ),
          const SizedBox(height: 4),
          Text(item.label, style:Mystyles.textinbutton.copyWith(
            color: isSelected ? const Color(0xFF05F140) : Colors.grey,
          )),
        ],
      ),
    );
  }
}



class Category {
  final String label;
  final List<CategoryItem> items;

  Category({required this.label, required this.items});
}


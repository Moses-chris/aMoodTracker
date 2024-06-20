import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/styling/styles.dart';
import '../data/category_selection_provider.dart';
import '../data/model/category_model.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategorySelectionProvider>().categories;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050A30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: ExpansionPanelList(
          elevation: 4,
          expandedHeaderPadding: const EdgeInsets.all(0),
          animationDuration: const Duration(milliseconds: 200),
          expansionCallback: (int index, bool isExpanded) {
            context.read<CategorySelectionProvider>().toggleExpansion(index);
          },
          children: categories.map<ExpansionPanel>((CategoryModel category) {
            bool hasSelectedItem = category.items.any((item) => item.isSelected);
      
            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  color: Color(0xFF051330),
                  child: ListTile(
                    title: Text(
                      category.title,
                      style: TextStyle(
                        color: hasSelectedItem ? const Color(0xFFE57C04) : Colors.white,
                      ),
                    ),
                  ),
                );
              },
              backgroundColor: Color(0xFF051330),
              body: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: category.items.length,
                  itemBuilder: (context, index) {
                    final item = category.items[index];
                    return GestureDetector(
                      onTap: () => context.read<CategorySelectionProvider>().toggleSelection(item.label),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: item.isSelected ? const Color(0xFF05F140) : Color(0xFF055C9D),
                            child: Icon(item.icon, size: 24),
                          ),
                          const SizedBox(height: 4),
                        //  Text(item.label, style: const TextStyle(fontSize: 16)),
                           Text(item.label, style:Mystyles.textinbutton.copyWith(
                                color: item.isSelected ?  Colors.amber : Colors.grey,
                                 ))
                        ],
                      ),
                    );
                  },
                ),
              ),
              isExpanded: category.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}

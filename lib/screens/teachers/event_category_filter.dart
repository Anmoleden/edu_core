import 'package:flutter/material.dart';

class EventCategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final Function(String) onSelected;

  const EventCategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = selected == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => onSelected(category),
                selectedColor: Colors.black,
                checkmarkColor: Colors.white,
                showCheckmark: true,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                backgroundColor: Colors.grey[300],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


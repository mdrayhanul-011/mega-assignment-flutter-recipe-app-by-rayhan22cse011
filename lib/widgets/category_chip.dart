import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (_) {},
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart' hide AppColors;

class QuickSplitInputCard extends StatelessWidget {
  const QuickSplitInputCard({
    required this.onDelete,
    required this.onPersonNameChanged,
    required this.onAmountChanged,
    super.key,
  });

  final VoidCallback onDelete;
  final ValueChanged<String> onPersonNameChanged;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                AppTextField(onChanged: onPersonNameChanged),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Amount', // Replace with your label text
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                AppTextField(
                  onChanged: onAmountChanged,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}

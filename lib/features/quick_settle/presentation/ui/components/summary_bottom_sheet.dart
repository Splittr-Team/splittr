import 'package:flutter/material.dart';

class SummaryBottomSheet extends StatelessWidget {
  const SummaryBottomSheet({required this.summaryMap, super.key});
  final Map<String, List<Map<String, double>>> summaryMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.blueBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: AppColors.whiteColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: summaryMap.entries.map<Widget>((entry) {
                  final receiver = entry.key;
                  final givers = List<Map<String, double>>.from(entry.value);

                  return Card(
                    // color: AppColors.greyColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              receiver,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: givers.map<Widget>((giverMap) {
                              final giver = giverMap.keys.first;
                              final amount = giverMap.values.first;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Giver name
                                    Text(
                                      giver,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    if (amount < 0)
                                      Text(
                                        '''${(amount * -1).toStringAsFixed(2)} Rs''',
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    else
                                      Text(
                                        '${amount.toStringAsFixed(2)} Rs',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

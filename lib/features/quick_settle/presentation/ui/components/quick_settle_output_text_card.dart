import 'package:flutter/material.dart';

class QuickSettleOutputTextCard extends StatelessWidget {
  const QuickSettleOutputTextCard({
    required this.sender,
    required this.receiver,
    required this.amount,
    super.key,
  });

  final String sender;
  final String receiver;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              // color: AppColors.blackColor
            ),
            children: [
              TextSpan(
                text: sender,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ), // Sender in bold
              const TextSpan(text: ' has to pay '),
              TextSpan(
                text: '$amount Rs',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ), // Amount in bold
              const TextSpan(text: ' to '),
              TextSpan(
                text: receiver,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ), // Receiver in bold
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
    );
  }
}

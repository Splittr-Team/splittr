import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/quick_settle/presentation/blocs/quick_settle_bloc.dart';
import 'package:splittr/features/quick_settle/presentation/ui/components/quick_settle_output_arrow_card.dart';
import 'package:splittr/features/quick_settle/presentation/ui/components/quick_settle_output_text_card.dart';
import 'package:splittr/features/quick_settle/presentation/ui/components/summary_bottom_sheet.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';

part 'quick_settle_form.dart';

class QuickSettlePage extends BasePage<QuickSettleBloc, QuickSettleState> {
  const QuickSettlePage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  QuickSettleBloc createBloc() => getIt<QuickSettleBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.blueBgColor,
        centerTitle: true,
        title: const Text(
          'Quick Settle',
          // style: TextStyle(color: AppColors.whiteColor),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 15, top: 10),
          decoration: BoxDecoration(
            // color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            // color: AppColors.whiteColor,
          ),
        ),
      ),
      body: const _QuickSettleForm(),
    );
  }
}

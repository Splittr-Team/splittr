import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart' show AppSnackBar;
import 'package:splittr/constants/constants.dart';
import 'package:splittr/core/route_handler/route_handler.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/quick_split/presentation/blocs/quick_split_bloc.dart';
import 'package:splittr/features/quick_split/presentation/ui/components/quick_split_input_card.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';

part 'quick_split_form.dart';

class QuickSplitPage extends BasePage<QuickSplitBloc, QuickSplitState> {
  const QuickSplitPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  QuickSplitBloc createBloc() => getIt<QuickSplitBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.blueBgColor,
        centerTitle: true,
        title: const Text(
          'Quick Split',
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
      body: const _QuickSplitForm(),
    );
  }

  @override
  void handleStateChange(BuildContext context, QuickSplitState state) {
    return switch (state) {
      InvalidAmount(:final invalidAmount) =>
        invalidAmount.isEmpty
            ? AppSnackBar.show(context, message: 'Empty amount are not allowed')
            : AppSnackBar.show(
                context,
                message: '$invalidAmount is an invalid amount',
              ),
      EmptyName() => AppSnackBar.show(
        context,
        message: 'Empty names are not allowed',
      ),
      QuickSettle _ => _navigateToQuickSettlePage(
        context: context,
        state: state,
      ),
      _ => () {},
    };
  }

  void _navigateToQuickSettlePage({
    required BuildContext context,
    required QuickSplitState state,
  }) {
    unawaited(
      RouteHandler.push(
        context,
        RouteId.quickSettle,
        args: {
          StringConstants.peopleRecords: state.store.peopleRecords.map((
            peopleRecord,
          ) {
            return (
              name: peopleRecord.name,
              amount: double.tryParse(peopleRecord.amount) ?? 0,
            );
          }).toList(),
        },
      ),
    );
  }
}

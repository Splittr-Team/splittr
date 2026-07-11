import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/personal_transaction/presentation/blocs/personal_transaction_bloc.dart';

class PersonalTransactionComponent extends StatelessWidget {
  const PersonalTransactionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PersonalTransactionBloc>()..started(),
      child: BlocConsumer<PersonalTransactionBloc, PersonalTransactionState>(
        listener: _handleState,
        builder: _handleWidget,
      ),
    );
  }

  void _handleState(BuildContext context, PersonalTransactionState state) {}

  Widget _handleWidget(BuildContext context, PersonalTransactionState state) {
    return const Placeholder();
  }
}

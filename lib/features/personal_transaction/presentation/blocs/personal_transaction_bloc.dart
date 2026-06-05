import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';

part 'personal_transaction_bloc.freezed.dart';
part 'personal_transaction_event.dart';
part 'personal_transaction_state.dart';

@injectable
final class PersonalTransactionBloc
    extends BaseBloc<PersonalTransactionEvent, PersonalTransactionState> {
  PersonalTransactionBloc()
    : super(
        const PersonalTransactionState.initial(
          store: PersonalTransactionStateStore(),
        ),
      );

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  void _onStarted(_Started event, Emitter<PersonalTransactionState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const PersonalTransactionEvent.started());
  }
}

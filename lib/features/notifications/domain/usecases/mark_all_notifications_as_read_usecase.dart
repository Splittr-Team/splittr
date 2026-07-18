import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@lazySingleton
class MarkAllNotificationsAsReadUseCase implements UseCase<void, NoParams> {
  const MarkAllNotificationsAsReadUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _notificationsRepository.readAllNotifications();
  }
}

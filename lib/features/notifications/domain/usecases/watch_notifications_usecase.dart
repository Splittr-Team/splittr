import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@lazySingleton
class WatchNotificationsUseCase
    implements StreamUseCase<List<Notification>, NoParams> {
  const WatchNotificationsUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  Stream<Either<Failure, List<Notification>>> call(NoParams params) {
    return _notificationsRepository.watchNotifications;
  }
}

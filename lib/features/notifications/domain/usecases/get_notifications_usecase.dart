import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@lazySingleton
class GetNotificationsUseCase implements UseCase<List<Notification>, NoParams> {
  const GetNotificationsUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) {
    return _notificationsRepository.getNotifications();
  }
}

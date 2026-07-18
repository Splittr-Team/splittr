import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@lazySingleton
class MarkNotificationAsReadUseCase implements UseCase<void, String> {
  const MarkNotificationAsReadUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _notificationsRepository.readNotification(id);
  }
}

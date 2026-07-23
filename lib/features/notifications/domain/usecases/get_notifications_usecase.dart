import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/core/network/pagination.dart';
import 'package:splittr/features/notifications/domain/entities/notification.dart';
import 'package:splittr/features/notifications/domain/repositories/notifications_repository.dart';

@lazySingleton
class GetNotificationsUseCase
    implements UseCase<PaginatedList<Notification>, GetNotificationsParams> {
  const GetNotificationsUseCase(this._notificationsRepository);

  final NotificationsRepository _notificationsRepository;

  @override
  Future<Either<Failure, PaginatedList<Notification>>> call(
    GetNotificationsParams params,
  ) {
    return _notificationsRepository.getNotifications(
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

class GetNotificationsParams extends Equatable {
  const GetNotificationsParams({this.cursor, this.limit});

  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [cursor, limit];
}

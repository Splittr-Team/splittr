import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/notifications/data/models/notification_model.dart';

part 'notifications_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/notifications')
abstract class NotificationsApiClient {
  @factoryMethod
  factory NotificationsApiClient(Dio dio) = _NotificationsApiClient;

  @GET('/')
  Future<List<NotificationModel>> getNotifications();

  @POST('/read-all')
  Future<void> readAllNotifications();

  @POST('/{id}/read')
  Future<void> readNotification(@Path('id') String id);
}

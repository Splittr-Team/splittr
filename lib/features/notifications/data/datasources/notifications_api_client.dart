import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/notifications/data/models/notifications_response_model.dart';
import 'package:splittr/features/notifications/data/models/update_notification_payload.dart';

part 'notifications_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/notifications')
abstract class NotificationsApiClient {
  @factoryMethod
  factory NotificationsApiClient(Dio dio) = _NotificationsApiClient;

  @GET('/')
  Future<NotificationsResponseModel> getNotifications({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @PATCH('/')
  Future<void> readAllNotifications(
    @Body() UpdateNotificationPayload body,
  );

  @PATCH('/{id}')
  Future<void> readNotification(
    @Path('id') String id,
    @Body() UpdateNotificationPayload body,
  );
}

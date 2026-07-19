import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/models/create_group_payload.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';
import 'package:splittr/features/groups/data/models/join_group_payload.dart';

part 'groups_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/groups')
abstract class GroupsApiClient {
  @factoryMethod
  factory GroupsApiClient(Dio dio) = _GroupsApiClient;

  @GET('/')
  Future<GroupsResponseModel> getGroups({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST('/join')
  Future<GroupModel> joinGroup(@Body() JoinGroupPayload body);

  @POST('/')
  Future<GroupModel> createGroup(@Body() CreateGroupPayload body);
}

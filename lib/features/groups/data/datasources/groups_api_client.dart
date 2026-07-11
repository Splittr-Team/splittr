import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/models/create_group_model.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';

part 'groups_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1/groups')
abstract class GroupsApiClient {
  @factoryMethod
  factory GroupsApiClient(Dio dio) = _GroupsApiClient;

  @GET('/')
  Future<List<GroupModel>> getGroups();

  @POST('/')
  Future<GroupModel> createGroup(@Body() CreateGroupModel body);
}

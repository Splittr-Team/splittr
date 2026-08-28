import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/groups/data/models/add_members_payload.dart';
import 'package:splittr/features/groups/data/models/create_group_payload.dart';
import 'package:splittr/features/groups/data/models/decide_join_request_payload.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';
import 'package:splittr/features/groups/data/models/group_preview_model.dart';
import 'package:splittr/features/groups/data/models/groups_response_model.dart';
import 'package:splittr/features/groups/data/models/join_group_payload.dart';
import 'package:splittr/features/groups/data/models/member_model.dart';
import 'package:splittr/features/groups/data/models/update_member_role_payload.dart';

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

  @GET('/preview')
  Future<GroupPreviewModel> getGroupPreview(
    @Query('inviteCode') String inviteCode,
  );

  @POST('/')
  Future<GroupModel> createGroup(@Body() CreateGroupPayload body);

  @GET('/{id}')
  Future<GroupModel> getGroupById(@Path('id') String id);

  @DELETE('/{id}')
  Future<void> deleteGroup(@Path('id') String id);

  @GET('/{id}/members')
  Future<List<MemberModel>> getMembers(
    @Path('id') String id, {
    @Query('status') String? status,
  });

  @POST('/{id}/members')
  Future<void> addMembers(
    @Path('id') String id,
    @Body() AddMembersPayload body,
  );

  @DELETE('/{id}/members/{userId}')
  Future<void> leaveOrRemoveGroup(
    @Path('id') String id,
    @Path('userId') String userId,
  );

  @PUT('/{id}/members/{userId}/role')
  Future<MemberModel> updateMemberRole(
    @Path('id') String id,
    @Path('userId') String userId,
    @Body() UpdateMemberRolePayload body,
  );

  @POST('/{id}/members/{userId}/decision')
  Future<MemberModel> decideJoinRequest(
    @Path('id') String id,
    @Path('userId') String userId,
    @Body() DecideJoinRequestPayload body,
  );
}

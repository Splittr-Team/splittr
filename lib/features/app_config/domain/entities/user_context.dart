import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_context.freezed.dart';

@freezed
class UserContext with _$UserContext {
  const UserContext({
    required this.isAuthenticated,
    this.userPreferredCurrency,
    this.userFeatureFlags,
  });

  @override
  final bool isAuthenticated;
  @override
  final String? userPreferredCurrency;
  @override
  final Map<String, dynamic>? userFeatureFlags;
}

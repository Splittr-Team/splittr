import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const Profile({
    this.id,
    this.email,
    this.name,
    this.avatarUrl,
    this.defaultCurrency,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? avatarUrl;
  @override
  final String? defaultCurrency;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
}



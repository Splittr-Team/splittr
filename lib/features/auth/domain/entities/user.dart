import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.defaultCurrency,
  });

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? defaultCurrency;
}

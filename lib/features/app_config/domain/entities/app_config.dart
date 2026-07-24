import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splittr/features/app_config/domain/entities/domain_config.dart';
import 'package:splittr/features/app_config/domain/entities/feature_flags.dart';
import 'package:splittr/features/app_config/domain/entities/legal_config.dart';
import 'package:splittr/features/app_config/domain/entities/system_config.dart';
import 'package:splittr/features/app_config/domain/entities/user_context.dart';

part 'app_config.freezed.dart';

@freezed
class AppConfig with _$AppConfig {
  const AppConfig({
    required this.system,
    required this.featureFlags,
    required this.configVersion,
    this.domain,
    this.legal,
    this.userContext,
  });

  @override
  final SystemConfig system;
  @override
  final FeatureFlags featureFlags;
  @override
  final String configVersion;
  @override
  final DomainConfig? domain;
  @override
  final LegalConfig? legal;
  @override
  final UserContext? userContext;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'legal_config.freezed.dart';

@freezed
class LegalConfig with _$LegalConfig {
  const LegalConfig({
    required this.termsOfServiceUrl,
    required this.privacyPolicyUrl,
    required this.faqUrl,
    required this.supportEmail,
  });

  @override
  final String termsOfServiceUrl;
  @override
  final String privacyPolicyUrl;
  @override
  final String faqUrl;
  @override
  final String supportEmail;
}

import 'package:envied/envied.dart';
import 'package:splittr/constants/env/env.dart';

part 'multi_env.g.dart';

@Envied(
  path: '.env.dev',
  name: 'DebugEnv',
  obfuscate: true,
  useConstantCase: true,
)
@Envied(
  path: '.env.prod',
  name: 'ProductionEnv',
  obfuscate: true,
  useConstantCase: true,
)
abstract class MultiEnv {
  static late final MultiEnv instance;

  static void init(Env env) {
    instance = switch (env) {
      Env.dev => _DebugEnv(),
      Env.prod => _ProductionEnv(),
    };
  }

  @EnviedField()
  abstract final String apiBaseUrl;

  @EnviedField()
  abstract final String vercelBypassKey;

  @EnviedField()
  abstract final String deeplinkBaseUrl;
}

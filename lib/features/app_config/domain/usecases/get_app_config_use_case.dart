import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/app_config/domain/entities/app_config.dart';
import 'package:splittr/features/app_config/domain/repositories/app_config_repository.dart';

@lazySingleton
final class GetAppConfigUseCase implements UseCase<AppConfig, NoParams> {
  const GetAppConfigUseCase(this._repository);

  final AppConfigRepository _repository;

  @override
  Future<Either<Failure, AppConfig>> call(NoParams params) {
    return _repository.getAppConfig();
  }
}

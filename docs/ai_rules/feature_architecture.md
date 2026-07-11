# Feature Scaffolding & Architecture Guide (`splittr`)

This guide outlines the standard practices and directory structure for scaffolding and implementing new features within the `splittr` project. It is intended to guide both developers and AI agents in adhering to the codebase's Clean Architecture conventions.

---

## 1. Directory Structure

Every modular feature in `splittr` resides under the `lib/features/` directory and is organized into three layers: `domain`, `data`, and `presentation`.

```text
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   ├── mappers/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── blocs/
    └── ui/
```

> [!IMPORTANT]
> **Use `ui/` instead of `pages/`** for presentation views (e.g. `lib/features/<feature_name>/presentation/ui/`), matching the standard established in the `groups` and `dashboard` features.

### Layer Responsibilities

*   **Domain Layer (`domain/`)**: Pure Dart logic. Contains the business logic, entities, usecase definitions, and abstract repository interfaces. Must not depend on any external libraries (except core libraries like `sky_architecture`).
*   **Data Layer (`data/`)**: Infrastructure. Handles data retrieval, cache, remote API client connections (e.g., Retrofit, Dio), serialization models, mapping data models to domain entities, and concrete repository implementations.
*   **Presentation Layer (`presentation/`)**: User Interface. Contains state management (BLoCs), page forms, state stores, and page UI elements utilizing the `sky_design_system` package.

---

## 2. Scaffolding Workflow

Follow these steps sequentially when building a new feature to ensure layers are independent and correctly structured:

### Step A: Domain Layer

1.  **Define Entities (`domain/entities/`)**: Define the core business models using `@freezed`.
    ```dart
    import 'package:freezed_annotation/freezed_annotation.dart';

    part 'my_feature.freezed.dart';

    @freezed
    class MyFeature with _$MyFeature {
      const MyFeature({
        this.id,
        this.name,
      });

      @override
      final String? id;
      @override
      final String? name;
    }
    ```
2.  **Define Abstract Repository (`domain/repositories/`)**: Declare the contract for data operations.
    ```dart
    import 'package:sky_architecture/sky_architecture.dart';
    import 'package:splittr/features/my_feature/domain/entities/my_feature.dart';

    abstract interface class MyFeatureRepository {
      FutureEitherFailure<List<MyFeature>> getMyFeatures();
    }
    ```
3.  **Define Usecases (`domain/usecases/`)**: Build single-responsibility classes inheriting from `UseCase`. Annotate with `@lazySingleton`.
    ```dart
    import 'package:injectable/injectable.dart';
    import 'package:sky_architecture/sky_architecture.dart';
    import 'package:splittr/features/my_feature/domain/entities/my_feature.dart';
    import 'package:splittr/features/my_feature/domain/repositories/my_feature_repository.dart';

    @lazySingleton
    final class GetMyFeaturesUseCase implements UseCase<List<MyFeature>, NoParams> {
      const GetMyFeaturesUseCase(this._repository);

      final MyFeatureRepository _repository;

      @override
      Future<Either<Failure, List<MyFeature>>> call(NoParams params) {
        return _repository.getMyFeatures();
      }
    }
    ```

### Step B: Data Layer

1.  **Define Models (`data/models/`)**: Create JSON serialization classes using `@JsonSerializable`.
    ```dart
    import 'package:freezed_annotation/freezed_annotation.dart';
    import 'package:json_annotation/json_annotation.dart';

    part 'my_feature_model.g.dart';

    @JsonSerializable()
    class MyFeatureModel {
      const MyFeatureModel({this.id, this.name});

      factory MyFeatureModel.fromJson(Map<String, dynamic> json) =>
          _$MyFeatureModelFromJson(json);

      final String? id;
      final String? name;

      Map<String, dynamic> toJson() => _$MyFeatureModelToJson(this);
    }
    ```
2.  **Define Mappers (`data/mappers/`)**: Create extensions to convert raw models into domain entities.
    ```dart
    import 'package:splittr/features/my_feature/data/models/my_feature_model.dart';
    import 'package:splittr/features/my_feature/domain/entities/my_feature.dart';

    extension MyFeatureModelX on MyFeatureModel {
      MyFeature toDomain() => MyFeature(
        id: id,
        name: name,
      );
    }

    extension MyFeatureModelListX on List<MyFeatureModel> {
      List<MyFeature> toDomain() => map((e) => e.toDomain()).toList();
    }
    ```
3.  **Define Datasources & API Clients (`data/datasources/`)**: Define the local/remote data retrieval contracts and client implementations. Use Retrofit for API endpoints.
    ```dart
    import 'package:injectable/injectable.dart';
    import 'package:retrofit/retrofit.dart';
    import 'package:sky_network/sky_network.dart';
    import 'package:splittr/features/my_feature/data/models/my_feature_model.dart';

    part 'my_feature_api_client.g.dart';

    @lazySingleton
    @RestApi(baseUrl: '/v1/my-feature')
    abstract class MyFeatureApiClient {
      @factoryMethod
      factory MyFeatureApiClient(Dio dio) = _MyFeatureApiClient;

      @GET('/')
      Future<List<MyFeatureModel>> getMyFeatures();
    }
    ```
4.  **Implement Repository (`data/repositories/`)**: Implement the domain repository interface using `@LazySingleton(as: ...)`.
    ```dart
    import 'package:injectable/injectable.dart';
    import 'package:sky_architecture/sky_architecture.dart';
    import 'package:sky_network/sky_network.dart';
    import 'package:splittr/features/my_feature/data/datasources/my_feature_api_client.dart';
    import 'package:splittr/features/my_feature/data/mappers/my_feature.dart';
    import 'package:splittr/features/my_feature/domain/entities/my_feature.dart';
    import 'package:splittr/features/my_feature/domain/repositories/my_feature_repository.dart';

    @LazySingleton(as: MyFeatureRepository)
    final class MyFeatureRepositoryImpl implements MyFeatureRepository {
      MyFeatureRepositoryImpl(this._apiCallHandler, this._apiClient);

      final ApiCallHandler _apiCallHandler;
      final MyFeatureApiClient _apiClient;

      @override
      FutureEitherFailure<List<MyFeature>> getMyFeatures() async {
        final result = await _apiCallHandler.handle(_apiClient.getMyFeatures);
        return result.map((models) => models.toDomain());
      }
    }
    ```

### Step C: Presentation Layer

1.  **Define BloCs, States, & Events (`presentation/blocs/`)**: Build the state management using `sky_bloc` and `@injectable`. Use the `StateStore` pattern for State.

    *   **BLoC Template (`my_feature_bloc.dart`)**:
        ```dart
        import 'dart:async';

        import 'package:injectable/injectable.dart';
        import 'package:sky_bloc/sky_bloc.dart';
        import 'package:splittr/features/my_feature/domain/usecases/get_my_features_usecase.dart';

        part 'my_feature_bloc.freezed.dart';
        part 'my_feature_event.dart';
        part 'my_feature_state.dart';

        @injectable
        final class MyFeatureBloc extends BaseBloc<MyFeatureEvent, MyFeatureState> {
          MyFeatureBloc(this._getMyFeaturesUseCase)
              : super(const MyFeatureState.initial(store: MyFeatureStateStore()));

          final GetMyFeaturesUseCase _getMyFeaturesUseCase;

          @override
          void handleEvents() {
            on<_Started>(_onStarted);
          }

          FutureOr<void> _onStarted(
            _Started event,
            Emitter<MyFeatureState> emit,
          ) async {
            // Event handling logic
          }

          @override
          void started({Map<String, dynamic>? args}) {
            add(const MyFeatureEvent.started());
          }
        }
        ```

    *   **State & Store Template (`my_feature_state.dart`)**:
        ```dart
        part of 'my_feature_bloc.dart';

        @freezed
        sealed class MyFeatureState extends BaseState with _$MyFeatureState {
          const MyFeatureState._();

          const factory MyFeatureState.initial({
            required MyFeatureStateStore store,
          }) = Initial;

          const factory MyFeatureState.onLoadingStateChange({
            required MyFeatureStateStore store,
          }) = OnLoadingStateChange;

          const factory MyFeatureState.onFailure({
            required MyFeatureStateStore store,
            required Failure failure,
          }) = OnFailure;

          @override
          BaseState getLoadingState({required bool loading}) {
            return MyFeatureState.onLoadingStateChange(
              store: store.copyWith(loading: loading),
            );
          }

          @override
          BaseState getFailureState({required Failure failure}) {
            return MyFeatureState.onFailure(
              store: store.copyWith(loading: false),
              failure: failure,
            );
          }
        }

        @freezed
        class MyFeatureStateStore with _$MyFeatureStateStore {
          const MyFeatureStateStore({
            this.loading = false,
          });

          @override
          final bool loading;
        }
        ```

    *   **Event Template (`my_feature_event.dart`)**:
        ```dart
        part of 'my_feature_bloc.dart';

        @freezed
        class MyFeatureEvent extends BaseEvent with _$MyFeatureEvent {
          const MyFeatureEvent._();

          const factory MyFeatureEvent.started() = _Started;
        }
        ```

2.  **Define UI Page/Views (`presentation/ui/`)**: Implement user-facing components. Pages should extend `BasePage` and bind to their corresponding BLoC.
    ```dart
    import 'package:flutter/material.dart';
    import 'package:sky_bloc/sky_bloc.dart';
    import 'package:sky_design_system/sky_design_system.dart';
    import 'package:splittr/di/injection.dart';
    import 'package:splittr/features/my_feature/presentation/blocs/my_feature_bloc.dart';

    class MyFeaturePage extends BasePage<MyFeatureBloc, MyFeatureState> {
      const MyFeaturePage({
        required this.args,
        super.key,
      });

      final Map<String, dynamic>? args;

      @override
      MyFeatureBloc createBloc() => getIt<MyFeatureBloc>()..started(args: args);

      @override
      Widget buildPage(BuildContext context) {
        return const Scaffold(
          body: Center(
            child: AppText.bodyMedium('My Feature'),
          ),
        );
      }
    }
    ```

---

## 3. Dependency Injection & Code Generation

*   **Dependency Injection (DI)**: Inject dependencies using annotations provided by `injectable`.
    *   Use `@lazySingleton` (or `@LazySingleton(as: Interface)`) for long-lived shared services, repositories, and usecases.
    *   Use `@injectable` for short-lived transients, such as `BaseBloc` classes.
    *   Use `@factoryMethod` to annotate custom factory constructors (e.g. Retrofit REST clients).
*   **Build Runner / Code Generation**: Generate implementation and frozen data model files (`.g.dart`, `.freezed.dart`, `.config.dart`) by running:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

---

## 4. Core Package Skill Lookups (`sky_*` packages)

When writing rules or referencing operations for packages prefixed with `sky_` (e.g., `sky_architecture`, `sky_bloc`, `sky_design_system`, `sky_network`), consult their documentation in this priority order:

1.  **Primary Source**:
    Locate the package path via the active local project configurations in `.dart_tool/package_config.json`, then read the `SKILL.md` file within that package's local directory.
    *(Note: Since `.dart_tool` is git-ignored, automated workflows must resolve paths programmatically or utilize secondary/fallback documentation sources to prevent security context leaks).*
2.  **Secondary Source**:
    If local path resolution fails or is restricted, fetch documentation directly from the remote GitHub repository:
    `https://raw.githubusercontent.com/Saurrabhh/sky_core/main/packages/<package_name>/SKILL.md`
    *(e.g., replacing `<package_name>` with `sky_bloc`, `sky_architecture`, etc.)*

---

## 5. General Guidelines

*   **No God Skill Policy**: Every package, module, or distinct feature set must have its own dedicated and focused skill file (`SKILL.md`) outlining its specific instructions and patterns. Never maintain a single global guideline file to cover multiple unrelated modules. This keeps documentation highly granular, context-specific, and easy to maintain.

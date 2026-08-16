import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:splittr/constants/env/env.dart';
import 'package:splittr/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

final ValueNotifier<List<Widget>?> shellAppBarActionsNotifier =
    ValueNotifier<List<Widget>?>(null);

final ValueNotifier<String?> shellAppBarTitleNotifier = ValueNotifier<String?>(
  null,
);

@injectableInit
Future<void> configureDependencies(Env env) =>
    getIt.init(environment: env.name);

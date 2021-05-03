import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:one_person_twitter/respository/auth_repository.dart';
import 'package:one_person_twitter/respository/tweets_repository.dart';
import 'package:one_person_twitter/respository/user_repository.dart';

GetIt locator = GetIt.instance;

setUpLocator() {
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<TweetsRepository>(() => TweetsRepository());
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerFactory<StreamController<bool>>(() => StreamController<bool>());
}

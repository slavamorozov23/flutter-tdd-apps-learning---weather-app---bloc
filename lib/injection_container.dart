import 'package:get_it/get_it.dart';
import 'package:tddlearning/data/data_source/remote_data_source.dart';
import 'package:tddlearning/data/repositories/weather_repository_impl.dart';
import 'package:tddlearning/domain/repositories/weather_repository.dart';
import 'package:tddlearning/domain/usecases/get_current_weather.dart';
import 'package:tddlearning/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => WeatherBloc(locator()));

  locator.registerLazySingleton(() => GetCurrentWeatherUseCase(locator()));

  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(weatherRemoteDataSource: locator()),
  );

  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: locator()),
  );

  locator.registerLazySingleton(() => http.Client());
}

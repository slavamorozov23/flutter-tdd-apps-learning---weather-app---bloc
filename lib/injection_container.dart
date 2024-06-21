import 'package:get_it/get_it.dart';
import 'data/data_source/remote_data_source.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'domain/repositories/weather_repository.dart';
import 'domain/usecases/get_current_weather.dart';
import 'presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;
import 'presentation/cubit/weather_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => WeatherBloc(locator()));
  locator.registerFactory(() => WeatherCubit(locator()));

  locator.registerLazySingleton(() => GetCurrentWeatherUseCase(locator()));

  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(weatherRemoteDataSource: locator()),
  );

  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: locator()),
  );

  locator.registerLazySingleton(() => http.Client());
}

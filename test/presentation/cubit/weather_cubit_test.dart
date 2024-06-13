import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/presentation/cubit/weather_cubit.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherCubit weatherCubit;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherCubit = WeatherCubit(mockGetCurrentWeatherUseCase);
  });

  const testWeather = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testCityName = 'New York';

  test('проверка изначального состояния кубит', () {
    expect(weatherCubit.state, WeatherEmpty());
  });

  blocTest<WeatherCubit, WeatherState>(
    'emits [WeatherLoading, WeatherLoaded] when data is gotten successfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Right(testWeather));
      return weatherCubit;
    },
    act: (cubit) => cubit.cityChanged(testCityName),
    wait: const Duration(milliseconds: 500),
    expect: () => [WeatherLoading(), const WeatherLoaded(testWeather)],
  );

  blocTest<WeatherCubit, WeatherState>(
    'emits [WeatherLoading, WeatherLoadingFailure] when data is gotten unsuccessfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName)).thenAnswer(
          (_) async => const Left(ServerFailure(
              message: 'Ошибка обращения к серверу (ServerException)')));
      return weatherCubit;
    },
    act: (cubit) => cubit.cityChanged(testCityName),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoadFailure('Ошибка обращения к серверу (ServerException)')
    ],
  );
}

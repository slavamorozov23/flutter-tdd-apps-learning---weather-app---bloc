import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/presentation/bloc/weather_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
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

  test('проверка изначального состояния блок', () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>(
    'emits [WeatherLoading, WeatherLoaded] when data is gotten successfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Right(testWeather));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [WeatherLoading(), const WeatherLoaded(testWeather)],
  );

  blocTest<WeatherBloc, WeatherState>(
    'emits [WeatherLoading, WeatherLoadingFailure] when data is gotten unsuccessfully.',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName)).thenAnswer(
          (_) async => const Left(ServerFailure(
              message: 'Ошибка обращения к серверу (ServerException)')));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoadFailure('Ошибка обращения к серверу (ServerException)')
    ],
  );
}

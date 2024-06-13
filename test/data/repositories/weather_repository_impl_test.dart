import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddlearning/core/error/exception.dart';
import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/data/models/weather_model.dart';
import 'package:tddlearning/data/repositories/weather_repository_impl.dart';
import 'package:tddlearning/domain/entities/weather.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;

  late WeatherRepositoryImpl weatherRepositoryImpl;

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(
        weatherRemoteDataSource: mockWeatherRemoteDataSource);
  });

  const testWeatherModel = WeatherModel(
    cityName: 'Zocca',
    main: 'Rain',
    description: 'moderate rain',
    iconCode: '10d',
    temperature: 298.48,
    pressure: 1015,
    humidity: 64,
  ); //Zocca, Rain, moderate rain, 10d, 298.48, 1015, 64

  const testWeatherEntity = WeatherEntity(
    cityName: 'Zocca',
    main: 'Rain',
    description: 'moderate rain',
    iconCode: '10d',
    temperature: 298.48,
    pressure: 1015,
    humidity: 64,
  ); //Zocca, Rain, moderate rain, 10d, 298.48, 1015, 64

  const testCityName = 'Zocca';

  group('получаем текущую погоду', () {
    test('успешное обращение к источнику данных', () async {
      when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
          .thenAnswer((_) async => testWeatherModel);

      final result =
          await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(result, equals(const Right(testWeatherEntity)));
    });

    test('отлов ошибки обращения к серверу', () async {
      when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
          .thenThrow(ServerException());

      final result =
          await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(
          result,
          equals(const Left(ServerFailure(
              message: 'Ошибка обращения к серверу (ServerException)'))));
    });

    test('отлов ошибки отсутствия интернет соединения', () async {
      when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
          .thenThrow(const SocketException(
              'Ошибка - нет подключения к сети (ConnectionFailure)'));

      final result =
          await weatherRepositoryImpl.getCurrentWeather(testCityName);

      expect(
          result,
          equals(const Left(ConnectionFailure(
              message:
                  'Ошибка - нет подключения к сети (ConnectionFailure)'))));
    });
  });
}

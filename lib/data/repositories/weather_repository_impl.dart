import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tddlearning/core/error/exception.dart';
import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/data/data_source/remote_data_source.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
      String cityName) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(
          message: 'Ошибка обращения к серверу (ServerException)'));
    } on SocketException {
      return const Left(ConnectionFailure(
          message: 'Ошибка - нет подключения к сети (ConnectionFailure)'));
    }
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../data_source/remote_data_source.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';

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

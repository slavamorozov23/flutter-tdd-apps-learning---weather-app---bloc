import 'package:dartz/dartz.dart';
import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure,WeatherEntity>> getCurrentWeather(String cityName);
}
import 'package:dartz/dartz.dart';

import 'package:tddlearning/core/error/failure.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository weatherRepository;

  GetCurrentWeatherUseCase(
     this.weatherRepository,
  );

  Future<Either<Failure, WeatherEntity>> execute(String cityName) {
    return weatherRepository.getCurrentWeather(cityName);
  }
}

import 'package:mockito/annotations.dart';
import 'package:tddlearning/data/data_source/remote_data_source.dart';
import 'package:tddlearning/domain/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:tddlearning/domain/usecases/get_current_weather.dart';

@GenerateMocks(
  [WeatherRepository, WeatherRemoteDataSource, GetCurrentWeatherUseCase],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
  ],
)
void main() {}

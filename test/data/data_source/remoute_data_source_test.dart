import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddlearning/core/constants/constants.dart';
import 'package:tddlearning/core/error/exception.dart';
import 'package:tddlearning/data/data_source/remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tddlearning/data/models/weather_model.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late WeatherRemoteDataSourceImpl weatherRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRemoteDataSourceImpl =
        WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  const testCityName = 'Zocca';

  group('получение текущей погоды', () {
    test('получение модели погоды при ответе от сервера 200', () async {
      when(mockHttpClient
              .get(Uri.parse(Urls.currentWeatherByName(testCityName))))
          .thenAnswer((_) async => http.Response(
              readJson('helpers/dummy_data/dummy_weather_response.json'), 200));

      final result =
          await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName);

      expect(result, isA<WeatherModel>());
    });

    test('отлов ошибок получения данных api', () async {
      when(mockHttpClient
              .get(Uri.parse(Urls.currentWeatherByName(testCityName))))
          .thenAnswer((_) async => http.Response('Not found', 404));

      expect(
        () async =>
            await weatherRemoteDataSourceImpl.getCurrentWeather(testCityName),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

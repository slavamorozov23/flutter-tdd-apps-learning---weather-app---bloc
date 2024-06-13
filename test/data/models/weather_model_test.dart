import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tddlearning/data/models/weather_model.dart';
import 'package:tddlearning/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testWeatherModel = WeatherModel(
    cityName: 'Zocca',
    main: 'Rain',
    description: 'moderate rain',
    iconCode: '10d',
    temperature: 298.48,
    pressure: 1015,
    humidity: 64,
  ); //Zocca, Rain, moderate rain, 10d, 298.48, 1015, 64

  test('WeatherModel подкласс WeatherEntity', () async {
    expect(testWeatherModel, isA<WeatherEntity>());

    final Map<String, dynamic> jsonMap =
        json.decode(readJson('helpers/dummy_data/dummy_weather_response.json'));

    final result = WeatherModel.fromJson(jsonMap);

    expect(result, equals(testWeatherModel));
  });

  test('конвертация to json равна ожидаемым данным', () async {
    final result = testWeatherModel.toJson();

    final expectedJsonMap = {
      "weather": [
        {
          "main": "Rain",
          "description": "moderate rain",
          "icon": "10d",
        }
      ],
      "main": {
        "temp": 298.48,
        "pressure": 1015,
        "humidity": 64,
      },
      "name": "Zocca",
    };

    expect(result, equals(expectedJsonMap));
  });
}

import 'dart:convert';

import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;

  const WeatherEntity({
    required this.cityName,
    required this.main,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
  });

  @override
  List<Object> get props {
    return [
      cityName,
      main,
      description,
      iconCode,
      temperature,
      pressure,
      humidity,
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'main': main,
      'description': description,
      'iconCode': iconCode,
      'temperature': temperature,
      'pressure': pressure,
      'humidity': humidity,
    };
  }

  factory WeatherEntity.fromMap(Map<String, dynamic> map) {
    return WeatherEntity(
      cityName: map['cityName'] ?? '',
      main: map['main'] ?? '',
      description: map['description'] ?? '',
      iconCode: map['iconCode'] ?? '',
      temperature: map['temperature']?.toDouble() ?? 0.0,
      pressure: map['pressure']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
    );
  }

  factory WeatherEntity.fromJson(String source) =>
      WeatherEntity.fromMap(json.decode(source));
}

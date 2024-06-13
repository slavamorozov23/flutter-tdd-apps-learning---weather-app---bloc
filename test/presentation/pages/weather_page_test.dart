import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/presentation/bloc/weather_bloc.dart';
import 'package:tddlearning/presentation/pages/weather_page.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;
  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null; //реальные ответы от http запросов для moktail
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>(
      create: (context) => mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const testWeather = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  testWidgets('текстовое поле меняет состояние на - загрузка -',
      (widgetTester) async {
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await widgetTester.enterText(textField, 'New York');
    await widgetTester.pump();
    expect(find.text("New York"), findsOneWidget);
  });

  testWidgets('прогресс индикатор во время загрузки данных',
      (widgetTester) async {
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('отображения данных о погоде', (widgetTester) async {
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherLoaded(testWeather));
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
    await widgetTester.pumpAndSettle(); //ожидание отложенных операций
    expect(find.byKey(const Key('weather_data')), findsOneWidget);
  });
}

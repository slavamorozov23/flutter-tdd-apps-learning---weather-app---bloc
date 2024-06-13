import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/presentation/cubit/weather_cubit.dart';
import 'package:tddlearning/presentation/pages/weather_cubit_page.dart';

class MockWeatherCubit extends MockCubit<WeatherState>
    implements WeatherCubit {}

void main() {
  late MockWeatherCubit mockWeatherCubit;
  setUp(() {
    mockWeatherCubit = MockWeatherCubit();
    HttpOverrides.global = null; //реальные ответы от http запросов для mocktail
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherCubit>(
      create: (context) => mockWeatherCubit,
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

  group('тестирование cubit страницы с поиском погоды', () {
    testWidgets('текстовое поле меняет состояние на - загрузка -',
        (widgetTester) async {
      when(() => mockWeatherCubit.state).thenReturn(WeatherEmpty());
      await widgetTester
          .pumpWidget(makeTestableWidget(const WeatherCubitPage()));

      var textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await widgetTester.enterText(textField, 'New York');
      await widgetTester.pump();
      expect(find.text("New York"), findsOneWidget);
    });

    testWidgets('прогресс индикатор во время загрузки данных',
        (widgetTester) async {
      when(() => mockWeatherCubit.state).thenReturn(WeatherLoading());
      await widgetTester
          .pumpWidget(makeTestableWidget(const WeatherCubitPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('отображения данных о погоде', (widgetTester) async {
      when(() => mockWeatherCubit.state)
          .thenReturn(const WeatherLoaded(testWeather));
      await widgetTester
          .pumpWidget(makeTestableWidget(const WeatherCubitPage()));
      await widgetTester.pumpAndSettle(); //ожидание отложенных операций
      expect(find.byKey(const Key('weather_data')), findsOneWidget);
    });
  });
}

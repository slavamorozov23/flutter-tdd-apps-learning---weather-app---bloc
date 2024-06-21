import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';

part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherCubit(this._getCurrentWeatherUseCase) : super(WeatherEmpty());

  void cityChanged(String cityName) async {
    emit(WeatherLoading());
    final result = await _getCurrentWeatherUseCase.execute(cityName);
    result.fold((failure) {
      emit(WeatherLoadFailure(failure.message));
    }, (data) {
      log('кубит загрузил данные!');
      emit(WeatherLoaded(data));
    });
  }

  Stream<WeatherState> transformEvents(Stream<String> events) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap((cityName) {
      cityChanged(cityName);
      return stream;
    });
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      final state = WeatherState.fromMap(json);
      return state;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    return state.toMap();
  }
}

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import 'package:rxdart/rxdart.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherBloc(this._getCurrentWeatherUseCase) : super(const WeatherEmpty()) {
    on<OnCityChanged>((event, emit) async {
      emit(const WeatherLoading());
      final result = await _getCurrentWeatherUseCase.execute(event.cityName);
      result.fold((failure) {
        emit(WeatherLoadFailure(failure.message));
      }, (data) {
        emit(WeatherLoaded(data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

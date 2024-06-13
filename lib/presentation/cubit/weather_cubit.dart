import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tddlearning/domain/entities/weather.dart';
import 'package:tddlearning/domain/usecases/get_current_weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;
  WeatherCubit(this._getCurrentWeatherUseCase) : super(WeatherEmpty());

  void cityChanged(String cityName) async {
    emit(WeatherLoading());
    final result = await _getCurrentWeatherUseCase.execute(cityName);
    result.fold((failure) {
      emit(WeatherLoadFailure(failure.message));
    }, (data) {
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
}

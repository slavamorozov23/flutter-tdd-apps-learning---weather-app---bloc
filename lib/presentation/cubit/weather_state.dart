part of 'weather_cubit.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];

  factory WeatherState.fromMap(Map<String, dynamic> map) {
    switch (map['state']) {
      case 'WeatherEmpty':
        return WeatherEmpty();
      case 'WeatherLoading':
        return WeatherLoading();
      case 'WeatherLoaded':
        return WeatherLoaded(WeatherEntity.fromMap(map['result']));
      case 'WeatherLoadFailure':
        return WeatherLoadFailure(map['message']);
      default:
        return WeatherEmpty();
    }
  }

  Map<String, dynamic> toMap() {
    if (this is WeatherEmpty) {
      return {'state': 'WeatherEmpty'};
    } else if (this is WeatherLoading) {
      return {'state': 'WeatherLoading'};
    } else if (this is WeatherLoaded) {
      return {
        'state': 'WeatherLoaded',
        'result': (this as WeatherLoaded).result.toJson()
      };
    } else if (this is WeatherLoadFailure) {
      return {
        'state': 'WeatherLoadFailure',
        'message': (this as WeatherLoadFailure).message
      };
    }
    return {'state': 'WeatherEmpty'};
  }
}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity result;

  const WeatherLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  const WeatherLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

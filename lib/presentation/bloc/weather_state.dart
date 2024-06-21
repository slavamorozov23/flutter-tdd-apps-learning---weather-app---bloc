part of 'weather_bloc.dart';

enum WeatherStateStatus { empty, loading, loaded, failure }

abstract class WeatherState extends Equatable {
  final WeatherStateStatus status;

  const WeatherState(this.status);

  factory WeatherState.fromJson(Map<String, dynamic> json) {
    switch (json['status']) {
      case 'loaded':
        return WeatherLoaded(WeatherEntity.fromJson(json['weather']));
      case 'failure':
        return WeatherLoadFailure(json['message']);
      case 'loading':
        return const WeatherLoading();
      case 'empty':
      default:
        return const WeatherEmpty();
    }
  }

  Map<String, dynamic> toJson();
}

class WeatherEmpty extends WeatherState {
  const WeatherEmpty() : super(WeatherStateStatus.empty);

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() => {'status': 'empty'};
}

class WeatherLoading extends WeatherState {
  const WeatherLoading() : super(WeatherStateStatus.loading);

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() => {'status': 'loading'};
}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;

  const WeatherLoaded(this.weather) : super(WeatherStateStatus.loaded);

  @override
  List<Object?> get props => [weather];

  @override
  Map<String, dynamic> toJson() => {
        'status': 'loaded',
        'weather': weather.toJson(),
      };
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  const WeatherLoadFailure(this.message) : super(WeatherStateStatus.failure);

  @override
  List<Object?> get props => [message];

  @override
  Map<String, dynamic> toJson() => {
        'status': 'failure',
        'message': message,
      };
}

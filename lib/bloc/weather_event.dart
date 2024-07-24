part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FeatchWeather extends WeatherEvent {
  final Position position;
  const FeatchWeather(this.position);
  @override
  List<Object> get props => [position];
}

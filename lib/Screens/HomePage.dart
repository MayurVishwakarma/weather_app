import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Components/Octagon.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: Stack(
          children: [
            const BackgroundDecorations(),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherSuccess) {
                  return WeatherInfo(weather: state.weather);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () async {
          await fetchWeather(context);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> fetchWeather(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    context.read<WeatherBloc>().add(FeatchWeather(position));
  }
}

class BackgroundDecorations extends StatelessWidget {
  const BackgroundDecorations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(-2, -0.9),
          child: Container(
            height: 300,
            width: 400,
            decoration:
                const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(2, 0.1),
          child: Container(
            height: 300,
            width: 300,
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(-1, 0.9),
          child: ClipPath(
            clipper: OctagonClipper(),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final Weather weather;

  const WeatherInfo({required this.weather, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationText(areaName: weather.areaName),
          const SizedBox(height: 8),
          GreetingText(hour: DateTime.now().hour),
          WeatherIcon(code: weather.weatherConditionCode),
          Center(
            child: TemperatureText(temperature: weather.temperature!.celsius),
          ),
          Center(
            child: WeatherMainText(main: weather.weatherMain),
          ),
          const SizedBox(height: 5),
          Center(
            child: DateTimeText(date: weather.date),
          ),
          const SizedBox(height: 30),
          SunriseSunsetInfo(sunrise: weather.sunrise, sunset: weather.sunset),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(color: Colors.grey),
          ),
          TempMaxMinInfo(tempMax: weather.tempMax, tempMin: weather.tempMin),
        ],
      ),
    );
  }
}

class LocationText extends StatelessWidget {
  final String? areaName;

  const LocationText({required this.areaName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '📍 $areaName',
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
    );
  }
}

class GreetingText extends StatelessWidget {
  final int hour;

  const GreetingText({required this.hour, Key? key}) : super(key: key);

  String getGreeting() {
    if (hour >= 6 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 16) {
      return 'Good Afternoon';
    } else if (hour >= 16 && hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getGreeting(),
      style: const TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}

class WeatherIcon extends StatelessWidget {
  final int? code;

  const WeatherIcon({required this.code, Key? key}) : super(key: key);

  Widget getWeatherIcon() {
    if (code == null) {
      return Image.asset('assets/7.png');
    } else if (code! >= 200 && code! < 300) {
      return Image.asset('assets/1.png');
    } else if (code! >= 300 && code! < 400) {
      return Image.asset('assets/2.png');
    } else if (code! >= 500 && code! < 600) {
      return Image.asset('assets/3.png');
    } else if (code! >= 600 && code! < 700) {
      return Image.asset('assets/4.png');
    } else if (code! >= 700 && code! < 800) {
      return Image.asset('assets/5.png');
    } else if (code! == 800) {
      return Image.asset('assets/6.png');
    } else if (code! > 800 && code! <= 804) {
      return Image.asset('assets/7.png');
    } else {
      return Image.asset('assets/7.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return getWeatherIcon();
  }
}

class TemperatureText extends StatelessWidget {
  final double? temperature;

  const TemperatureText({required this.temperature, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${temperature!.round()} °C',
      style: const TextStyle(
          color: Colors.white, fontSize: 55, fontWeight: FontWeight.w600),
    );
  }
}

class WeatherMainText extends StatelessWidget {
  final String? main;

  const WeatherMainText({required this.main, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      main!.toUpperCase(),
      style: const TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
    );
  }
}

class DateTimeText extends StatelessWidget {
  final DateTime? date;

  const DateTimeText({required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('EEEE dd •').add_jm().format(date!),
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
    );
  }
}

class SunriseSunsetInfo extends StatelessWidget {
  final DateTime? sunrise;
  final DateTime? sunset;

  const SunriseSunsetInfo(
      {required this.sunrise, required this.sunset, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('assets/11.png', scale: 8),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sunrise',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                const SizedBox(height: 3),
                Text(DateFormat().add_jm().format(sunrise!),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Image.asset('assets/12.png', scale: 8),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sunset',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                const SizedBox(height: 3),
                Text(DateFormat().add_jm().format(sunset!),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TempMaxMinInfo extends StatelessWidget {
  final Temperature? tempMax;
  final Temperature? tempMin;

  const TempMaxMinInfo({required this.tempMax, required this.tempMin, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('assets/13.png', scale: 8),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Temp Max',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                const SizedBox(height: 3),
                Text("${tempMax!.celsius!.round()} °C",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Image.asset('assets/14.png', scale: 8),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Temp Min',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
                const SizedBox(height: 3),
                Text("${tempMin!.celsius!.round()} °C",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

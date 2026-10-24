class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;
  final double? pressure;

  CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    this.pressure,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      feelsLike: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      isDay: json['is_day'] == 1,
      pressure: json['pressure_msl'] != null
          ? (json['pressure_msl'] as num).toDouble()
          : null,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });
}

class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherData({required this.current, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(json['current']);

    final dailyJson = json['daily'];
    final List<String> dates = List<String>.from(dailyJson['time']);
    final List<dynamic> codes = dailyJson['weather_code'];
    final List<dynamic> maxTemps = dailyJson['temperature_2m_max'];
    final List<dynamic> minTemps = dailyJson['temperature_2m_min'];

    final List<DailyForecast> days = [];
    for (int i = 0; i < dates.length; i++) {
      days.add(DailyForecast(
        date: DateTime.parse(dates[i]),
        tempMax: (maxTemps[i] as num).toDouble(),
        tempMin: (minTemps[i] as num).toDouble(),
        weatherCode: (codes[i] as num).toInt(),
      ));
    }

    return WeatherData(current: current, daily: days);
  }
}
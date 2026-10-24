import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> fetchWeather(double latitude, double longitude) async {
    final today = DateTime.now();
    // weekday: 1 = понедельник ... 7 = воскресенье
    final int pastDays = today.weekday - 1;       // сколько дней прошло с Пн
    final int forecastDays = 8 - today.weekday;   // сегодня + дни до Вс

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'timezone': 'auto',
      'past_days': pastDays.toString(),
      'forecast_days': forecastDays.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,is_day,pressure_msl',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
    });

    final response = await http.get(uri);

    // Проверка статус-кода — то, о чём говорил препод
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherData.fromJson(data);
    } else {
      throw Exception('Не удалось загрузить погоду (код ${response.statusCode})');
    }
  }
}
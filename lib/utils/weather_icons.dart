import 'package:flutter/material.dart';

class WeatherInfo {
  final IconData icon;
  final String description;
  const WeatherInfo(this.icon, this.description);
}

WeatherInfo getWeatherInfo(int code, {bool isDay = true}) {
  switch (code) {
    case 0:
      return WeatherInfo(
          isDay ? Icons.wb_sunny : Icons.nightlight_round, 'Ясно');
    case 1:
      return const WeatherInfo(Icons.wb_cloudy, 'Малооблачно');
    case 2:
      return const WeatherInfo(Icons.wb_cloudy, 'Переменная облачность');
    case 3:
      return const WeatherInfo(Icons.cloud, 'Облачно');
    case 45:
    case 48:
      return const WeatherInfo(Icons.cloud, 'Туман');
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return const WeatherInfo(Icons.umbrella, 'Морось');
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return const WeatherInfo(Icons.umbrella, 'Дождь');
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return const WeatherInfo(Icons.ac_unit, 'Снег');
    case 95:
    case 96:
    case 99:
      return const WeatherInfo(Icons.flash_on, 'Гроза');
    default:
      return const WeatherInfo(Icons.help_outline, 'Нет данных');
  }
}
import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';
import '../utils/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  String _cityName = presetCities.first.name;
  double _latitude = presetCities.first.latitude;
  double _longitude = presetCities.first.longitude;
  bool _isCurrentLocation = false;

  WeatherData? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;

  static const _months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
  ];

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_isCurrentLocation) {
        final position = await _locationService.getCurrentPosition();
        _latitude = position.latitude;
        _longitude = position.longitude;
      }
      final data = await _weatherService.fetchWeather(_latitude, _longitude);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _selectCity(CityInfo city) {
    setState(() {
      _cityName = city.name;
      _latitude = city.latitude;
      _longitude = city.longitude;
      _isCurrentLocation = false;
    });
    _loadWeather();
  }

  void _selectCurrentLocation() {
    setState(() {
      _cityName = 'Моё местоположение';
      _isCurrentLocation = true;
    });
    _loadWeather();
  }

  LinearGradient _gradientForNow() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF8C42), Color(0xFFD64550)], // утро
      );
    } else if (hour >= 11 && hour < 18) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5B7FDE), Color(0xFF6C4AB6)], // день
      );
    }
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF141E30), Color(0xFF0A0E17)], // ночь
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF20232B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Выберите город',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.my_location, color: Colors.white),
                title: const Text('Моё местоположение',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _selectCurrentLocation();
                },
              ),
              const Divider(color: Colors.white24),
              ...presetCities.map((city) => ListTile(
                    leading:
                        const Icon(Icons.location_city, color: Colors.white),
                    title: Text(city.name,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _selectCity(city);
                    },
                  )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _gradientForNow()),
        child: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(_errorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadWeather,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    final weather = _weatherData!;
    final info =
        getWeatherInfo(weather.current.weatherCode, isDay: weather.current.isDay);
    final today = DateTime.now();

    return RefreshIndicator(
      onRefresh: _loadWeather,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _showCityPicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_cityName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(info.description,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ),
          const SizedBox(height: 20),
          Icon(info.icon, color: Colors.white, size: 90),
          const SizedBox(height: 12),
          Center(
            child: Text('${weather.current.temperature.round()}°',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('Ощущается как ${weather.current.feelsLike.round()}°',
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
                '${today.day} ${_months[today.month - 1]} ${today.year}',
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoItem(
                  icon: Icons.water_drop, value: '${weather.current.humidity}%'),
              _InfoItem(
                  icon: Icons.air,
                  value: '${weather.current.windSpeed.round()} км/ч'),
              if (weather.current.pressure != null)
                _InfoItem(
                    icon: Icons.speed,
                    value: '${weather.current.pressure!.round()} гПа'),
            ],
          ),
          const SizedBox(height: 28),
          const Divider(color: Colors.white24),
          ...weather.daily.map((d) => _DayRow(day: d)),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  const _InfoItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final DailyForecast day;
  const _DayRow({required this.day});

  static const _weekdayNames = [
    'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'
  ];

  @override
  Widget build(BuildContext context) {
    final info = getWeatherInfo(day.weatherCode);
    final now = DateTime.now();
    final isToday = day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
    final label = isToday ? 'Сегодня' : _weekdayNames[day.date.weekday - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
          ),
          Icon(info.icon, color: Colors.white70, size: 20),
          const SizedBox(width: 14),
          Text('${day.tempMax.round()}°',
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Text('${day.tempMin.round()}°',
              style: const TextStyle(color: Colors.white54, fontSize: 15)),
        ],
      ),
    );
  }
}
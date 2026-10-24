class CityInfo {
  final String name;
  final double latitude;
  final double longitude;

  const CityInfo({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

const List<CityInfo> presetCities = [
  CityInfo(name: 'Челябинск', latitude: 55.1644, longitude: 61.4368),
  CityInfo(name: 'Москва', latitude: 55.7558, longitude: 37.6173),
  CityInfo(name: 'Санкт-Петербург', latitude: 59.9311, longitude: 30.3609),
  CityInfo(name: 'Екатеринбург', latitude: 56.8389, longitude: 60.6057),
];
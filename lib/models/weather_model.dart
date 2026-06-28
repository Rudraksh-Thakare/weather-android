class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int visibility;
  final String condition;
  final String description;
  final String iconCode;
  final int sunrise;
  final int sunset;
  final int timezone;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibility: (json['visibility'] as num?)?.toInt() ?? -1,
      condition: json['weather'][0]['main'] ?? 'Clear',
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      sunrise: json['sys']['sunrise'] as int,
      sunset: json['sys']['sunset'] as int,
      timezone: json['timezone'] as int,
    );
  }

  double get temperatureC => temperature - 273.15;
  double get feelsLikeC => feelsLike - 273.15;
  double get tempMinC => tempMin - 273.15;
  double get tempMaxC => tempMax - 273.15;

  double get temperatureF => (temperatureC * 9 / 5) + 32;
  double get feelsLikeF => (feelsLikeC * 9 / 5) + 32;

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  bool get isNight => iconCode.endsWith('n');

  /// Returns true if visibility data was provided by the API
  bool get hasVisibility => visibility >= 0;

  /// Visibility in km, formatted as string
  String get visibilityText {
    if (!hasVisibility) return 'N/A';
    if (visibility >= 1000) {
      return '${(visibility / 1000).toStringAsFixed(1)} km';
    }
    return '$visibility m';
  }
}

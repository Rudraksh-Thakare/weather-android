import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'detail_chip.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isCelsius;
  final VoidCallback onToggleUnit;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isCelsius,
    required this.onToggleUnit,
  });

  String _formatTemp(double tempC) {
    if (isCelsius) {
      return '${tempC.round()}°C';
    } else {
      return '${((tempC * 9 / 5) + 32).round()}°F';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // City & Country
        Text(
          '${weather.cityName}, ${weather.country}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _getFormattedDate(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),

        const SizedBox(height: 24),

        // Weather Icon (network image)
        Image.network(
          weather.iconUrl,
          width: 110,
          height: 110,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            _getWeatherIcon(weather.condition),
            size: 100,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),

        const SizedBox(height: 8),

        // Temperature — tap to toggle unit
        GestureDetector(
          onTap: onToggleUnit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCelsius
                    ? '${weather.temperatureC.round()}'
                    : '${weather.temperatureF.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 90,
                  fontWeight: FontWeight.w200,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  isCelsius ? '°C' : '°F',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tap to toggle hint
        GestureDetector(
          onTap: onToggleUnit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Tap to switch to ${isCelsius ? '°F' : '°C'}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Weather condition description
        Text(
          weather.description.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 6),

        // Min / Max
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'H: ${_formatTemp(weather.tempMaxC)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'L: ${_formatTemp(weather.tempMinC)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 36),

        // Detail chips grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            DetailChip(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${weather.humidity}%',
            ),
            DetailChip(
              icon: Icons.air_rounded,
              label: 'Wind Speed',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            DetailChip(
              icon: Icons.thermostat_outlined,
              label: 'Feels Like',
              value: _formatTemp(weather.feelsLikeC),
            ),
            DetailChip(
              icon: Icons.visibility_outlined,
              label: 'Visibility',
              value: weather.visibilityText,
            ),
          ],
        ),
      ],
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'clouds':
        return Icons.cloud_rounded;
      case 'rain':
      case 'drizzle':
        return Icons.grain_rounded;
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}

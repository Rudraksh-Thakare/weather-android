import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config/api_config.dart';

class WeatherService {
  static const String _apiKey = ApiConfig.openWeatherApiKey;
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String city) async {
    final Uri url = Uri.parse(
      '$_baseUrl?q=${Uri.encodeComponent(city)}&appid=$_apiKey',
    );

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw WeatherException(
          'City "$city" not found. Please check the spelling and try again.',
        );
      } else if (response.statusCode == 401) {
        throw WeatherException(
          'Invalid API key. Please check your configuration.',
        );
      } else {
        final body = json.decode(response.body);
        throw WeatherException(
          body['message'] ?? 'Something went wrong. Please try again.',
        );
      }
    } on SocketException {
      throw WeatherException(
        'No internet connection. Please check your network and try again.',
      );
    } on FormatException {
      throw WeatherException(
        'Failed to parse weather data. Please try again.',
      );
    } on WeatherException {
      rethrow;
    } catch (e) {
      throw WeatherException('An unexpected error occurred. Please try again.');
    }
  }
}

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}
